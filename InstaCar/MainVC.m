//
//  MainVC.m
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "MainVC.h"
#import "Utils.h"
#import "ShareKit.h"
#import "ImageEditor.h"
#import "SHKSharer.h"
#import "DataManager.h"

#define SWITCH_TIME 1.0
#define IMAGE_SIDE_SIZE 918.0

typedef enum {
    COLLAPSE,
    EXPAND
} ButtonTransformAction;

@interface MainVC (){
    MainNavController *navCon;
    BOOL buttonsInInitialState;
    BOOL isChangingPage;
    BOOL imageInProcessing;
    
    SkinViewBase *activeSkin;
    UISwipeGestureRecognizer *swipeUp;
    UISwipeGestureRecognizer *swipeDown;
    SMPageControl *pageControl;
    
    ALAssetsLibrary *assetsLibrary;
    ImageEditor *imageEditor;
    __weak UIImage *selectedImage;
    ADBannerView *bannerView;
}

@end

@implementation MainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.btnMiddleLeft setImage:[UIImage imageNamed:@"PicLandscape.png"] forState:UIControlStateNormal];
    [self.btnMiddleLeft setTitle:@"" forState:UIControlStateNormal];
    
    [self.btnMiddleRight setImage:[UIImage imageNamed:@"Repeat.png"] forState:UIControlStateNormal];
    [self.btnMiddleRight setTitle:@"" forState:UIControlStateNormal];
    
    navCon = (MainNavController*)self.navigationController;
    navCon.dataSelectionChangeDelegate = self;
    navCon.menuControllerDelegate = self;
    
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    buttonsInInitialState = YES;
    isChangingPage = NO;
    selectedImage = nil;
    imageInProcessing = NO;
    self.activityShareInProgress.hidden = YES;
    
    [self initCaptureManager];
    
    [self initPageControl];
    
    [self initSkins];
    
    [self initGestures];
    
    // iAd will be initialised when the view appeared or when first launch info screen has gone
    
    // banner view container is initially hidden and will remain so if app is running as full version
    self.constraintViewAdContainerHeight.constant = 0.0;
    
    self.scrollSkins.delegate = self;
    [self.view bringSubviewToFront:self.scrollSkins];
}

-(void)viewDidAppear:(BOOL)animated{
    CGPoint convertedPreviewPoint = [self.imagePreview convertPoint:self.imagePreview.frame.origin toView:nil];
    self.captureManager.imageTopCropMargin = convertedPreviewPoint.y;
    
    self.constraintButtonsCoverViewHeight.constant = [self calcPageControlHeight];
    
    if (NO == [DataManager getHasLaunchedBefore]){
        FirstTimeInfoVC *infoVC = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"firstTimeInfoVC"];
        infoVC.delegate = self;
        [self addChildViewController:infoVC];
        [self.view addSubview:infoVC.view];
    } else {
        [self initIAd];
    }
}

#pragma mark Initialization

-(void)initCaptureManager{
    // Set up and run the capture manager
    self.captureManager = [[CaptureSessionManager alloc] init];
    [self.captureManager addVideoInputFrontCamera:NO];
    [self.captureManager addStillImageOutput];
    [self.captureManager addVideoPreviewLayer];
    
    [self initPreviewLayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageCaptured) name:kImageCapturedSuccessfully object:nil];
    [self.captureManager.captureSession startRunning];
}

-(void)initPreviewLayer{
    if (!self.captureManager){
        return;
    }
    
    CGRect layerRect = self.imagePreview.frame;
    [self.captureManager.previewLayer setBounds:layerRect];
    [self.captureManager.previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
    [self.imagePreview.layer addSublayer:self.captureManager.previewLayer];
}

-(void)initGestures{
    swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.scrollSkins addGestureRecognizer:swipeUp];
    
    swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.scrollSkins addGestureRecognizer:swipeDown];
}

-(void)initSkins{
    SkinSet *skinSet = [SkinProvider getInstance].selectedSkinSet;
    activeSkin = [skinSet getSkinAtIndex:0];

	self.scrollSkins.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    const unsigned short pageCount = [skinSet getSkinsCount];
    const int skinWidth = 320;
    
    // add skin views to the scroll area
    for (unsigned short i = 0; i < pageCount; i++) {
        SkinViewBase *skinToAdd = [skinSet getSkinAtIndex:i];
		
		CGRect skinRect = skinToAdd.frame;
        skinRect.origin.x = i * skinWidth;
        skinRect.origin.y = 0;
        
		skinToAdd.frame = skinRect;
        
        [self.scrollSkins addSubview:skinToAdd];
	}
    
	[self.scrollSkins setContentSize:CGSizeMake(skinWidth * pageCount, [self.scrollSkins bounds].size.height)];
    pageControl.numberOfPages = pageCount;
}

