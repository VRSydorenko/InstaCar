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

@end
