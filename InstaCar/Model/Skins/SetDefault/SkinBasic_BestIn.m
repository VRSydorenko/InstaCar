//
//  SkinBasic_BestIn.m
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinBasic_BestIn.h"

@interface SkinBasic_BestIn()

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinBasic_BestIn

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];
    
    canEditFieldLocation = YES;
    _commandFlags.canCmdInvertColors = YES;
}

-(void)fieldLocationDidUpdate{
    self.labelLocation.text = fieldLocation.name;
}

-(void)onCmdInvertColors{
    [self.labelBestIn invertColors];
    [self.labelLocation invertColors];
    [self.labelExclamationMark invertColors];
}

@end
