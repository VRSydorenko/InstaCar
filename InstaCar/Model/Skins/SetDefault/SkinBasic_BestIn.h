//
//  SkinBasic_BestIn.h
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinViewBase.h"

@interface SkinBasic_BestIn : SkinViewBase

@property (nonatomic) IBOutlet SkinElementLabel *labelLocation;
@property (weak, nonatomic) IBOutlet SkinElementLabel *labelBestIn;
@property (weak, nonatomic) IBOutlet SkinElementLabel *labelExclamationMark;
@property (weak, nonatomic) IBOutlet SkinElementImage *imageBgTop;
@property (weak, nonatomic) IBOutlet SkinElementImage *imageBgBottom;

@property (nonatomic) IBOutlet NSLayoutConstraint *constraintLocWidth;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintLocBkgWidth;

@end
