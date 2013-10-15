//
//  Utils.m
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "Utils.h"
#import "DataManager.h"

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

+(UIImage*)image:(UIImage*)sourceImage byScalingProportionallyToSize:(CGSize)targetSize{
    CGFloat widthFactor = targetSize.width / sourceImage.size.width;
    CGFloat heightFactor = targetSize.height / sourceImage.size.height;
    CGFloat scaleFactor = MAX(widthFactor, heightFactor);
    
    CGFloat scaledWidth  = sourceImage.size.width * scaleFactor;
    CGFloat scaledHeight = sourceImage.size.height * scaleFactor;
    
    CGRect rect = CGRectMake(0.0, 0.0, scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(rect.size);
    [sourceImage drawInRect:rect];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(NSString*)trimWhitespaces:(NSString*)string{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+(NSString*)getHashTagString{
    Auto *auto1 = [DataManager getSelectedAuto1];
    Auto *auto2 = [DataManager getSelectedAuto2];
    if (!auto1 && !auto2){
        return @"";
    }

    NSString *andCar2 = auto2 ? [NSString stringWithFormat:@" and #%@", auto2.name] : @"";
    return [NSString stringWithFormat:@"Great #instacar #%@%@ from the #instacarapp", [DataManager getSelectedAuto1].name, andCar2];
}

@end
