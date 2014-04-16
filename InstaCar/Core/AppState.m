//
//  AppState.m
//  InstaCar
//
//  Created by VRS on 16/04/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "AppState.h"
#import "UserSettings.h"

@implementation AppState

+(BOOL)mainInitialButtonsState{
    return [self getSyncronizedForKey:APPST_INITIAL_BUTTONS defaultValue:YES];
}
+(void)setInitialButtonsState:(BOOL)state{
    [self setSyncronized:state forKey:APPST_INITIAL_BUTTONS];
}

+(BOOL)isCapturingImage{
    return [self getSyncronizedForKey:APPST_CAPTURING_IMG defaultValue:NO];
}
+(void)setIsCapturingImage:(BOOL)state{
    [self setSyncronized:state forKey:APPST_CAPTURING_IMG];
}

+(BOOL)getSyncronizedForKey:(NSString*)key defaultValue:(BOOL)defVal{
    @synchronized(self){
        return [UserSettings getBoolForKey:key defaultValue:defVal];
    }
}
+(void)setSyncronized:(BOOL)state forKey:(NSString*)key{
    @synchronized(self){
        [UserSettings setBool:state forKey:key];
    }
}

@end
