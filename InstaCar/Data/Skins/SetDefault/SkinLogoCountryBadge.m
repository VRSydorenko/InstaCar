//
//  LogoCountryBadge.m
//  InstaCar
//
//  Created by VRS on 03/11/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinLogoCountryBadge.h"

@interface SkinLogoCountryBadge(){
    CGFloat countryLabelHeightScaleFactor;
    CGFloat initialSideMargin;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintRightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMovingViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLogoWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSeparatorWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCountryTextHeight;
@property (weak, nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinLogoCountryBadge

-(void)layoutSubviews{
    // moving viee height
    self.constraintMovingViewHeight.constant = self.bounds.size.height * heightScaleFactor;
    
    // left & right margins
    CGFloat widthRate = self.bounds.size.width / 320.0; // screen width
    self.constraintLeftMargin.constant = initialSideMargin * widthRate;
    self.constraintRightMargin.constant = initialSideMargin * widthRate;
    
    // logo proportion
    CGFloat widthHeightRate = fieldAuto1 ? fieldAuto1.logoWidthHeightRate : 1.0;
    self.constraintLogoWidth.constant = widthHeightRate * self.imgEmblem.bounds.size.height; // adjust place for logo
    
    // separator view
    self.constraintSeparatorWidth.constant = self.bounds.size.width > 320.0 ? 4.0 : 2.0;
    
    // text sizes
    self.constraintCountryTextHeight.constant = self.movingView.bounds.size.height * countryLabelHeightScaleFactor;
    
    // text fonts
    float newAutoFontSize = self.bounds.size.width > 320.0 ? 90.0 : 35.0;
    self.textAuto.font = [UIFont fontWithName:self.textAuto.font.fontName size:newAutoFontSize];
    
    float newCountryFontSize = self.bounds.size.width > 320.0 ? 50.0 : 15.0;
    self.textCountry.font = [UIFont fontWithName:self.textAuto.font.fontName size:newCountryFontSize];
    
    [super layoutSubviews];
}

-(void)initialise{
    initialSideMargin = self.constraintLeftMargin.constant; // the same as right margin constraint
    countryLabelHeightScaleFactor = self.constraintCountryTextHeight.constant / self.movingView.bounds.size.height;
    [self setMovingViewConstraint:self.constraintTopMargin andViewHeight:self.movingView.bounds.size.height];
    
    canEditFieldAuto1 = YES;
    isContentOnTop = NO;
    movingViewTopBottomMargin = 10.0;
}

-(void)fieldAuto1DidUpdate{
    self.imgEmblem.contentMode = UIViewContentModeScaleAspectFit;
    self.imgEmblem.image = [UIImage imageNamed:fieldAuto1.logo];
    self.textAuto.text = fieldAuto1.selectedText;
    
    NSString *autoYears = @"";
    if (fieldAuto1.model){
        autoYears = [Utils getAutoYearsString:fieldAuto1.model.startYear endYear:fieldAuto1.model.endYear];
        if (autoYears.length > 0){
            autoYears = [NSString stringWithFormat:@", %@", autoYears];
        }
    }
    self.textCountry.text = [NSString stringWithFormat:@"%@%@", fieldAuto1.country, autoYears];
}

@end
