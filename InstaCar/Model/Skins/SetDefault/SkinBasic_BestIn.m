//
//  SkinBasic_BestIn.m
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinBasic_BestIn.h"

@interface SkinBasic_BestIn(){
    NSString *imgTopOrig;
    NSString *imgTopInv;
    NSString *imgBotOrig;
    NSString *imgBotInv;
    
    BOOL origInvState;
}

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinBasic_BestIn

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];
    
    canEditFieldLocation = YES;
    origInvState = YES;
    _commandFlags.canCmdInvertColors = YES;
    
    imgTopOrig = @"madeIn.png";
    imgTopInv = @"madeIn.png";
    imgBotOrig = @"madeIn.png";
    imgBotInv = @"madeIn.png";
    
    [self adjustWidthSizeAccordingToText];
}

-(void)fieldLocationDidUpdate{
    self.labelLocation.text = fieldLocation.name;
    [self adjustWidthSizeAccordingToText];
}

-(void)adjustWidthSizeAccordingToText{
    CGSize textSize = [self.labelLocation.text sizeWithAttributes:[NSDictionary dictionaryWithObject:self.labelLocation.font forKey:NSFontAttributeName]];
    self.constraintLocWidth.constant = MIN(5.0+textSize.width, self.bounds.size.width * 0.9 /*max 90% of the screen width*/);
    self.constraintLocBkgWidth.constant = self.constraintLocWidth.constant + 25.0 /*exclamation mark label width*/;
}

-(void)onCmdInvertColors{
    self.labelBestIn.textColor = [Utils invertColor:self.labelBestIn.textColor];
    self.labelLocation.textColor = [Utils invertColor:self.labelLocation.textColor];
    self.labelExclamationMark.textColor = [Utils invertColor:self.labelExclamationMark.textColor];
    
    [self.imageBgTop setInvertedImage:[UIImage imageNamed:origInvState ? imgTopInv : imgTopOrig]];
    [self.imageBgBottom setInvertedImage:[UIImage imageNamed:origInvState ? imgBotInv : imgBotOrig]];
    origInvState = !origInvState;
}

@end
