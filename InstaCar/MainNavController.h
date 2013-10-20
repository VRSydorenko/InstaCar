//
//  MainNavController.h
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DDMenuController.h"
#import "AppDelegate.h"
#import "ProInfoVC.h"

typedef enum {
    APP_MENU = 0,
    LOCATIONS = 1,
    SKINS = 2,
} SideView; // MainVC tells navCon what to show on side

typedef enum {
    ACT_EMPTY = 0,
    ACT_LOAD_NEW_SKINSET = 1,
    ACT_UPDATE_SKINS_LOCATION = 2,
    ACT_OPEN_INSTA_SELF_TAG = 3,
    ACT_OPEN_INSTA_SELF_PROFILE = 4,
    ACT_OPEN_FB_PAGE = 5,
    ACT_PREPARE_FEEDBACK_MAIL = 6,
    ACT_OPEN_APPSTORE_TO_RATE = 7,
} SideAction; // side controller tells navCon what to do

typedef enum {
    AUTO1 = 0,
    AUTO2 = 1,
    SKIN_SET = 2,
    LOCATION = 3,
} SelectedDataChange; // navCon tells MainVC what has changed

@protocol SideActionProtocol <NSObject>
-(void) performSideAction:(SideAction)action withArgument:(id)object hidingSideController:(BOOL)hiding;
@end

@protocol SelectedDataChangeActionProtocol <NSObject>
-(void) selectedData:(SelectedDataChange)dataType changedTo:(id)newValue;
@end


@interface MainNavController : UINavigationController <SideActionProtocol,
                                                       DDMenuControllerDelegate,
                                                       LocationUpdateReceiverDelegate,
                                                       ProInfoViewControllerDelegate,
                                                       UIAlertViewDelegate,
                                                       MFMailComposeViewControllerDelegate>

@property NSObject<SelectedDataChangeActionProtocol> *dataSelectionChangeDelegate;
@property NSObject<DDMenuControllerDelegate> *menuControllerDelegate;

-(void)setSideViewController:(SideView)sideView andShowOnTheLeftSide:(BOOL)isLeft;
-(void)showLeft;
-(void)showRight;

@end
