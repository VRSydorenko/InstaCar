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
#import "SkinCommandsView.h"
#import "ButtonsControlView.h"

@interface MainVC : UIViewController <UIScrollViewDelegate,
                                      UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate,
                                      ADBannerViewDelegate,
                                      SelectedDataChangeActionProtocol,
                                      DDMenuControllerDelegate,
                                      SHKShareItemDelegate,
                                      FirstTimeVCDelegate,
                                      ButtonsControlDelegate>

@property CaptureSessionManager *captureManager;

@property (nonatomic) IBOutlet NSLayoutConstraint *constraintViewAdContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPreviewImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintScrollHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCmdViewTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCmdViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPageControlHeight;

@property (nonatomic) IBOutlet UIImageView *imagePreview;
@property (nonatomic) IBOutlet UIScrollView *scrollSkins;
@property (nonatomic) IBOutlet UIView *pageControlContainer;
@property (weak, nonatomic) IBOutlet UIView *iAdView;
@property (weak, nonatomic) IBOutlet SkinCommandsView *commandView;
@property (weak, nonatomic) IBOutlet ButtonsControlView *buttonsControlView;

@end
