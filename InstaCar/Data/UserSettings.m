//
//  UserSettings.m
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings

+(NSString*) getStoredAppVersion{
    return [[NSUserDefaults standardUserDefaults] stringForKey:STORED_APP_VERSION];
}
+(void) setStoredAppVersion{
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setValue:appVersionString forKey:STORED_APP_VERSION];
}

@end
