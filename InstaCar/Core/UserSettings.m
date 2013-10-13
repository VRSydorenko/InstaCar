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

+(NSString*) getLastUsedSkinSet{
    return [[NSUserDefaults standardUserDefaults] stringForKey:LAST_USED_SKINSET];
}
+(void) setLastUsedSkinSet:(NSString*)name{
    [[NSUserDefaults standardUserDefaults] setValue:name forKey:LAST_USED_SKINSET];
}

+(BOOL)getLogoOverlayDisabled{
    return [[NSUserDefaults standardUserDefaults] boolForKey:LOGO_OVERLAY_DISABLED];
}
+(void)setLogoOverlayDisabled:(BOOL)disabled{
    [[NSUserDefaults standardUserDefaults] setBool:disabled forKey:LOGO_OVERLAY_DISABLED];
}

@end
