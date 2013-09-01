//
//  UserSettings.h
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STORED_APP_VERSION @"stored_app_version"

@interface UserSettings : NSObject

+(NSString*) getStoredAppVersion;
+(void) setStoredAppVersion;

@end
