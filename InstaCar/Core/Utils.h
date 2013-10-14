//
//  Utils.h
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserSettings.h"

@interface Utils : NSObject

+(BOOL)appVersionDiffers;

+(UIImage*)image:(UIImage*)sourceImage byScalingProportionallyToSize:(CGSize)targetSize;
+(UIImage*)blurImage:(UIImage*)image strength:(CGFloat)strength;
+(NSString*)trimWhitespaces:(NSString*)string;
+(NSString*)getHashTagString;

@end
