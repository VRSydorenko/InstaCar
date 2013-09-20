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

+(NSData*) compressImage:(UIImage*)image{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 100*1024;
    
    NSData *compressedData = UIImageJPEGRepresentation(image, compression);
    while (compressedData.length > maxFileSize && compression >= maxCompression)
    {
        compression -= 0.1;
        compressedData = UIImageJPEGRepresentation(image, compression);
    }
    return compressedData;
}

+(UIImage*)image:(UIImage*)sourceImage byScalingProportionallyToSize:(CGSize)targetSize{
    CGFloat widthFactor = targetSize.width / sourceImage.size.width;
    CGFloat heightFactor = targetSize.height / sourceImage.size.height;
    CGFloat scaleFactor = (widthFactor < heightFactor) ? widthFactor : heightFactor;
    
    CGFloat scaledWidth  = sourceImage.size.width * scaleFactor;
    CGFloat scaledHeight = sourceImage.size.height * scaleFactor;
    
    CGRect rect = CGRectMake(0.0, 0.0, scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(rect.size);
    [sourceImage drawInRect:rect];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
