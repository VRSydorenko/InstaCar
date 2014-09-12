//
//  SkinBasic_Info1.h
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinViewBase.h"

@interface SkinBasic_Info1 : SkinViewBase

@property (nonatomic) IBOutlet SkinElementLabel *labelAuto;
@property (nonatomic) IBOutlet SkinElementLabel *labelModel; // used to show Country, not renamed
@property (nonatomic) IBOutlet SkinElementLabel *labelYears;

@property (nonatomic) IBOutlet NSLayoutConstraint *labelModelHeight;
@property (nonatomic) IBOutlet NSLayoutConstraint *labelYearsHeight;

@end
