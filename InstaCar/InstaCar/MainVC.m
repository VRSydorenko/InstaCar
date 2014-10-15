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
#import "SkinCommandsPopoverView.h"

#define SWITCH_TIME 1.0

typedef enum {
    COLLAPSE,
    EXPAND
} ButtonTransformAction;

@interface MainVC (){
    MainNavController *navCon;
    BOOL buttonsInInitialState;
    BOOL imageInProcessing;
    
    SkinViewBase *activeSkin;
    UISwipeGestureRecognizer *swipeUp;
    UISwipeGestureRecognizer *swipeDown;
    SMPageControl *pageControl;
    
    ALAssetsLibrary *assetsLibrary;
    ImageEditor *imageEditor;
    __weak UIImage *selectedImage;
    ADBannerView *bannerView;
    
    CGFloat pageControlHeight;
    
    SkinCommandsPopoverView *cmdPopoverView;
    CGRect initialPopoverFrame;
    BOOL isShowingAd;
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
    selectedImage = nil;
    imageInProcessing = NO;
    isShowingAd = NO;
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

    self.constraintPreviewImageHeight.constant = [UIScreen mainScreen].bounds.size.width;
    self.constraintScrollHeight.constant = [UIScreen mainScreen].bounds.size.width;
    
    // Keyboard listener
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CGPoint convertedPreviewPoint = [self.imagePreview.superview convertPoint:self.imagePreview.frame.origin toView:nil];
    self.captureManager.imageTopCropMargin = convertedPreviewPoint.y;
    
    self.constraintButtonsCoverViewHeight.constant = [self calcPageControlHeight];
    
    [self initSkinCommandPopoverView];
    [self setActiveSkin:0]; // goes after creating the command view
    
    if (NO == [DataManager getHasLaunchedBefore]){
        FirstTimeInfoVC *infoVC = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"firstTimeInfoVC"];
        infoVC.delegate = self;
        [self addChildViewController:infoVC];
        [self.view addSubview:infoVC.view];
    } else {
        [self initIAd];
    }
    
    [self selectedData:SKIN_SET changedTo:[DataManager getSelectedSkinSet]];
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
    SkinSet *skinSet = [DataManager getSelectedSkinSet];
    // [self setActiveSkin:0]; // moved to initCmdPopupView

	self.scrollSkins.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    const unsigned short pageCount = [skinSet getSkinsCount];
    const int skinWidth = [UIScreen mainScreen].bounds.size.width;
    
    // add skin views to the scroll area
    for (unsigned short i = 0; i < pageCount; i++) {
        SkinViewBase *skinToAdd = [skinSet getSkinAtIndex:i];
		
        CGRect curFrame = skinToAdd.frame;
        curFrame.size.width = skinWidth;
        curFrame.size.height = skinWidth;
        skinToAdd.frame = curFrame;
        
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

    pageControlHeight = ![UserSettings isIPhone4] ? 15.0 : 10.0;
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    if (screenRect.size.height > 480) // even higher on bigger screens
    {
        pageControlHeight += 10.0;
    }
    
    CGRect pageControlFrame = CGRectMake(0, 0, self.pageControlContainer.bounds.size.width, pageControlHeight);
    pageControl = [[SMPageControl alloc] initWithFrame:pageControlFrame];
    pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    pageControl.userInteractionEnabled = NO;
    pageControl.indicatorDiameter = ![UserSettings isIPhone4] ? 8.0 : 6.0f;
    pageControl.indicatorMargin = ![UserSettings isIPhone4] ? 6.0 : 5.0f;
    
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

-(void) initSkinCommandPopoverView{
    if (cmdPopoverView){
        return;
    }
    
    CGFloat topBottomMargin = 0.0;
    CGFloat sideMargin = 10.0;
    CGFloat y = self.pageControlContainer.frame.origin.y + pageControlHeight + topBottomMargin;
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 * sideMargin;
    CGFloat height = [self getPopCommandsViewHeight];
    
    CGRect frame = CGRectMake(sideMargin, y, width, height);
    
    cmdPopoverView = [[SkinCommandsPopoverView alloc] initWithFrame:frame];
    initialPopoverFrame = frame;
    cmdPopoverView.ownerVC = (UIViewController<ProInfoViewControllerDelegate>*)self.navigationController; // TODO: refactor this workaround
    cmdPopoverView.backgroundColor = [UIColor whiteColor]; // TOOD: move to the view initialisation
    
    //Set the customView properties
    cmdPopoverView.alpha = 0.0;
    cmdPopoverView.layer.cornerRadius = 3;
    cmdPopoverView.layer.borderWidth = 1.5f;
    cmdPopoverView.layer.masksToBounds = YES;
    
    //Add the customView to the current view
    [self.view addSubview:cmdPopoverView];
    [self.view bringSubviewToFront:cmdPopoverView];
    
    //Display the customView with animation
    [UIView animateWithDuration:0.4 animations:^{
        [cmdPopoverView setAlpha:1.0];
    } completion:^(BOOL finished) {}];
}

#pragma Banner view delegate

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    if (NO == [DataManager isFullVersion] && self.constraintViewAdContainerHeight.constant == 0){
        isShowingAd = YES;
        
        self.constraintViewAdContainerHeight.constant = 50.0;
        self.constraintButtonsCoverViewHeight.constant = [self calcPageControlHeight];
        
        CGRect popoverFrame = cmdPopoverView.frame;
        popoverFrame.size.height = [self getPopCommandsViewHeight];
        
        [UIView animateWithDuration:0.25
                         animations:^(void){
                             if (!cmdPopoverView.isInEditMode){
                                 cmdPopoverView.frame = popoverFrame;
                             }
                             
                             if ([UserSettings isIPhone4]){
                                 [self setButtonsBottomInset:-26.0];
                                 self.constraintWhiteActBottomMargin.constant -= 13.0;
                             }
                             
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL success){
                             if (!cmdPopoverView.isInEditMode){
                                 [cmdPopoverView rebuildView];
                             }
                         }
         ];
    }
}

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    if (NO == [DataManager isFullVersion] && self.constraintViewAdContainerHeight.constant == 50.0){
        isShowingAd = NO;
        
        self.constraintViewAdContainerHeight.constant = 0.0;
        self.constraintButtonsCoverViewHeight.constant = [self calcPageControlHeight];
        
        CGRect popoverFrame = cmdPopoverView.frame;
        popoverFrame.size.height = [self getPopCommandsViewHeight];
        
        [UIView animateWithDuration:0.25
                         animations:^(void){
                             if (!cmdPopoverView.isInEditMode){
                                 cmdPopoverView.frame = popoverFrame;
                             }
                             
                             if ([UserSettings isIPhone4]){
                                 [self setButtonsBottomInset:0.0];
                                 self.constraintWhiteActBottomMargin.constant += 13.0;
                             }
                             
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL success){
                             if (!cmdPopoverView.isInEditMode){
                                 [cmdPopoverView rebuildView];
                             }
                         }
         ];
    }
}

