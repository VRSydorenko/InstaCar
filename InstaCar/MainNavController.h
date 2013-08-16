//
//  MainNavController.h
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EMPTY = 0,
    SHOW_SETTINGS = 1
    } SideAction;

@protocol SideActionProtocol <NSObject>
-(void) performSideAction:(SideAction)action;
@end

@interface MainNavController : UINavigationController <SideActionProtocol>

@end
