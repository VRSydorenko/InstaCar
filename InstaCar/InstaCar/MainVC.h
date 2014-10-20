//
//  MainVC.h
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "MainNavController.h"
#import "CaptureSessionManager.h"
#import "SMPageControl.h"
#import "SHKShareItemDelegate.h"
#import "FirstTimeInfoVC.h"
#import "SkinCommandsPopoverView.h"

@interface MainVC : UIViewController <UIScrollViewDelegate,
                                      UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate,
                                      ADBannerViewDelegate,
                                      SelectedDataChangeActionProtocol,
                                      DDMenuControllerDelegate,
                                      SHKShareItemDelegate,
                                      FirstTimeVCDelegate>

@property CaptureSessionManager *captureManager;

@property (nonatomic) IBOutlet UIActivityIndicatorView *activityShareInProgress;

// Buttons
@property (nonatomic) IBOutlet UIButton *btnLocation;
@property (nonatomic) IBOutlet UIButton *btnMiddleLeft;
@property (nonatomic) IBOutlet UIButton *btnMiddle;
@property (nonatomic) IBOutlet UIButton *btnMiddleRight;
@property (nonatomic) IBOutlet UIButton *btnRightSide;

// Constraints
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintMidBtnLeftWidth;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintMidBtnRigthWidth;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintButtonsCoverViewHeight;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintViewAdContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWhiteActBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPreviewImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintScrollHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCmdViewTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCmdViewHeight;


@property (nonatomic) IBOutlet UIImageView *imagePreview;
@property (nonatomic) IBOutlet UIScrollView *scrollSkins;
@property (nonatomic) IBOutlet UIView *pageControlContainer;
@property (weak, nonatomic) IBOutlet UIView *iAdView;
@property (weak, nonatomic) IBOutlet SkinCommandsPopoverView *commandView;

// Actions
- (IBAction)btnLocationPressed:(id)sender;
- (IBAction)btnMiddleLeftPressed;
- (IBAction)btnMiddlePressed;
- (IBAction)btnMiddleRightPressed;
- (IBAction)btnSkinsPressed:(id)sender;

@end
