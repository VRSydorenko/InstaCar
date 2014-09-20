//
//  SkinAwd_BestChoise3.m
//  InstaCar
//
//  Created by VRS on 03/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinAwd_BestChoise3.h"

@interface SkinAwd_BestChoise3(){
    CGFloat modelLabelInitialHeight;
}

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *modelLabelHeight;

@end

@implementation SkinAwd_BestChoise3

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];
    
    modelLabelInitialHeight = self.modelLabelHeight.constant;
    canEditFieldAuto1 = YES;
    isContentOnTop = NO;
}

-(void)fieldAuto1DidUpdate{
    self.labelAuto.text = fieldAuto1.name;
    self.labelModel.text = fieldAuto1.selectedTextModelSubmodel;
    self.modelLabelHeight.constant = self.labelModel.text.length == 0 ? 0.0 : modelLabelInitialHeight;
}

@end
