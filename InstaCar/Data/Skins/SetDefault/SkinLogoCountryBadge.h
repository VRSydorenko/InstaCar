//
//  LogoCountryBadge.h
//  InstaCar
//
//  Created by VRS on 03/11/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinViewBase.h"

@interface SkinLogoCountryBadge : SkinViewBase

@property (weak, nonatomic) IBOutlet UIImageView *imgEmblem;
@property (weak, nonatomic) IBOutlet UILabel *textAuto;
@property (weak, nonatomic) IBOutlet UILabel *textCountry;

@end
