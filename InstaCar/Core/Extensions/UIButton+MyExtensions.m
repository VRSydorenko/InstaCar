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
    CGFloat topBottomMargin = (0.5 /*50%*/ * self.bounds.size.height) / 2 /*top & bottom*/;
    self.imageEdgeInsets = UIEdgeInsetsMake(topBottomMargin, 0, topBottomMargin, spacing);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
}

@end
