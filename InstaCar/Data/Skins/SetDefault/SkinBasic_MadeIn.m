//
//  SkinBasic_MadeIn.m
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinBasic_MadeIn.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)

@interface SkinBasic_MadeIn()

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinBasic_MadeIn

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];

    canEditFieldAuto1 = YES;
    self.labelCountry.transform = CGAffineTransformMakeRotation(degreesToRadians(-30));
    isContentOnTop = NO;
}

-(void)fieldAuto1DidUpdate{
    self.labelCountry.text = fieldAuto1.country.uppercaseString;
}

@end
