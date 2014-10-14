//
//  SkinEmo_IHeartName.m
//  InstaCar
//
//  Created by VRS on 03/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinEmo_IHeartName.h"

@interface SkinEmo_IHeartName(){
    NSString *iheartImgOrig;
    NSString *iheartImgInv;
    BOOL isInitState;
}

@property (nonatomic) IBOutlet NSLayoutConstraint *constraintTopMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinEmo_IHeartName

-(void)initialise{
    iheartImgOrig = @"iheart_256.png";
    iheartImgInv = @"iheartInv_256.png";
    
    [self setMovingViewConstraint:self.constraintTopMargin andViewHeight:self.movingView.bounds.size.height andMovingViewTopBottomMargin:0];
    
    self.movingView.backgroundColor = [UIColor clearColor];
    
    canEditFieldAuto1 = YES;
    _commandFlags.canCmdInvertColors = YES;
    isInitState = YES;
    movingViewTopBottomMargin = 10.0;
}

-(void)fieldAuto1DidUpdate{
    self.labelAuto.text = fieldAuto1.name;
}

-(void)onCmdInvertColors{
    [self.labelAuto invertColors];
    [self.imageIHeart setInvertedImage:[UIImage imageNamed:isInitState ? iheartImgInv : iheartImgOrig]];
    isInitState = !isInitState;
}
@end