//
//  ButtonsControlView.m
//  InstaCar
//
//  Created by VRS on 20/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "ButtonsControlView.h"

#define SWITCH_TIME 1.0

typedef enum {
    COLLAPSE,
    EXPAND
} ButtonTransformAction;

@implementation ButtonsControlView

#pragma mark Button handlers

-(void)awakeFromNib{
    self.constraintCoverViewHeight.constant = 0.0;
    self.activityIndicator.hidden = YES;
    isInInitialState = YES;
}

-(IBAction)onBtn_L_Pressed:(id)sender{
    [self.delegate onBtnLocationPressed];
}

-(IBAction)onBtn_ML_Pressed:(id)sender{
    if (isInInitialState){
        [self.delegate onBtnPickPhotoPressed];
    } else {
        [self.delegate onBtnNewPhotoPressed];
    }
}

-(IBAction)onBtn_M_Pressed:(id)sender{
    if (isInInitialState){
        [self.delegate onBtnShotPressed];
    } else {
        [self.delegate onBtnSharePressed];
    }
}

-(IBAction)onBtn_MR_Pressed:(id)sender{
    [self.delegate onBtnSwitchCameraPressed];
}

-(IBAction)onBtn_R_Pressed:(id)sender{
    [self.delegate onBtnSkinsPressed];
}

#pragma mark Switching buttons

-(void) switchButtons{
    [self collapseButtons];
    [NSTimer scheduledTimerWithTimeInterval:SWITCH_TIME/2.0 target:self selector:@selector(expandButtons) userInfo:nil repeats:NO];
}

-(void)collapseButtons{
    CGFloat sideButtonsWidth = self.bounds.size.height * 1.2; // 20% wider than higher
    CGFloat middleButtonsWidth = ([UIScreen mainScreen].bounds.size.width - 2/*side buttons*/ * sideButtonsWidth) / 2/*middle buttons*/;
    
    [UIView animateWithDuration:SWITCH_TIME / 2.0
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.constraintCoverViewHeight.constant = self.bounds.size.height;
                         
                         self.btnML.titleLabel.alpha = 0.0;
                         self.btnM.titleLabel.alpha = 0.0;
                         
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         if (isInInitialState){ // make state with Share button
                             self.constraintBtn_L_Width.constant = sideButtonsWidth; // left is standard
                             self.constraintBtn_ML_Width.constant = middleButtonsWidth; // then a long one "new photo
                                                                          // middle one will autoadjust
                             self.constraintBtn_MR_Width.constant = 0.0; // this one has no length
                             self.constraintBtn_R_Width.constant = sideButtonsWidth; // right one is standard
                             
                            [self updateButtonIcons];
                         } else { // make initial state
                             self.constraintBtn_ML_Width.constant = sideButtonsWidth;
                             self.constraintBtn_MR_Width.constant = sideButtonsWidth;
                             
                             [self updateButtonIcons];
                         }
                     }
     ];
}

-(void)expandButtons{
    [self enable_M_Button:YES]; // make the Shot button available for using again
    
    [UIView animateWithDuration:SWITCH_TIME / 2.0
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.constraintCoverViewHeight.constant = 0.0;
                         
                         self.btnML.titleLabel.alpha = 1.0;
                         self.btnM.titleLabel.alpha = 1.0;
                         
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         isInInitialState = !isInInitialState;
                     }
     ];
}

-(void)updateButtonIcons{ // the state before update is taken in consideration
    if (isInInitialState){
        [self.btnML setTitle:@"New photo" forState:UIControlStateNormal];
        [self.btnML setImage:nil forState:UIControlStateNormal];
    
        [self.btnM setTitle:@"Share" forState:UIControlStateNormal];
        [self.btnM setImage:nil forState:UIControlStateNormal];
        
        
    } else {
        [self.btnML setImage:[UIImage imageNamed:@"PicLandscape.png"] forState:UIControlStateNormal];
        [self.btnML setTitle:@"" forState:UIControlStateNormal];
        
        [self.btnM setImage:[UIImage imageNamed:/*TODO:*/@"Camera.png"] forState:UIControlStateNormal];
        [self.btnM setTitle:@"" forState:UIControlStateNormal];
    }
}

-(void)enable_M_Button:(BOOL)enabled{
    self.btnM.enabled = enabled;
}

-(void)showActivityIndicator:(BOOL)show{
    if (show){
        [self.btnM setTitle:@"" forState:UIControlStateNormal];
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
    } else {
        [self.btnM setTitle:@"Share" forState:UIControlStateNormal];
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
    }
}

-(void)setButtonsBottomInset:(CGFloat)btnBottomInset{
    [self.btnL setImageEdgeInsets:UIEdgeInsetsMake(0, 0, btnBottomInset, 0)];
    [self.btnML setImageEdgeInsets:UIEdgeInsetsMake(0, 0, btnBottomInset, 0)];
    [self.btnM setImageEdgeInsets:UIEdgeInsetsMake(0, 0, btnBottomInset + 6.0 /*top margin*/, 0)];
    [self.btnMR setImageEdgeInsets:UIEdgeInsetsMake(0, 0, btnBottomInset, 0)];
    [self.btnR setImageEdgeInsets:UIEdgeInsetsMake(0, 0, btnBottomInset, 0)];
    
    [self.btnML setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, btnBottomInset, 0)];
    [self.btnM setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, btnBottomInset, 0)];
    
    self.constraintActIndicatorBottom.constant += btnBottomInset == 0.0 ? 13.0 : -13.0; // TODO: fix hardcoded workaround
}

@end
