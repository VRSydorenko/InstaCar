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
#define LOGO_OVERLAY_DISABLED @"stored_logo_overlay_disabled"

@interface UserSettings : NSObject

+(NSString*) getStoredAppVersion;
+(void) setStoredAppVersion;

+(NSString*) getLastUsedSkinSet;
+(void) setLastUsedSkinSet:(NSString*)name;

+(BOOL)getLogoOverlayDisabled;
+(void)setLogoOverlayDisabled:(BOOL)disabled;

@end
