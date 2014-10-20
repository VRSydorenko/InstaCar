//
//  SkinVersusName.m
//  InstaCar
//
//  Created by VRS on 12/11/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinVersusName.h"

@interface SkinVersusName()

@property (weak, nonatomic) IBOutlet SkinElementImage *imgEmblem1;
@property (weak, nonatomic) IBOutlet SkinElementImage *imgEmblem2;
@property (weak, nonatomic) IBOutlet SkinElementLabel *textAuto1;
@property (weak, nonatomic) IBOutlet SkinElementLabel *textAuto2;
@property (weak, nonatomic) IBOutlet SkinElementRect *rectSeparator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopMargin;
@property (weak, nonatomic) IBOutlet UIView *movingView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintVSSeparatorLeftMargin;

@end


@implementation SkinVersusName

-(void)initialise{
    [self setMovingViewConstraint:self.constraintTopMargin andViewHeight:self.movingView.bounds.size.height andMovingViewTopBottomMargin:0];
    
    self.constraintVSSeparatorLeftMargin.constant = 0.5 * ([UIScreen mainScreen].bounds.size.width - 2);
    
    canEditFieldAuto1 = YES;
    canEditFieldAuto2 = YES;
    
    commands = [NSArray arrayWithObjects:
                [NSNumber numberWithInt:COMMAND_INVERTCOLORS],
                nil];
}

-(void)fieldAuto1DidUpdate{
    self.imgEmblem1.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgEmblem1 setImageLogoName:fieldAuto1.logoName];
    self.imgEmblem1.image = fieldAuto1.logo128;
    self.textAuto1.text = fieldAuto1.name;
}

-(void)fieldAuto2DidUpdate{
    self.imgEmblem2.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgEmblem2 setImageLogoName:fieldAuto2.logoName];
    self.imgEmblem2.image = fieldAuto2.logo128;
    self.textAuto2.text = fieldAuto2.name;
}

-(void)onCmdInvertColors{
    [self.textAuto1 invertColors];
    [self.textAuto2 invertColors];
    self.movingView.backgroundColor = [Utils invertColor:self.movingView.backgroundColor];
    self.rectSeparator.backgroundColor = [Utils invertColor:self.rectSeparator.backgroundColor];
}

@end