-(void)initPageControl{
    if (pageControl){
        return;
    }
    
    CGRect pageControlFrame = CGRectMake(0, 0, self.pageControlContainer.bounds.size.width, 10.0);
    pageControl = [[SMPageControl alloc] initWithFrame:pageControlFrame];
    pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    pageControl.userInteractionEnabled = NO;
    pageControl.indicatorDiameter = 4.0f;
    pageControl.indicatorMargin = 3.0f;
    
    pageControl.backgroundColor = [UIColor clearColor];
    
    [self.pageControlContainer addSubview:pageControl];
}

-(void)initIAd{
    if (NO == [DataManager isFullVersion] && !bannerView){
        bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        bannerView.delegate = self;
        bannerView.frame = CGRectMake(0, 0, self.iAdView.bounds.size.width, self.iAdView.bounds.size.height);
        
        [self.iAdView addSubview:bannerView];
    }
}

#pragma Banner view delegate

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    if (NO == [DataManager isFullVersion] && self.constraintViewAdContainerHeight.constant == 0){
        self.constraintViewAdContainerHeight.constant = 50.0;
        self.constraintButtonsCoverViewHeight.constant = [self calcPageControlHeight];
        [UIView animateWithDuration:0.25
                         animations:^(void){
                             [self.view layoutIfNeeded];
                         }
         ];
    }
}

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    if (NO == [DataManager isFullVersion] && self.constraintViewAdContainerHeight.constant == 50.0){
        self.constraintViewAdContainerHeight.constant = 0.0;
        self.constraintButtonsCoverViewHeight.constant = [self calcPageControlHeight];
        
        [UIView animateWithDuration:0.25
                         animations:^(void){
                             [self.view layoutIfNeeded];
                         }
         ];
    }
}

