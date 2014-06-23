//
//  SkinElementImage.m
//  InstaCar
//
//  Created by VRS on 20/06/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinElementImage.h"

@implementation SkinElementImage

// base

-(UIColor*)elemColor{
    return [UIColor clearColor];
}

-(CGRect)elemRectInParent{
    return self.frame;
}

-(ElementType)elemType;
{
    return ELEM_IMAGE;
}

// image

-(UIImage*)elemImage{
    return self.image;
}


@end
