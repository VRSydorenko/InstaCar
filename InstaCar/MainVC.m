//
//  MainVC.m
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "MainVC.h"
#import "Utils.h"
#import "ShareKit.h"

#define SWITCH_TIME 1.0
#define IMAGE_SIDE_SIZE 612.0

typedef enum {
    COLLAPSE,
    EXPAND
} ButtonTransformAction;

@interface MainVC (){
    MainNavController *navCon;
    BOOL buttonsInInitialState;
    BOOL isChangingPage;
    
    SkinViewBase *activeSkin;
    UISwipeGestureRecognizer *swipeUp;
    UISwipeGestureRecognizer *swipeDown;
}

@end

@implementation MainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navCon = (MainNavController*)self.navigationController;
    navCon.dataSelectionChangeDelegate = self;
    navCon.menuControllerDelegate = self;
    
    buttonsInInitialState = YES;
    isChangingPage = NO;
    
    [self initCaptureManager];
    
    [self initSkins];
    
    [self initGestures];
    
    self.scrollSkins.delegate = self;
    [self.view bringSubviewToFront:self.scrollSkins];
    
    // Navitgation item transparency
    /*self.navigationController.navigationBar.translucent = YES;
    const float colorMask[6] = {222, 255, 222, 255, 222, 255};
    UIImage *img = [[UIImage alloc] init];
    UIImage *maskedImage = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
    
    [self.navigationController.navigationBar setBackgroundImage:maskedImage forBarMetrics:UIBarMetricsDefault];
     */
}

-(void)viewDidAppear:(BOOL)animated{
    CGPoint convertedPreviewPoint = [self.imagePreview convertPoint:self.imagePreview.frame.origin toView:nil];
    self.captureManager.imageTopCropMargin = convertedPreviewPoint.y;
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
    
    for (unsigned short i = 0; i < pageCount; i++) {
        SkinViewBase *skinToAdd = [skinSet getSkinAtIndex:i];
		
		CGRect skinRect = skinToAdd.frame;
        skinRect.origin.x = i * skinWidth;
        skinRect.origin.y = 0;
        
		skinToAdd.frame = skinRect;
        
        [self.scrollSkins addSubview:skinToAdd];
	}
    
	[self.scrollSkins setContentSize:CGSizeMake(skinWidth * pageCount, [self.scrollSkins bounds].size.height)];
    self.pageControl.numberOfPages = pageCount;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (isChangingPage){
        return;
    }
    
	// Switch page at 50% across
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    activeSkin = [[SkinProvider getInstance].selectedSkinSet getSkinAtIndex:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender{
    isChangingPage = NO;
}

#pragma mark SelectedDataChangeActionProtocol

-(void) selectedData:(SelectedDataChange)dataType changedTo:(id)newValue{
    if (dataType == SKIN_SET){
        // load new set
    } else { // other fields are skin relevant so pass the update to selected skin
        [[SkinProvider getInstance].selectedSkinSet updateData:newValue ofType:dataType];
    }
}

#pragma mark Gestures

-(void)swipeUp{
    [activeSkin moveContentUp];
}

-(void)swipeDown{
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
                self.constraintViewMiddleButtonsBottomMargin.constant = -32.0; // half of the view container height
                self.constraintViewMiddleButtonsHeight.constant = 1;
                self.btnMiddleLeft.titleLabel.alpha = 0.0;
                self.btnMiddle.titleLabel.alpha = 0.0;
                self.btnMiddleRight.titleLabel.alpha = 0.0;
                
                [self.view layoutIfNeeded];
            }
            completion:^(BOOL finished){
                if (buttonsInInitialState){
                    self.constraintBtnMakeWidth.constant = 0;
                    
                    [self.btnMiddleLeft setTitle:@"New" forState:UIControlStateNormal];
                    [self.btnMiddleRight setTitle:@"Share" forState:UIControlStateNormal];
                } else {
                    self.constraintBtnMakeWidth.constant = 64.0;
                    
                    [self.btnMiddleLeft setTitle:@"Pick" forState:UIControlStateNormal];
                    [self.btnMiddleRight setTitle:@"Flash" forState:UIControlStateNormal];
                }
            }
     ];
}

-(void)expandButtons{
    [UIView animateWithDuration:SWITCH_TIME / 2.0
            delay:0.0
            options:UIViewAnimationOptionAllowAnimatedContent
            animations:^{
                self.constraintViewMiddleButtonsBottomMargin.constant = 0;
                self.constraintViewMiddleButtonsHeight.constant = 64.0;
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
    [navCon setSideViewController:LOCATIONS andShowOnTheLeftSide:YES];
}

- (IBAction)btnMiddlePressed {
    [self.captureManager captureStillImage];
}

- (IBAction)btnSkinsPressed:(id)sender {
    [navCon setSideViewController:SKINS andShowOnTheLeftSide:NO];
}

-(void)doPickPhotoPressed{
    
}

-(void)doCamSettingsPressed{
    [self.captureManager switchInputs];
}

-(void)doPickNewPhotoPressed{
    [self.captureManager addLastVideoInput];
    [self initPreviewLayer];
    self.captureManager.stillImage = nil;
    [self switchButtons];
}

-(void)doSharePressed{
    UIImage *imageTaken = self.imagePreview.image;
    UIImage *imageSkin = [activeSkin getImageOfSize:imageTaken.size andScale:imageTaken.scale];
    UIImage *imageToShare = [self drawImage:imageSkin inImage:imageTaken atPoint:CGPointMake(0, 0)];
    //imageToShare = [UIImage imageWithData:[Utils compressImage:imageToShare]];
    
    SHKItem *item = [SHKItem image:imageToShare title:@"Hohoho"];
    
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showInView:self.view];
}

#pragma mark DDMenuControllerDelegate
- (void)menuController:(DDMenuController*)controller willShowViewController:(UIViewController*)toShow{
    swipeUp.enabled = NO;
    swipeDown.enabled = NO;
}

- (void)menuControllerWillShowRootViewController{
    swipeUp.enabled = YES;
    swipeDown.enabled = YES;
}

#pragma mark -

-(void) imageCaptured{
    //[self prepareSquareImage];
    //CGSize desiredSize = CGSizeMake(IMAGE_SIDE_SIZE, IMAGE_SIDE_SIZE);
    
    self.imagePreview.image = self.captureManager.stillImage;//[Utils image:self.captureManager.stillImage byScalingProportionallyToSize:desiredSize];
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

- (void)saveImageToPhotoAlbum
{
    UIImageWriteToSavedPhotosAlbum(self.captureManager.stillImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image" message:error!=NULL?@"Image couldn't be saved":@"Saved!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
}

@end
