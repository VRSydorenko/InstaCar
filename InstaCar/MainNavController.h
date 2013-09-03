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

typedef enum {
    AUTO = 0,
    SKIN_SET = 1,
} SelectedDataChange;

@protocol SideActionProtocol <NSObject>
-(void) performSideAction:(SideAction)action withArgument:(id)object;
@end

@protocol SelectedDataChangeActionProtocol <NSObject>
-(void) selectedData:(SelectedDataChange)dataType changedTo:(id)newValue;
@end


@interface MainNavController : UINavigationController <SideActionProtocol>

@property NSObject<SelectedDataChangeActionProtocol> *dataSelectionChangeDelegate;

-(void)setSideViewController:(SideView)sideView andShowOnTheLeftSide:(BOOL)isLeft;
-(void)showLeft;
-(void)showRight;

@end
