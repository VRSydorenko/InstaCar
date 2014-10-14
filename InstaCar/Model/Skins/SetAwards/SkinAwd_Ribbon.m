//
//  SkinAwd_Placeholder1.m
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinAwd_Ribbon.h"

@interface SkinAwd_Ribbon()

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinAwd_Ribbon

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width / 1.68;
    CGFloat labelMargin = ([UIScreen mainScreen].bounds.size.width - labelWidth) / 2;
    self.constraintLabelLeft.constant = labelMargin;
    self.constraintLabelRight.constant = labelMargin;
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height andMovingViewTopBottomMargin:0];
    
    _commandFlags.canCmdEditText = YES;
    canEditFieldAuto1 = YES;
}

-(void)fieldAuto1DidUpdate{
    self.labelText.text = fieldAuto1.selectedTextMarkModel;
}

-(NSString*)getSkinContentText{
    return self.labelText.text;
}

-(void)onCmdEditText:(NSString *)newText{
    self.labelText.text = newText;
}

@end
