//
//  UserSettings.h
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STORED_APP_VERSION @"stored_app_version"
#define LAST_USED_SKINSET @"stored_last_used_skinset"
#define PREF_LOGO_OVERLAY @"preference_logo_overlay"
#define PREF_USE_ICLOUD @"preference_use_icloud"

@interface UserSettings : NSObject

+(BOOL)isFullVersion;

+(NSString*) getStoredAppVersion;
+(void) setStoredAppVersion;

+(NSString*) getLastUsedSkinSet;
+(void) setLastUsedSkinSet:(NSString*)name;

+(BOOL)getLogoOverlayEnabled;
+(BOOL)getUseICloud;

@end
