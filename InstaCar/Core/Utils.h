//
//  Utils.h
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserSettings.h"
#import "ProInfoVC.h"

@interface Utils : NSObject

+(BOOL)appVersionDiffers;

+(UIImage*)image:(UIImage*)sourceImage byScalingProportionallyToSize:(CGSize)targetSize;
+(UIImage*)blurImage:(UIImage*)image strength:(CGFloat)strength;
+(NSString*)trimWhitespaces:(NSString*)string;
+(NSString*)getHashTagString;
+(NSString*)getAutoYearsString:(int)startYear endYear:(int)endYear;

+(void)openAppInAppStore:(BOOL)proVersion;
+(void)openAppPageOnFacebook;

+(UIColor*)invertColor:(UIColor*)color;

+(void)showAboutProVersionOnBehalfOf:(UIViewController<ProInfoViewControllerDelegate>*)delegateVC;

@end
