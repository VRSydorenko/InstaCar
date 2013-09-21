//
//  SideViewControllerBase.h
//  InstaCar
//
//  Created by VRS on 8/23/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNavController.h"

@interface SideViewControllerBase : UIViewController

@property id<SideActionProtocol> sideActionDelegate;

@end
