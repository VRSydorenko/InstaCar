//
//  SkinSimple.h
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinViewBase.h"

@interface SkinSimple : SkinViewBase

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autoTitleWidth;
@property (weak, nonatomic) IBOutlet UIImageView *imgEmblem;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *textAuto;

@end
