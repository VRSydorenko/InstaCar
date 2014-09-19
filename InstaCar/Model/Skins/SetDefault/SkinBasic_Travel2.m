//
//  SkinBasic_Travel2.m
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinBasic_Travel2.h"

@interface SkinBasic_Travel2()

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelAutoWidth;

@end

@implementation SkinBasic_Travel2

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];

    isContentOnTop = NO;
    canEditFieldAuto1 = YES;
}

-(void)fieldAuto1DidUpdate{
    self.labelAuto.text = fieldAuto1.selectedTextFull;
    [self adjustAutoLabelSizeAccordingToText];
}

-(void)adjustAutoLabelSizeAccordingToText{
    CGSize textSize = [self.labelAuto.text sizeWithAttributes:[NSDictionary dictionaryWithObject:self.labelAuto.font forKey:NSFontAttributeName]];
    self.constraintLabelAutoWidth.constant = MIN(5.0+textSize.width, self.bounds.size.width * 0.8 /* label takes max 80% of the screen width*/);
}

@end