#pragma UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	// Switch page at 50% across
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (pageControl.currentPage != page){
        pageControl.currentPage = page;
        [self setActiveSkin:page];
    }
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
        [self setActiveSkin:pageControl.currentPage]; // TODO: set the index saved before
        
        // if any car is currently selected - apply it to newly selected skinset
        [self applyCurrentlySelectedCarsToNewlySelectedSkin];
        // if location is selected - apply it to skins in the set
        [self applyCurrentlySelectedLocationToNewlySelectedSkin];
    } else { // other fields are skin relevant so pass the update to selected skin set
        [[DataManager getSelectedSkinSet] updateData:newValue ofType:dataType];
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
                    CGFloat longWidth = 0.5 * ([UIScreen mainScreen].bounds.size.width - 2 * 64);
                    self.constraintMidBtnLeftWidth.constant = longWidth; //96.0;
                    [self.btnMiddleLeft setTitle:@"New photo" forState:UIControlStateNormal];
                    [self.btnMiddleLeft setImage:nil forState:UIControlStateNormal];
                    
                    self.constraintMidBtnRigthWidth.constant = longWidth; // 96.0;
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
                self.btnMiddle.enabled = YES; // make the Shot button available for using again
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
        self.btnMiddle.enabled = NO;
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
    
    dispatch_queue_t refreshQueue = dispatch_queue_create("image processing queue", NULL);
    dispatch_async(refreshQueue, ^{
        UIImage *imageTaken = self.imagePreview.image;
        UIImage *imageSkin = [activeSkin getSkinImage];
        
        UIImage *imageToShare = [self drawSkin:imageSkin inImageTaken:imageTaken];
        
        if (YES == [DataManager getLogoOverlayEnabled]){
            UIImage *logoOverlay = [UIImage imageNamed:@"logoOverlay.png"];
            CGPoint logoOverlayPoint = CGPointMake(imageToShare.size.width - logoOverlay.size.width - 15.0, [activeSkin isSkinContentAtTheTop] ? imageToShare.size.height - logoOverlay.size.height - 15.0 : 15.0);
            imageToShare = [self drawImage:logoOverlay inImage:imageToShare atPoint:logoOverlayPoint];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // if we are still waiting for the picture to be ready
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
    UIImage *image =  [Utils image:[info objectForKey:UIImagePickerControllerOriginalImage] byScalingProportionallyToSize:CGSizeMake(DESIRED_SIDE_LENGTH, DESIRED_SIDE_LENGTH)];
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
    Auto *selectedAuto1 = [DataManager getSelectedAuto1];
    if (selectedAuto1 != nil){
        [[DataManager getSelectedSkinSet] updateData:selectedAuto1 ofType:AUTO1];
    }
    
    if ([DataManager getSelectedSkinSet].supportsSecondCar){
        Auto *selectedAuto2 = [DataManager getSelectedAuto2];
        if (selectedAuto2 != nil){
            [[DataManager getSelectedSkinSet] updateData:selectedAuto2 ofType:AUTO2];
        }
    }
}

-(void)applyCurrentlySelectedLocationToNewlySelectedSkin{
    FSVenue *selectedVenue = [DataManager getSelectedVenue];
    if (nil != selectedVenue){
        [[DataManager getSelectedSkinSet] updateData:selectedVenue ofType:LOCATION];
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

-(CGFloat)getPopCommandsViewHeight{
    if (nil != cmdPopoverView && [cmdPopoverView isInEditMode]){
        return [cmdPopoverView heightOnTop];
    }
    
    if (!isShowingAd){
        return [UserSettings isIPhone4] ? 47.0 : 70.0;
    } else {
        return [UserSettings isIPhone4] ? 28.0 /*+9*/: 55.0/*-15*/;
    }
}

-(void) imageCaptured{
    self.imagePreview.image = self.captureManager.stillImage;
    self.captureManager.stillImage = nil;
    
    [self.captureManager clearInputs];
    [self.captureManager.previewLayer removeFromSuperlayer];
    [self switchButtons];
}

-(UIImage*) drawSkin:(UIImage*)skinImage
        inImageTaken:(UIImage*)imageTaken
{
    UIGraphicsBeginImageContext(CGSizeMake(DESIRED_SIDE_LENGTH, DESIRED_SIDE_LENGTH));
    [imageTaken drawAtPoint:CGPointMake(0.0, 0.0)];
    [skinImage drawAtPoint:CGPointMake(0.0, 0.0)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(UIImage*) drawImage:(UIImage*)fgImage inImage:(UIImage*)bgImage atPoint:(CGPoint)point{
    UIGraphicsBeginImageContext(bgImage.size);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    [fgImage drawInRect:CGRectMake(point.x, point.y, fgImage.size.width, fgImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)updateSkinCommandsPopover{
    if (cmdPopoverView.isInEditMode){ // TODO: reimplement this workaround
        [cmdPopoverView removeFromSuperview];
        cmdPopoverView = nil;
        
        [self initSkinCommandPopoverView];
    }
    
    if (!cmdPopoverView){
        DLog(@"Skin command popover is not initialized");
        return;
    }
    
    cmdPopoverView.delegatingSkin = activeSkin;
}

-(void)setActiveSkin:(int)index{
    activeSkin = [[DataManager getSelectedSkinSet] getSkinAtIndex:index];
    [self updateSkinCommandsPopover];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (nil == cmdPopoverView){
        // this view reacts on keyboard only in case of user text editing
        return;
    }
    
    NSValue *aValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    
    CGFloat height = [self getPopCommandsViewHeight];
    CGRect popoverFrame = CGRectMake(cmdPopoverView.frame.origin.x, keyboardTop - height, cmdPopoverView.bounds.size.width, height);
    
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         cmdPopoverView.frame = popoverFrame;
                     }
     ];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (nil == cmdPopoverView){
        // this view reacts on keyboard only in case of user text editing
        return;
    }
    
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGRect popoverFrame = initialPopoverFrame;
    popoverFrame.size.height = [self getPopCommandsViewHeight];
    
    [UIView animateWithDuration:animationDuration
                    animations:^{
                        cmdPopoverView.frame = popoverFrame;
                    }
                    completion:^(BOOL finished){
                        [cmdPopoverView rebuildView];
                    }
    ];
}

-(void)setButtonsBottomInset:(CGFloat)btnBottomInset{
    [self.btnLocation setImageEdgeInsets:UIEdgeInsetsMake(0, 0, btnBottomInset, 0)];
    [self.btnMiddleLeft setImageEdgeInsets:UIEdgeInsetsMake(0, 0, btnBottomInset, 0)];
    [self.btnMiddle setImageEdgeInsets:UIEdgeInsetsMake(0, 0, btnBottomInset, 0)];
    [self.btnMiddleRight setImageEdgeInsets:UIEdgeInsetsMake(0, 0, btnBottomInset, 0)];
    [self.btnRightSide setImageEdgeInsets:UIEdgeInsetsMake(0, 0, btnBottomInset, 0)];
    
    [self.btnMiddleLeft setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, btnBottomInset, 0)];
    [self.btnMiddleRight setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, btnBottomInset, 0)];
}

@end
