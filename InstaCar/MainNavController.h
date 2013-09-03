//
//  MainNavController.h
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"

typedef enum {
    APP_MENU = 0,
    LOCATIONS = 1,
    SKINS = 2,
} SideView; // MainVC tells navCon what to show on side

typedef enum {
    EMPTY = 0,
    SHOW_SETTINGS = 1,
    LOAD_NEW_SKIN = 2,
} SideAction; // side controller tells navCon what to do

typedef enum {
    AUTO = 0,
    SKIN_SET = 1,
} SelectedDataChange; // navCon tells MainVC what has changed

@protocol SideActionProtocol <NSObject>
-(void) performSideAction:(SideAction)action withArgument:(id)object;
@end

@protocol SelectedDataChangeActionProtocol <NSObject>
-(void) selectedData:(SelectedDataChange)dataType changedTo:(id)newValue;
@end


@interface MainNavController : UINavigationController <SideActionProtocol,
                                                       DDMenuControllerDelegate>

@property NSObject<SelectedDataChangeActionProtocol> *dataSelectionChangeDelegate;
@property NSObject<DDMenuControllerDelegate> *menuControllerDelegate;

-(void)setSideViewController:(SideView)sideView andShowOnTheLeftSide:(BOOL)isLeft;
-(void)showLeft;
-(void)showRight;

@end
