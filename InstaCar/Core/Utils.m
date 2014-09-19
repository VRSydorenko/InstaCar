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
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor){
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage;
}

+(NSString*)trimWhitespaces:(NSString*)string{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+(NSString*)getHashTagString{
    Auto *auto1 = [DataManager getSelectedAuto1];
    BOOL secondAutoSupported = [DataManager getSelectedSkinSet].supportsSecondCar;
    Auto *auto2 = secondAutoSupported ? [DataManager getSelectedAuto2] : nil;
    if (!auto1 && !auto2){
        return @"Share your #instacar with #instacarapp";
    }

    NSString *car1String = auto1 ? [NSString stringWithFormat:@"#%@", auto1.name] : @"";
    NSString *car2String = auto2 ? [NSString stringWithFormat:@"#%@", auto2.name] : @"";
    NSString *andCarsString = auto1 && auto2 ? @" and " : @"";
    NSString *carsString = [NSString stringWithFormat:@"%@%@%@", car1String, andCarsString, car2String];
    
    return [NSString stringWithFormat:@"Great #instacar %@ from the #instacarapp", carsString];
}

+(NSString*)getAutoYearsString:(int)startYear endYear:(int)endYear{
    NSString *result = @"";
    
    if (startYear > 0){
        if (endYear == -1){
            result = [NSString stringWithFormat:@"%d", startYear];
        } else if (endYear == 0){
            result = [NSString stringWithFormat:@"since %d", startYear];
        } else if (endYear == startYear) {
            result = [NSString stringWithFormat:@"in %d", startYear];
        } else if (endYear > 0){
            result = [NSString stringWithFormat:@"%d-%d", startYear, endYear];
        }
    }
    
    return result;
}

+(void)openAppInAppStore:(BOOL)proVersion{
    NSString *url = @"";
    if (proVersion){
        url = @"itms-apps://itunes.apple.com/app/id726603505";
    } else {
        url = @"itms-apps://itunes.apple.com/app/id726603550";
    }
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

+(void)openAppPageOnFacebook{
    NSURL *facebookPageUrl = [NSURL URLWithString:@"fb://profile/496058110489790"];
    if (![[UIApplication sharedApplication] canOpenURL:facebookPageUrl]) {
        facebookPageUrl = [NSURL URLWithString:@"http://www.facebook.com/InstacarApp"];
    }
    [[UIApplication sharedApplication] openURL:facebookPageUrl];
}

+(UIColor*)invertColor:(UIColor*)color{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1-r green:1-g blue:1-b alpha:a];
}

@end