#pragma UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (isChangingPage){
        return;
    }
    
	// Switch page at 50% across
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    activeSkin = [[SkinProvider getInstance].selectedSkinSet getSkinAtIndex:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender{
    isChangingPage = NO;
}

#pragma mark SelectedDataChangeActionProtocol

-(void) selectedData:(SelectedDataChange)dataType changedTo:(id)newValue{
    if (dataType == SKIN_SET){
        // clean up the scroll area
        for (UIView *subview in self.scrollSkins.subviews){
            [subview removeFromSuperview];
        }
        
        [DataManager setSelectedSkinSet:newValue];
        
        [self initSkins];
        
        // if any car is currently selected - apply it to newly selected skinset
        [self applyCurrentlySelectedCarsToNewlySelectedSkin];
    } else { // other fields are skin relevant so pass the update to selected skin set
        [[SkinProvider getInstance].selectedSkinSet updateData:newValue ofType:dataType];
    }
}

#pragma mark FirstTimeInfoVC delegate

-(void)firstTimeVCNeedsToDismiss:(FirstTimeInfoVC*)viewController{
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    [self initIAd];
    [DataManager setHasLaunchedBefore];
}

#pragma mark Gestures

-(void)swipeUp{
    if (imageInProcessing){
        return;
    }
    
    [activeSkin moveContentUp];
}

-(void)swipeDown{
    if (imageInProcessing){
        return;
    }
    
    [activeSkin moveContentDown];
}

#pragma mark Switching buttons

-(void) switchButtons{
    [self collapseButtons];
    [NSTimer scheduledTimerWithTimeInterval:SWITCH_TIME/2.0 target:self selector:@selector(expandButtons) userInfo:nil repeats:NO];
}

-(void)collapseButtons{
    [UIView animateWithDuration:SWITCH_TIME / 2.0
            delay:0.0
            options:UIViewAnimationOptionAllowAnimatedContent
            animations:^{
                self.constraintButtonsCoverViewHeight.constant = self.view.bounds.size.height - self.constraintViewAdContainerHeight.constant - self.pageControlContainer.frame.origin.y;
                
                self.btnMiddleLeft.titleLabel.alpha = 0.0;
                self.btnMiddle.titleLabel.alpha = 0.0;
                self.btnMiddleRight.titleLabel.alpha = 0.0;
                
                [self.view layoutIfNeeded];
            }
            completion:^(BOOL finished){
                if (buttonsInInitialState){
                    self.constraintMidBtnLeftWidth.constant = 96.0;
                    [self.btnMiddleLeft setTitle:@"New photo" forState:UIControlStateNormal];
                    [self.btnMiddleLeft setImage:nil forState:UIControlStateNormal];
                    
                    self.constraintMidBtnRigthWidth.constant = 96.0;
                    [self.btnMiddleRight setTitle:@"Share" forState:UIControlStateNormal];
                    [self.btnMiddleRight setImage:nil forState:UIControlStateNormal];
                } else {
                    self.constraintMidBtnLeftWidth.constant = 64.0;
                    [self.btnMiddleLeft setImage:[UIImage imageNamed:@"PicLandscape.png"] forState:UIControlStateNormal];
                    [self.btnMiddleLeft setTitle:@"" forState:UIControlStateNormal];
                    
                    self.constraintMidBtnRigthWidth.constant = 64.0;
                    [self.btnMiddleRight setImage:[UIImage imageNamed:@"Repeat.png"] forState:UIControlStateNormal];
                    [self.btnMiddleRight setTitle:@"" forState:UIControlStateNormal];
                }
            }
     ];
}

-(void)expandButtons{
    [UIView animateWithDuration:SWITCH_TIME / 2.0
            delay:0.0
            options:UIViewAnimationOptionAllowAnimatedContent
            animations:^{
                self.constraintButtonsCoverViewHeight.constant = [self calcPageControlHeight];
               
                self.btnMiddleLeft.titleLabel.alpha = 1.0;
                self.btnMiddle.titleLabel.alpha = 1.0;
                self.btnMiddleRight.titleLabel.alpha = 1.0;
            
                [self.view layoutIfNeeded];
            }
            completion:^(BOOL finished){
                buttonsInInitialState = !buttonsInInitialState;
            }
    ];
}

- (IBAction)btnMiddleLeftPressed {
    if (buttonsInInitialState){
        [self doPickPhotoPressed];
    } else {
        [self doPickNewPhotoPressed];
    }
}

- (IBAction)btnMiddleRightPressed {
    if (buttonsInInitialState){
        [self doCamSettingsPressed];
    } else {
        [self doSharePressed];
    }
}

#pragma mark Button Actions

- (IBAction)btnLocationPressed:(id)sender {
    if (imageInProcessing){
        return;
    }
    
    [navCon setSideViewController:LOCATIONS andShowOnTheLeftSide:YES];
}

- (IBAction)btnMiddlePressed {
    if (buttonsInInitialState){
        [self.captureManager captureStillImage];
    }
}

- (IBAction)btnSkinsPressed:(id)sender {
    if (imageInProcessing){
        return;
    }
    
    [navCon setSideViewController:SKINS andShowOnTheLeftSide:NO];
}

-(void)doPickPhotoPressed{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    imageEditor = [[ImageEditor alloc] initWithNibName:@"ImageEditor" bundle:nil];
    imageEditor.checkBounds = YES;
    
    __weak MainVC *pSelf = self;
    imageEditor.doneCallback = ^(UIImage *editedImage, BOOL canceled){
        if(!canceled) {
            pSelf.captureManager.stillImage = editedImage;
            [pSelf imageCaptured];
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)doCamSettingsPressed{
    [self.captureManager switchInputs];
}

-(void)doPickNewPhotoPressed{
    if (imageInProcessing){
        imageInProcessing = NO;
    }
    
    [self.captureManager addLastVideoInput];
    [self initPreviewLayer];
    self.captureManager.stillImage = nil;
    [self switchButtons];
}

-(void)doSharePressed{
    if (imageInProcessing){
        return;
    }
    
    [self showActivityIndicator];
    
    dispatch_queue_t refreshQueue = dispatch_queue_create("foursquare icons queue", NULL);
    dispatch_async(refreshQueue, ^{
        UIImage *imageTaken = self.imagePreview.image;
        UIImage *imageSkin = [activeSkin getSkinImage];
        
        UIImage *imageToShare = [self drawImage:imageSkin inImage:imageTaken atPoint:CGPointMake(0, 0)];
        
        if (YES == [DataManager getLogoOverlayEnabled]){
            UIImage *logoOverlay = [UIImage imageNamed:@"logoOverlay.png"];
            CGPoint logoOverlayPoint = CGPointMake(imageToShare.size.width - logoOverlay.size.width - 15.0, [activeSkin isSkinContentAtTheTop] ? imageToShare.size.height - logoOverlay.size.height - 15.0 : 15.0);
            imageToShare = [self drawImage:logoOverlay inImage:imageToShare atPoint:logoOverlayPoint];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // if we still wait for the picture to be ready
            if (imageInProcessing){ // (user might have pressed PickNewPhoto for example)
                NSString *hashTagString = [Utils getHashTagString];
                SHKItem *item = [SHKItem image:imageToShare title:hashTagString];
                SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
                actionSheet.shareDelegate = self;
                [SHK setRootViewController:self];
            
                [actionSheet showInView:self.view];
            
                [self hideActivityIndicator];
            }
        });
    });
}

#pragma mark DDMenuControllerDelegate
- (void)menuController:(DDMenuController*)controller willShowViewController:(UIViewController*)toShow{
    swipeUp.enabled = NO;
    swipeDown.enabled = NO;
}

-(void)menuControllerWillShowRootViewController{
    swipeUp.enabled = YES;
    swipeDown.enabled = YES;
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image =  [Utils image:[info objectForKey:UIImagePickerControllerOriginalImage] byScalingProportionallyToSize:CGSizeMake(IMAGE_SIDE_SIZE, IMAGE_SIDE_SIZE)];
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        UIImage *preview = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        
        imageEditor.sourceImage = image;
        imageEditor.previewImage = preview;
        [imageEditor reset:NO];
        
        [picker pushViewController:imageEditor animated:YES];
        [picker setNavigationBarHidden:YES animated:NO];
        
    } failureBlock:^(NSError *error) {
        DLog(@"Failed to get asset from library");
    }];
}

