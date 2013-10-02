//
//  SkinSimple2.m
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinSimple2.h"

@interface SkinSimple2(){
    CGFloat heightScaleFactor;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLogoConstraint;
@property (weak, nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinSimple2

-(void)layoutSubviews{
    self.heightConstraint.constant = self.bounds.size.height * heightScaleFactor;
    self.widthLogoConstraint.constant = self.imgEmblem.bounds.size.height; // 30% wider than taller
    
    [super layoutSubviews];
}

-(void)initialise{
    [self setupGradient:0.2 inDirection:GRADIENT_RIGHT];
    heightScaleFactor = self.movingView.bounds.size.height / self.bounds.size.height;
    [self.imgEmblem.layer setMinificationFilter:kCAFilterTrilinear];
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];

    canEditFieldAuto1 = YES;
}

-(void)fieldAuto1DidUpdate{
    self.imgEmblem.contentMode = UIViewContentModeScaleAspectFit;
    self.imgEmblem.image = [UIImage imageNamed:fieldAuto1.logo];
}

@end
