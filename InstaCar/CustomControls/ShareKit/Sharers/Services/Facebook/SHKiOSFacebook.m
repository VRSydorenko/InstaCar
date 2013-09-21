//
//  SHKiOSFacebook.m
//  ShareKit
//
//  Created by Vilem Kurz on 18/11/2012.
//
//

#import "SHKiOSFacebook.h"
#import "SHKiOSSharer_Protected.h"
#import "SharersCommonHeaders.h"

@implementation SHKiOSFacebook

+ (NSString *)sharerTitle
{
	return @"Facebook";
}

+ (NSString *)sharerId
{
	return @"SHKFacebook";
}

- (void)share {
    
    [self shareWithServiceType:SLServiceTypeFacebook];
}

+ (BOOL)canShareImage
{
    return YES;
}

+ (BOOL)canShareText
{
	return YES;
}

@end