#pragma mark SHKShareItemDelegate

- (BOOL)aboutToShareItem:(SHKItem *)item withSharer:(SHKSharer *)sharer{
    if ([sharer shouldSavePhotoToCustomAppAlbum] && YES == [DataManager getSaveWhenSharing]){
        [assetsLibrary saveImage:item.image toAlbum:@"InstaCar" completion:nil failure:nil];
    }
    return YES;
}

#pragma mark -

-(void)applyCurrentlySelectedCarsToNewlySelectedSkin{
    Auto *selectedAuto1 = [SkinProvider getInstance].selectedAuto1;
    if (selectedAuto1 != nil){
        [[SkinProvider getInstance].selectedSkinSet updateData:selectedAuto1 ofType:AUTO1];
    }
    
    if ([SkinProvider getInstance].selectedSkinSet.supportsSecondCar){
        Auto *selectedAuto2 = [SkinProvider getInstance].selectedAuto2;
        if (selectedAuto2 != nil){
            [[SkinProvider getInstance].selectedSkinSet updateData:selectedAuto2 ofType:AUTO2];
        }
    }
}

-(void)showActivityIndicator{
    [self.btnMiddleRight setTitle:@"" forState:UIControlStateNormal];
    self.scrollSkins.userInteractionEnabled = NO;
    self.activityShareInProgress.hidden = NO;
    imageInProcessing = YES;
    [self.activityShareInProgress startAnimating];
}

-(void)hideActivityIndicator{
    [self.btnMiddleRight setTitle:@"Share" forState:UIControlStateNormal];
    self.scrollSkins.userInteractionEnabled = YES;
    [self.activityShareInProgress stopAnimating];
    self.activityShareInProgress.hidden = YES;
    imageInProcessing = NO;
}

-(CGFloat)calcPageControlHeight{
    return self.view.bounds.size.height - self.constraintViewAdContainerHeight.constant - self.btnLocation.bounds.size.height - 1.0 - self.pageControlContainer.frame.origin.y;
}

-(void) imageCaptured{
    self.imagePreview.image = self.captureManager.stillImage;
    self.captureManager.stillImage = nil;
    
    [self.captureManager clearInputs];
    [self.captureManager.previewLayer removeFromSuperlayer];
    [self switchButtons];
}

-(UIImage*) drawImage:(UIImage*)fgImage
              inImage:(UIImage*)bgImage
              atPoint:(CGPoint)point
{
    UIGraphicsBeginImageContext(bgImage.size);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    [fgImage drawInRect:CGRectMake(point.x, point.y, fgImage.size.width, fgImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
