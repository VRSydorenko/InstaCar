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

@property (nonatomic) IBOutlet NSLayoutConstraint *constraintTopMargin;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintLeftMargin;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintRightMargin;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintMovingViewHeight;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintLogoWidth;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintSeparatorWidth;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintCountryTextHeight;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinLogoCountryBadge

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
