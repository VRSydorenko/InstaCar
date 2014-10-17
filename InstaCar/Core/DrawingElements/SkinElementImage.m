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

-(void)setImageLogoName:(NSString*)imageLogoName{
    logoName = imageLogoName;
}

-(UIImage*)elemImage128{
    if (nil == logoName || 0 == logoName.length){
        // the image's never been updated in runtime => it was set at design mode => return it
        return self.image;
    }
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@_128.png", logoName]];
}

-(UIImage*)elemImage256{
    if (nil == logoName || 0 == logoName.length){
        // the image's never been updated in runtime => it was set at design mode => return it
        return self.image;
    }
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@_256.png", logoName]];
}

// check

-(void)setImage:(UIImage *)image{
    // since this custom control can return more than one image (different sizes
    // of the same image) this check is required to be sure that the image name is set
    assert(nil != logoName && 0 < logoName.length);
    [super setImage: image];
}

// this method is ONLY used to change images because of the color inversion
// (backgrounds, etc) so ONLY for images set initially in the design mode (not for car logos)
// the difference between this and the setImage: methos only is that this one has
// no assert checking image name availability
-(void)setInvertedImage:(UIImage *)image{
        [super setImage: image];
}

@end
