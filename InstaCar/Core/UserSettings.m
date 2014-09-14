//
//  UserSettings.m
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings

/* to be changed before release:
 * isFullVersion method return value
 * Setting bundle name
 */

+(BOOL)isFullVersion{
    return NO;
}

+(BOOL)isIPhone4{
    return [UIScreen mainScreen].bounds.size.height == 480;
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

+(BOOL)getHasLaunchedBefore{
    return [[NSUserDefaults standardUserDefaults] boolForKey:HAS_LAUNCHED_BEFORE];
}
+(void)setHasLaunchedBefore{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_LAUNCHED_BEFORE];
}

+(BOOL)getLogoOverlayEnabled{
    if (NO == [self isFullVersion]){
        return YES;
    }
    
    NSObject *configuredValue = [[NSUserDefaults standardUserDefaults] objectForKey:PREF_LOGO_OVERLAY];
    if (nil == configuredValue){
        return YES;
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:PREF_LOGO_OVERLAY];
}

+(BOOL)getUseICloud{
    NSObject *configuredValue = [[NSUserDefaults standardUserDefaults] objectForKey:PREF_USE_ICLOUD];
    if (nil == configuredValue){
        return YES;
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:PREF_USE_ICLOUD];
}

+(BOOL)getSaveWhenSharing{
    NSObject *configuredValue = [[NSUserDefaults standardUserDefaults] objectForKey:PREF_SAVE_WHEN_SHARING];
    if (nil == configuredValue){
        return YES;
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:PREF_SAVE_WHEN_SHARING];
}

@end
