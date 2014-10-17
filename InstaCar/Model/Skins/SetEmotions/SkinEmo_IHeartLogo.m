//
//  SkinEmo_IHeartLogo.m
//  InstaCar
//
//  Created by VRS on 03/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinEmo_IHeartLogo.h"

@interface SkinEmo_IHeartLogo(){
    NSString *iheartImgOrig;
    NSString *iheartImgInv;
    BOOL isInitState;
}

@property (nonatomic) IBOutlet NSLayoutConstraint *constraintTopMargin;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintLogoWidth;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinEmo_IHeartLogo

-(void)initialise{
    iheartImgOrig = @"iheart_256.png";
    iheartImgInv = @"iheartInv_256.png";
    
    [self setMovingViewConstraint:self.constraintTopMargin andViewHeight:self.movingView.bounds.size.height andMovingViewTopBottomMargin:10.0];
    
    self.movingView.backgroundColor = [UIColor clearColor];
    
    canEditFieldAuto1 = YES;
    _commandFlags.canCmdInvertColors = YES;
    isInitState = YES;
}

-(void)fieldAuto1DidUpdate{
    self.imgEmblem.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgEmblem setImageLogoName:fieldAuto1.logoName];
    self.imgEmblem.image = fieldAuto1.logo128;
    self.constraintLogoWidth.constant = self.imgEmblem.bounds.size.height * fieldAuto1.logoWidthHeightRate;
}

-(void)onCmdInvertColors{
    [self.imgIHeart setInvertedImage:[UIImage imageNamed:isInitState ? iheartImgInv : iheartImgOrig]];
    isInitState = !isInitState;
}
@end
