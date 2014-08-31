//
//  LocationSimple.h
//  InstaCar
//
//  Created by Viktor on 10/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinViewBase.h"

@interface LocationSimple : SkinViewBase

@property (nonatomic) IBOutlet SkinElementLabel *textPlace;
@property (nonatomic) IBOutlet SkinElementLabel *textLocation;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintLocationHeight;

@end
