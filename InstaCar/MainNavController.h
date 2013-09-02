//
//  MainNavController.h
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    APP_MENU = 0,
    LOCATIONS = 1,
    SKINS = 2,
} SideView;

typedef enum {
    EMPTY = 0,
    SHOW_SETTINGS = 1
    } SideAction;

@protocol SideActionProtocol <NSObject>
-(void) performSideAction:(SideAction)action;
@end

@interface MainNavController : UINavigationController <SideActionProtocol>

-(void)setSideViewController:(SideView)sideView andShowOnTheLeftSide:(BOOL)isLeft;
-(void)showLeft;
-(void)showRight;

@end
