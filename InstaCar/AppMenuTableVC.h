//
//  AppMenuTableVC.h
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNavController.h"

@interface AppMenuTableVC : UITableViewController <UITableViewDelegate>

@property id<SideActionProtocol> sideActionDelegate;

@end
