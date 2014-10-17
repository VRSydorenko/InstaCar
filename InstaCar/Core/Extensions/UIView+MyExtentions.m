//
//  UIView+MyExtentions.m
//  InstaCar
//
//  Created by VRS on 16/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "UIView+MyExtentions.h"

@implementation UIView (MyExtentions)

-(void)setHiddenWithNumber:(NSNumber*)hidden{
    [self setHidden:[hidden boolValue]];
}

@end
