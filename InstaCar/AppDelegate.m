//
//  AppDelegate.m
//  InstaCar
//
//  Created by VRS on 7/13/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "AppDelegate.h"
#import "MainNavController.h"
#import "Foursquare2.h"
#import "ShareKit.h"
#import "SHKConfiguration.h"
#import "CustomSHKConfigurator.h"
#import "FSConverter.h"
#import "VenueProvider.h"

@implementation AppDelegate

@synthesize dbManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Location manager
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    // ShareKit
    DefaultSHKConfigurator *configurator = [[CustomSHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    // Database
    self.dbManager = [[DbManager alloc] init];
    
    // Foursquare
    // TODO: create the app at foursquare
    [Foursquare2 setupFoursquareWithKey:@"WU4W30WXTHPBEIMQWLGJBFFC2V3NITOGLKLNMWPXL0O5MP2N"
                 secret:@"YGMNXG45YV2RSRYRSVW2NHBFANQWB3MAGUIWNDZNUUTEUR3R"
                 callbackURL:@"app://instatest"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Slide controller
    MainNavController *mainNavController = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainNavController"];
    self.locationUpdateReceiverDelegate = mainNavController; // for the first location update and before Location view is set as a delegate
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:mainNavController];
    rootController.delegate = mainNavController;
    _menuController = rootController;
    
    self.window.rootViewController = rootController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark Location manager delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self.locationManager stopUpdatingLocation];
    CLLocation *newLocation = (CLLocation*)locations.lastObject;
    [Foursquare2 searchVenuesNearByLatitude:@(newLocation.coordinate.latitude)
                                  longitude:@(newLocation.coordinate.longitude)
                                 accuracyLL:nil
                                   altitude:nil
                                accuracyAlt:nil
                                      query:nil
                                      limit:nil
                                     intent:intentBrowse
                                     radius:@(500)
                                 categoryId:nil
                                   callback:^(BOOL success, id result){
                                       if (success) {
                                           NSDictionary *dic = result;
                                           NSArray* venues = [dic valueForKeyPath:@"response.venues"];
                                           FSConverter *converter = [[FSConverter alloc]init];
                                           [[VenueProvider getInstance] setVenues:[converter convertToObjects:venues]];
                                           [self.locationUpdateReceiverDelegate locationDidUpdate];
                                       } else {
                                           [self.locationManager startUpdatingLocation];
                                       }
                                   }
     ];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
