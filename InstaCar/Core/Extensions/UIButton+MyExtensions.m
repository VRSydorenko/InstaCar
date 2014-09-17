//
//  UIButton+MyExtensions.m
//  InstaCar
//
//  Created by VRS on 17/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "UIButton+MyExtensions.h"

@implementation UIButton (MyExtensions)

-(void) centerButtonAndImageWithSpacing:(CGFloat)spacing {
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
}

@end
