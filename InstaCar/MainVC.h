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
#import "SkinProvider.h"
#import "SMPageControl.h"
#import "UIBluredView.h"
#import "SHKShareItemDelegate.h"
#import "FirstTimeInfoVC.h"

@interface MainVC : UIViewController <UIScrollViewDelegate,
                                      UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate,
                                      ADBannerViewDelegate,
                                      SelectedDataChangeActionProtocol,
                                      DDMenuControllerDelegate,
                                      SHKShareItemDelegate,
                                      FirstTimeVCDelegate>

@property CaptureSessionManager *captureManager;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnMiddleLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnMiddle;
@property (weak, nonatomic) IBOutlet UIButton *btnMiddleRight;
@property (weak, nonatomic) IBOutlet UIButton *btnRightSide;

// Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMidBtnLeftWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMidBtnRigthWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonsCoverViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewAdContainerHeight;

@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollSkins;
@property (weak, nonatomic) IBOutlet UIView *pageControlContainer;
@property (weak, nonatomic) IBOutlet UIView *iAdView;

// Actions
- (IBAction)btnLocationPressed:(id)sender;
- (IBAction)btnMiddleLeftPressed;
- (IBAction)btnMiddlePressed;
- (IBAction)btnMiddleRightPressed;
- (IBAction)btnSkinsPressed:(id)sender;

@end
