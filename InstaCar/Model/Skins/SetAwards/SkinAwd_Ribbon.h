//
//  SkinAwd_Ribbon.h
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinViewBase.h"

@interface SkinAwd_Ribbon : SkinViewBase

@property (nonatomic) IBOutlet SkinElementLabel *labelText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelRight;

@end
