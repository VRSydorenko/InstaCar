//
//  SkinEmo_BestPresent.m
//  InstaCar
//
//  Created by VRS on 03/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinEmo_BestPresent.h"

@interface SkinEmo_BestPresent(){
    NSString *imgBestPresOrig;
    NSString *imgBestPresInv;
    BOOL isInitState;
}

@property (nonatomic) IBOutlet NSLayoutConstraint *constraintTopMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinEmo_BestPresent

-(void)initialise{
    imgBestPresOrig = @"bestPres_256.png";
    imgBestPresInv = @"bestPresInv_256.png";
    
    [self setMovingViewConstraint:self.constraintTopMargin andViewHeight:self.movingView.bounds.size.height];
    
    self.movingView.backgroundColor = [UIColor clearColor];
    
    canEditFieldAuto1 = YES;
    _commandFlags.canCmdInvertColors = YES;
    isInitState = YES;
    isContentOnTop = NO;
}

-(void)fieldAuto1DidUpdate{
    self.labelAuto.text = fieldAuto1.name;
}

-(void)onCmdInvertColors{
    [self.labelAuto invertColors];
    [self.imageBestPresent setInvertedImage:[UIImage imageNamed:isInitState ? imgBestPresInv : imgBestPresOrig]];
    isInitState = !isInitState;
}

@end
