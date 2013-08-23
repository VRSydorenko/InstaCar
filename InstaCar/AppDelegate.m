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

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Foursquare2 setupFoursquareWithKey:@"WU4W30WXTHPBEIMQWLGJBFFC2V3NITOGLKLNMWPXL0O5MP2N"
                 secret:@"YGMNXG45YV2RSRYRSVW2NHBFANQWB3MAGUIWNDZNUUTEUR3R"
                 callbackURL:@"app://instatest"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    MainNavController *mainNavController = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainNavController"];
    
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:mainNavController];
    _menuController = rootController;
    
    self.window.rootViewController = rootController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;

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
