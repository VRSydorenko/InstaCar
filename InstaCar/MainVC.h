//
//  MainVC.h
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"

@interface MainVC : UIViewController

@property CaptureSessionManager *captureManager;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnMiddleLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnMiddle;
@property (weak, nonatomic) IBOutlet UIButton *btnMiddleRight;
@property (weak, nonatomic) IBOutlet UIButton *btnRightSide;

// Constraints
@property (weak, nonatomic) IBOutlet UIView *viewMiddleButtons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewMiddleButtonsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewMiddleButtonsBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnMakeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImagePreviewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;

// Actions
- (IBAction)btnLocationPressed:(id)sender;
- (IBAction)btnMiddleLeftPressed;
- (IBAction)btnMiddlePressed;
- (IBAction)btnMiddleRightPressed;
- (IBAction)btnSkinsPressed:(id)sender;

@end
