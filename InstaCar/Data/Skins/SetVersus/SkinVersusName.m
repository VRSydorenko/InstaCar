//
//  SkinVersusName.m
//  InstaCar
//
//  Created by VRS on 12/11/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinVersusName.h"

@interface SkinVersusName()

@property (weak, nonatomic) IBOutlet UIImageView *imgEmblem1;
@property (weak, nonatomic) IBOutlet UIImageView *imgEmblem2;
@property (weak, nonatomic) IBOutlet UILabel *textAuto1;
@property (weak, nonatomic) IBOutlet UILabel *textAuto2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthLogo1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintwidthLogo2;
@property (weak, nonatomic) IBOutlet UIView *movingView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLogo1TopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLogo1BottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLogo2TopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLogo2BottomMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintVSSeparatorWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintVSSeparatorLeftMargin;

@end


@implementation SkinVersusName

-(void)initialise{
    [self setMovingViewConstraint:self.constraintTopMargin andViewHeight:self.movingView.bounds.size.height];
    
    canEditFieldAuto1 = YES;
    canEditFieldAuto2 = YES;
    isContentOnTop = NO;
}

-(void)fieldAuto1DidUpdate{
    self.imgEmblem1.contentMode = UIViewContentModeScaleAspectFit;
    self.imgEmblem1.image = [UIImage imageNamed:fieldAuto1.logo];
    self.textAuto1.text = fieldAuto1.name;
}

-(void)fieldAuto2DidUpdate{
    self.imgEmblem2.contentMode = UIViewContentModeScaleAspectFit;
    self.imgEmblem2.image = [UIImage imageNamed:fieldAuto2.logo];
    self.textAuto2.text = fieldAuto2.name;
}

-(void)layoutSubviews{
    CGFloat boundsWidth = self.bounds.size.width;
    
    // moving view height
    self.constraintHeight.constant = self.bounds.size.height * heightScaleFactor;
    
    // logo top & bottom margins
    CGFloat logosTopBottomMargin = self.movingView.bounds.size.height / 6.0;
    self.constraintLogo1TopMargin.constant = logosTopBottomMargin;
    self.constraintLogo1BottomMargin.constant = logosTopBottomMargin;
    self.constraintLogo2TopMargin.constant = logosTopBottomMargin;
    self.constraintLogo2BottomMargin.constant = logosTopBottomMargin;
    
    // logo proportion
    CGFloat widthHeightRate = fieldAuto1 ? fieldAuto1.logoWidthHeightRate : 1.0;
    self.constraintWidthLogo1.constant = widthHeightRate * self.imgEmblem1.bounds.size.height; // adjust place for logo 1
    
    widthHeightRate = fieldAuto2 ? fieldAuto2.logoWidthHeightRate : 1.0;
    self.constraintwidthLogo2.constant = widthHeightRate * self.imgEmblem2.bounds.size.height; // adjust place for logo 2
    
    // separator view
    self.constraintVSSeparatorWidth.constant = boundsWidth > 320.0 ? 4.0 : 2.0;
    
    // separator position
    self.constraintVSSeparatorLeftMargin.constant = 0.5 * (boundsWidth - self.constraintVSSeparatorWidth.constant);
    
    // text fonts
    float newAutoFontSize = boundsWidth > 320.0 ? 50.0 : 25.0;
    
    self.textAuto1.font = [UIFont fontWithName:self.textAuto1.font.fontName size:newAutoFontSize];
    self.textAuto2.font = [UIFont fontWithName:self.textAuto2.font.fontName size:newAutoFontSize];
    
    [super layoutSubviews];
}

@end
