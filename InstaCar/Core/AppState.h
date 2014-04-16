//
//  AppState.h
//  InstaCar
//
//  Created by VRS on 16/04/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#define APPST_INITIAL_BUTTONS @"appst_initial_buttons"
#define APPST_CAPTURING_IMG @"appst_capturing_img"

@interface AppState : NSObject

+(BOOL)mainInitialButtonsState;
+(void)setInitialButtonsState:(BOOL)state;

+(BOOL)isCapturingImage;
+(void)setIsCapturingImage:(BOOL)state;

@end
