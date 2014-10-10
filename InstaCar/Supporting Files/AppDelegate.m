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
#import "iCloudHandler.h"

@implementation AppDelegate

@synthesize dbManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Database
    self.dbManager = [[DbManager alloc] init];
    
    // iCloud
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeDidChange:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:[NSUbiquitousKeyValueStore defaultStore]];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    
    // Location manager
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){ // iOS8 check
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    // ShareKit
    DefaultSHKConfigurator *configurator = [[CustomSHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    // Foursquare
    [Foursquare2 setupFoursquareWithKey:@"TO4MVS54WIFOEB0334JMA1GL2KUZKQCMKXL3XBPXYPS3KNVI"
                 secret:@"GOOE5TWEZG32OHZNW341W3FCIJFIIT2GVWMPDC3HXUVZCAPX"
                 callbackURL:@"app://instacar"];
    
    // Slide controller
    MainNavController *mainNavController = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainNavController"];
    self.locationUpdateReceiverDelegate = mainNavController; // for the first location update and before Location view is set as a delegate
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:mainNavController];
    rootController.delegate = mainNavController;
    _menuController = rootController;
    
    // Save initial setting from Settings bundle into UserDefaults
    [self registerDefaultsFromSettingsBundle];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = rootController;
    self.window.backgroundColor = [UIColor darkGrayColor];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark iCloud store change handler

-(void)storeDidChange:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];

    NSNumber* reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    if (!reasonForChange){
        return;
    }
    
    NSArray *changedKeys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
    if (changedKeys){
        NSMutableDictionary *changedData = [[NSMutableDictionary alloc] init];
        NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
        for (NSString *keyAutoId in changedKeys) {
            [changedData setValue:[store objectForKey:keyAutoId] forKey:keyAutoId];
        }
        [[iCloudHandler getInstance] saveFromCloudNewModels:changedData];
    }
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
                                           //[self.locationManager startUpdatingLocation];
                                       }
                                   }
     ];
}

#pragma mark -

- (void)registerDefaultsFromSettingsBundle
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];
    
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle)
    {
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:preferences.count];
    
    for (NSDictionary *prefSpecification in preferences)
    {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if (key){
            // check if value readable in userDefaults
            id currentObject = [userDefaults objectForKey:key];
            if (currentObject == nil){
                // not readable: set value from Settings.bundle
                id objectToSet = [prefSpecification objectForKey:@"DefaultValue"];
                [defaultsToRegister setObject:objectToSet forKey:key];
            } else{
                // already readable: don't touch
            }
        }
    }
    
    [userDefaults registerDefaults:defaultsToRegister];
    [userDefaults synchronize];
}

#pragma mark -
							
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
    // if user has activated using iCloud in the app settings then sync the store
    if ([DataManager getUseICloud] == YES){
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                  object:[NSUbiquitousKeyValueStore defaultStore]];
}

@end
