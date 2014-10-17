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
#define HAS_LAUNCHED_BEFORE @"stored_has_launched_before"
#define PREF_LOGO_OVERLAY @"preference_logo_overlay"
#define PREF_USE_ICLOUD @"preference_use_icloud"
#define PREF_SAVE_WHEN_SHARING @"preference_save_when_sharing"

@interface UserSettings : NSObject

+(BOOL)isFullVersion;
+(BOOL)isIPhone4;

+(NSString*) getStoredAppVersion;
+(void) setStoredAppVersion;

+(NSString*) getLastUsedSkinSet;
+(void) setLastUsedSkinSet:(NSString*)name;

+(BOOL)getHasLaunchedBefore;
+(void)setHasLaunchedBefore;

+(BOOL)getLogoOverlayEnabled;
+(BOOL)getUseICloud;
+(BOOL)getSaveWhenSharing;

@end
