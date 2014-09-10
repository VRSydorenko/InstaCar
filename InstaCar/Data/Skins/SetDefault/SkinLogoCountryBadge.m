//
//  LogoCountryBadge.m
//  InstaCar
//
//  Created by VRS on 03/11/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinLogoCountryBadge.h"

@interface SkinLogoCountryBadge()

@property (nonatomic) IBOutlet NSLayoutConstraint *constraintTopMargin;
@property (nonatomic) IBOutlet SkinElementRect *movingView;

@end

@implementation SkinLogoCountryBadge

-(void)initialise{
    [self setMovingViewConstraint:self.constraintTopMargin andViewHeight:self.movingView.bounds.size.height];
    
    canEditFieldAuto1 = YES;
    isContentOnTop = NO;
    movingViewTopBottomMargin = 10.0;
}

-(void)fieldAuto1DidUpdate{
    self.imgEmblem.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgEmblem setImageLogoName:fieldAuto1.logoName];
    self.imgEmblem.image = fieldAuto1.logo128;
    self.textAuto.text = fieldAuto1.selectedTextShort;
    
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
