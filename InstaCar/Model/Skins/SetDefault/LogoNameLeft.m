//
//  LogoNameLeft.m
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "LogoNameLeft.h"
#import "DataManager.h"

@interface LogoNameLeft()

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation LogoNameLeft

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    [self.imgEmblem.layer setMinificationFilter:kCAFilterTrilinear];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];

    canEditFieldAuto1 = YES;
    _commandFlags.canCmdInvertColors = YES;
}

-(void)fieldAuto1DidUpdate{
    self.imgEmblem.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgEmblem setImageLogoName:fieldAuto1.logoName];
    self.imgEmblem.image = fieldAuto1.logo128;
    self.textAuto.text = fieldAuto1.selectedTextShort;
}

-(void)onCmdInvertColors{
    [self.textAuto invertColors];
}

@end
