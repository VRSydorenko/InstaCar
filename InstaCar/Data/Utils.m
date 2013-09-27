//
//  Utils.m
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(BOOL)appVersionDiffers{
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return ![appVersionString isEqualToString:[UserSettings getStoredAppVersion]];
}

+(UIImage*)blurImage:(UIImage*)image strength:(CGFloat)strength{
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:image.CIImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat:strength] forKey: @"inputRadius"];
    
    CIImage *resultImage = [gaussianBlurFilter valueForKey: @"outputImage"];
    return [[UIImage alloc] initWithCIImage:resultImage scale:image.scale orientation:UIImageOrientationUp];
}

@end
