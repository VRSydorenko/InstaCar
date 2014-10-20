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
    [self setMovingViewConstraint:self.constraintTopMargin andViewHeight:self.movingView.bounds.size.height andMovingViewTopBottomMargin:10.0];
    
    canEditFieldAuto1 = YES;
    
    commands = [NSArray arrayWithObjects:
                [NSNumber numberWithInt:COMMAND_INVERTCOLORS],
                nil];
}

-(void)fieldAuto1DidUpdate{
    self.imgEmblem.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgEmblem setImageLogoName:fieldAuto1.logoName];
    self.imgEmblem.image = fieldAuto1.logo128;
    self.textAuto.text = fieldAuto1.selectedTextModelSubmodel.length > 0 ? fieldAuto1.selectedTextModelSubmodel : fieldAuto1.name;
    
    NSString *autoYears = fieldAuto1.selectedTextYears;
    if (autoYears.length > 0){
        autoYears = [NSString stringWithFormat:@", %@", autoYears];
    }
    self.textCountry.text = [NSString stringWithFormat:@"%@%@", fieldAuto1.country, autoYears];
}

-(void)onCmdInvertColors{
    [self.textAuto invertColors];
    [self.textCountry invertColors];
    self.movingView.backgroundColor = [Utils invertColor:self.movingView.backgroundColor];
    self.rectSeparator.backgroundColor = [Utils invertColor:self.rectSeparator.backgroundColor];
}

@end
