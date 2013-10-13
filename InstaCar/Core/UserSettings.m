//
//  UserSettings.m
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings

+(BOOL)isFullVersion{
    return YES; // TODO: change before release
}

+(NSString*) getStoredAppVersion{
    return [[NSUserDefaults standardUserDefaults] stringForKey:STORED_APP_VERSION];
}
+(void) setStoredAppVersion{
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setValue:appVersionString forKey:STORED_APP_VERSION];
}

+(NSString*) getLastUsedSkinSet{
    return [[NSUserDefaults standardUserDefaults] stringForKey:LAST_USED_SKINSET];
}
+(void) setLastUsedSkinSet:(NSString*)name{
    [[NSUserDefaults standardUserDefaults] setValue:name forKey:LAST_USED_SKINSET];
}

+(BOOL)getLogoOverlayEnabled{
    NSObject *configuredValue = [[NSUserDefaults standardUserDefaults] objectForKey:PREF_LOGO_OVERLAY];
    return configuredValue == nil ? YES : (BOOL)configuredValue;
}

+(BOOL)getUseICloud{
    NSObject *configuredValue = [[NSUserDefaults standardUserDefaults] objectForKey:PREF_USE_ICLOUD];
    return [self isFullVersion] ? (configuredValue == nil ? YES : (BOOL)configuredValue) : NO;
}

@end
