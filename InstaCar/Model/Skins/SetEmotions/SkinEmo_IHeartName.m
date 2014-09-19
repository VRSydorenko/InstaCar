//
//  SkinEmo_IHeartName.m
//  InstaCar
//
//  Created by VRS on 03/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinEmo_IHeartName.h"

@interface SkinEmo_IHeartName()

@property (nonatomic) IBOutlet NSLayoutConstraint *constraintTopMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinEmo_IHeartName

-(void)initialise{
    //[self setupGradient:0.2 inDirection:GRADIENT_UP];
    [self setMovingViewConstraint:self.constraintTopMargin andViewHeight:self.movingView.bounds.size.height];
    
    self.movingView.backgroundColor = [UIColor clearColor];
    
    canEditFieldAuto1 = YES;
    isContentOnTop = NO;
    movingViewTopBottomMargin = 10.0;
}

-(void)fieldAuto1DidUpdate{
    self.labelAuto.text = fieldAuto1.name;
}
@end