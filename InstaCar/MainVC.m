//
//  MainVC.m
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "MainVC.h"
#import "ShareKit.h"

#define SWITCH_TIME 1.0

typedef enum {
    COLLAPSE,
    EXPAND
} ButtonTransformAction;

@interface MainVC (){
    MainNavController *navCon;
    BOOL buttonsInInitialState;
    
    SkinViewBase *activeSkin;
    UISwipeGestureRecognizer *swipeUp;
    UISwipeGestureRecognizer *swipeDown;
}

@end

@implementation MainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    navCon = (MainNavController*)self.navigationController;
    navCon.dataSelectionChangeDelegate = self;
    navCon.menuControllerDelegate = self;
    
    buttonsInInitialState = YES;
    
    [self initCaptureManager];
    
    [self initSkins];
    
    [self initGestures];
    
    [self.view bringSubviewToFront:self.scrollSkins];
    
    // Navitgation item transparency
    /*self.navigationController.navigationBar.translucent = YES;
    const float colorMask[6] = {222, 255, 222, 255, 222, 255};
    UIImage *img = [[UIImage alloc] init];
    UIImage *maskedImage = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
    
    [self.navigationController.navigationBar setBackgroundImage:maskedImage forBarMetrics:UIBarMetricsDefault];
     */
}

#pragma mark Initialization

-(void)initCaptureManager{
    // Set up and run the capture manager
    self.captureManager = [[CaptureSessionManager alloc] init];
    [self.captureManager addVideoInputFrontCamera:NO];
    [self.captureManager addStillImageOutput];
    [self.captureManager addVideoPreviewLayer];
    
    CGRect layerRect = self.imagePreview.frame;
    [self.captureManager.previewLayer setBounds:layerRect];
    [self.captureManager.previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
    
    //[self.view.layer addSublayer:self.captureManager.previewLayer];
    [self.imagePreview.layer addSublayer:self.captureManager.previewLayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageCaptured) name:kImageCapturedSuccessfully object:nil];
    [self.captureManager.captureSession startRunning];
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
    SkinViewBase *skinView = [[SkinProvider getInstance].selectedSkinSet getSkinAtIndex:0];
    [self.scrollSkins addSubview:skinView];

    activeSkin = skinView;
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
    [self switchButtons];
}

-(void)doSharePressed{
    SHKItem *toShare = [SHKItem image:self.imagePreview.image title:@"Share titte"];
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:toShare];
    [SHK setRootViewController:self];
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
    [self prepareSquareImage];
    self.imagePreview.image = self.captureManager.stillImage;
    [self.captureManager clearInputs];
    [self switchButtons];
}

- (void)saveImageToPhotoAlbum
{
    UIImageWriteToSavedPhotosAlbum(self.captureManager.stillImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(void) prepareSquareImage{
    UIImage *sourceImage = self.captureManager.stillImage;
    
    CGFloat heightScaleFactor =  sourceImage.size.height / self.view.frame.size.height;
    CGPoint convertedPreviewPoint = [self.view convertPoint:self.imagePreview.frame.origin toView:nil];
    CGFloat subImageTop = convertedPreviewPoint.y * heightScaleFactor;
    CGRect subImageRect = CGRectMake(0, subImageTop, sourceImage.size.width, sourceImage.size.width);
    UIImage *subImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(sourceImage.CGImage, subImageRect)];
    
    self.captureManager.stillImage = subImage;
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image" message:error!=NULL?@"Image couldn't be saved":@"Saved!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
}

@end
