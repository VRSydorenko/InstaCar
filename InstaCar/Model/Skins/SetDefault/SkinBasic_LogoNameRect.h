//
//  SkinBasic_LogoNameRect.h
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinViewBase.h"

@interface SkinBasic_LogoNameRect : SkinViewBase

@property (nonatomic) IBOutlet SkinElementImage *imageLogo;
@property (nonatomic) IBOutlet SkinElementLabel *labelAuto;

@property (nonatomic) IBOutlet SkinElementRect *rectTLH;
@property (nonatomic) IBOutlet SkinElementRect *rectTLV;
@property (nonatomic) IBOutlet SkinElementRect *rectBLH;
@property (nonatomic) IBOutlet SkinElementRect *rectBLV;
@property (nonatomic) IBOutlet SkinElementRect *rectTRH;
@property (nonatomic) IBOutlet SkinElementRect *rectTRV;
@property (nonatomic) IBOutlet SkinElementRect *rectBRH;
@property (nonatomic) IBOutlet SkinElementRect *rectBRV;

@end
