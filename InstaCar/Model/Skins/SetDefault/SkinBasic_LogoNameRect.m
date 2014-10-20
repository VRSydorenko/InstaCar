//
//  SkinBasic_LogoNameRect.m
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinBasic_LogoNameRect.h"

@interface SkinBasic_LogoNameRect()

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet NSLayoutConstraint *labelWidth;
@property (nonatomic) IBOutlet NSLayoutConstraint *movingViewWidth;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinBasic_LogoNameRect

-(void)initialise{
    [self.imageLogo.layer setMinificationFilter:kCAFilterTrilinear];
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height andMovingViewTopBottomMargin:0];
    
    canEditFieldAuto1 = YES;
    
    commands = [NSArray arrayWithObjects:
                [NSNumber numberWithInt:COMMAND_INVERTCOLORS],
                nil];
}

-(void)fieldAuto1DidUpdate{
    self.imageLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageLogo setImageLogoName:fieldAuto1.logoName];
    self.imageLogo.image = fieldAuto1.logo128;
    
    self.labelAuto.text = fieldAuto1.name;
    [self adjustAutoLabelSizeAccordingToText];
}

-(void)onCmdInvertColors{
    [self.labelAuto invertColors];
    
    self.rectTLH.backgroundColor = [Utils invertColor:self.rectTLH.backgroundColor];
    self.rectTLV.backgroundColor = [Utils invertColor:self.rectTLV.backgroundColor];
    self.rectBLH.backgroundColor = [Utils invertColor:self.rectBLH.backgroundColor];
    self.rectBLV.backgroundColor = [Utils invertColor:self.rectBLV.backgroundColor];
    self.rectTRH.backgroundColor = [Utils invertColor:self.rectTRH.backgroundColor];
    self.rectTRV.backgroundColor = [Utils invertColor:self.rectTRV.backgroundColor];
    self.rectBRH.backgroundColor = [Utils invertColor:self.rectBRH.backgroundColor];
    self.rectBRV.backgroundColor = [Utils invertColor:self.rectBRV.backgroundColor];
}

-(void)adjustAutoLabelSizeAccordingToText{
    CGSize textSize = [self.labelAuto.text sizeWithAttributes:[NSDictionary dictionaryWithObject:self.labelAuto.font forKey:NSFontAttributeName]];
    self.labelWidth.constant = MIN(textSize.width, self.bounds.size.width * 0.7 /*max 70% of the screen*/);
    self.movingViewWidth.constant = self.labelWidth.constant + 2 * 3.0 /*corner rects*/ + 2 * 3.0 /*corer rect margins*/ + 75.0 /*logo width*/;
}

@end
