//
//  AppDelegate.h
//  InstaCar
//
//  Created by VRS on 7/13/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"
#import "DbManager.h"
#import <CoreLocation/CoreLocation.h>

@protocol LocationUpdateReceiverDelegate <NSObject>
-(void)locationDidUpdate;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,
                                      CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DDMenuController *menuController;
@property (nonatomic) id<LocationUpdateReceiverDelegate> locationUpdateReceiverDelegate;

@property DbManager* dbManager;
@property CLLocationManager *locationManager;

@end
