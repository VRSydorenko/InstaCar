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
    return [UIColor colorWithCGColor:self.layer.backgroundColor];
}

-(CGRect)elemRectInParent{
    return self.frame;
}

-(ElementType)elemType;
{
    return ELEM_RECT;
}

-(UIColor*)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(CGFloat)borderWidth{
    return self.layer.borderWidth;
}

@end
