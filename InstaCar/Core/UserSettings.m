//
//  UserSettings.m
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings

/* TODO: to be changed before release:
 * isFullVersion method return value
 * Setting bundle name
 */

+(BOOL)isFullVersion{
    return NO; // TODO: change before release
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
    
    return [self getBoolForKey:PREF_LOGO_OVERLAY defaultValue:YES];
}

+(BOOL)getUseICloud{
    return [self getBoolForKey:PREF_USE_ICLOUD defaultValue:YES];
}

+(BOOL)getSaveWhenSharing{
    // TODO: rename Setting bundle
    return [self getBoolForKey:PREF_SAVE_WHEN_SHARING defaultValue:YES];
}

+(BOOL)getBoolForKey:(NSString*)key defaultValue:(BOOL)defValue{
    NSObject *savedValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (nil == savedValue){
        return defValue;
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}
+(void)setBool:(BOOL)value forKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
}

@end
