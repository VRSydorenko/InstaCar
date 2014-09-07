//
//  SkinAwd_Medal1st.m
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinAwd_Medal1st.h"

@interface SkinAwd_Medal1st()

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinAwd_Medal1st

-(void)initialise{
    [self setupGradient:0.2 inDirection:GRADIENT_RIGHT];
    [self.imgEmblem.layer setMinificationFilter:kCAFilterTrilinear];
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];

    canEditFieldAuto1 = YES;
}

-(void)fieldAuto1DidUpdate{
    self.imgEmblem.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgEmblem setImageLogoName:fieldAuto1.logoName];
    self.imgEmblem.image = fieldAuto1.logo128;
}

@end
