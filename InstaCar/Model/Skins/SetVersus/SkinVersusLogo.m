//
//  SkinVersusName.m
//  InstaCar
//
//  Created by VRS on 12/11/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinVersusLogo.h"

@interface SkinVersusLogo()

@property (weak, nonatomic) IBOutlet SkinElementImage *imgEmblem1;
@property (weak, nonatomic) IBOutlet SkinElementImage *imgEmblem2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthLogo1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintwidthLogo2;
@property (weak, nonatomic) IBOutlet UIView *movingView;

@end


@implementation SkinVersusLogo

-(void)initialise{
    [self setMovingViewConstraint:self.constraintTopMargin andViewHeight:self.movingView.bounds.size.height andMovingViewTopBottomMargin:0];
    
    canEditFieldAuto1 = YES;
    canEditFieldAuto2 = YES;
    _commandFlags.canCmdInvertColors = YES;
}

-(void)fieldAuto1DidUpdate{
    self.imgEmblem1.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgEmblem1 setImageLogoName:fieldAuto1.logoName];
    self.imgEmblem1.image = fieldAuto1.logo128;
    
    CGFloat widthHeightRate = fieldAuto1 ? fieldAuto1.logoWidthHeightRate : 1.0;
    self.constraintWidthLogo1.constant = widthHeightRate * self.imgEmblem1.bounds.size.height;
}

-(void)fieldAuto2DidUpdate{
    self.imgEmblem2.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgEmblem2 setImageLogoName:fieldAuto2.logoName];
    self.imgEmblem2.image = fieldAuto2.logo128;
    
    CGFloat widthHeightRate = fieldAuto2 ? fieldAuto2.logoWidthHeightRate : 1.0;
    self.constraintwidthLogo2.constant = widthHeightRate * self.imgEmblem2.bounds.size.height;
}

-(void)onCmdInvertColors{
    self.movingView.backgroundColor = [Utils invertColor:self.movingView.backgroundColor];
}

@end
