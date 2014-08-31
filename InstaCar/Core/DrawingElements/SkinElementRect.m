//
//  SkinElementRect.m
//  InstaCar
//
//  Created by VRS on 20/06/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinElementRect.h"

@implementation SkinElementRect

// base

-(UIColor*)elemColor{
    return [UIColor whiteColor];
}

-(CGRect)elemRectInParent{
    return self.frame;
}

-(ElementType)elemType;
{
    return ELEM_BASE;
}

@end