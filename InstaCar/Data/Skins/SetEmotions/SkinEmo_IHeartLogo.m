//
//  SkinEmo_IHeartLogo.m
//  InstaCar
//
//  Created by VRS on 03/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinEmo_IHeartLogo.h"

@interface SkinEmo_IHeartLogo()

@property (nonatomic) IBOutlet NSLayoutConstraint *constraintTopMargin;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintLogoWidth;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinEmo_IHeartLogo

-(void)initialise{
    //[self setupGradient:0.2 inDirection:GRADIENT_UP];
    [self setMovingViewConstraint:self.constraintTopMargin andViewHeight:self.movingView.bounds.size.height];
    
    self.movingView.backgroundColor = [UIColor clearColor];
    
    canEditFieldAuto1 = YES;
    isContentOnTop = NO;
    movingViewTopBottomMargin = 10.0;
}

-(void)fieldAuto1DidUpdate{
    self.imgEmblem.contentMode = UIViewContentModeScaleAspectFit;
    self.imgEmblem.image = [UIImage imageNamed:fieldAuto1.logo];
    self.constraintLogoWidth.constant = self.imgEmblem.bounds.size.height * fieldAuto1.logoWidthHeightRate;
}
@end
