//
//  SkinSimple.h
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinViewBase.h"
#import "SkinElementImage.h"

@interface SkinSimple : SkinViewBase

@property (nonatomic) IBOutlet NSLayoutConstraint *autoTitleWidth;
@property (nonatomic) IBOutlet SkinElementImage *imgEmblem;
@property (nonatomic) IBOutlet UILabel *textAuto;

@end
