//
//  ButtonsControlView.h
//  InstaCar
//
//  Created by VRS on 20/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonsControlDelegate <NSObject>
-(void)onBtnLocationPressed;
-(void)onBtnPickPhotoPressed;
-(void)onBtnShotPressed;
-(void)onBtnSwitchCameraPressed;
-(void)onBtnSkinsPressed;
-(void)onBtnNewPhotoPressed;
-(void)onBtnSharePressed;
@end

@interface ButtonsControlView : UIView{
    BOOL isInInitialState;
}

@property (nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// Buttons
@property (nonatomic) IBOutlet UIButton *btnL;
@property (nonatomic) IBOutlet UIButton *btnML;
@property (nonatomic) IBOutlet UIButton *btnM;
@property (nonatomic) IBOutlet UIButton *btnMR;
@property (nonatomic) IBOutlet UIButton *btnR;

// events
-(IBAction)onBtn_L_Pressed:(id)sender;
-(IBAction)onBtn_ML_Pressed:(id)sender;
-(IBAction)onBtn_M_Pressed:(id)sender;
-(IBAction)onBtn_MR_Pressed:(id)sender;
-(IBAction)onBtn_R_Pressed:(id)sender;

// Constraints
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintBtn_L_Width;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintBtn_ML_Width;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintBtn_MR_Width;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintBtn_R_Width;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintCoverViewHeight;

@property (nonatomic) NSObject<ButtonsControlDelegate> *delegate;

// methods
-(void)enable_M_Button:(BOOL)enabled;
-(void)showActivityIndicator:(BOOL)show;
-(void)switchButtons;

@end
