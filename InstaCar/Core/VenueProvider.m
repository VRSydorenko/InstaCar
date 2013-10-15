//
//  VenueProvider.m
//  InstaCar
//
//  Created by Viktor on 10/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "VenueProvider.h"
#import "DataManager.h"

@implementation VenueProvider

+(VenueProvider*)getInstance
{
    static VenueProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[VenueProvider alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    self = [super init];
    if (self){
        _venuesInitialized = NO;
    }
    return self;
}

-(void)setVenues:(NSArray*)data{
    if (venues){
        venues = nil;
    }
    
    FSGlobalVenue *venueCountry = nil;
    FSGlobalVenue *venueState = nil;
    FSGlobalVenue *venueCity = nil;
    
    for (FSVenue *v in data){
        if (!venueCountry && v.location.country.length > 0){
            venueCountry = [[FSGlobalVenue alloc] init];
            venueCountry.name = v.location.country;
            venueCountry.location.country = v.location.country;
            venueCountry.location.countryCode = v.location.countryCode;
        }
        if (!venueState && v.location.state.length > 0){
            venueState = [[FSGlobalVenue alloc] init];
            venueState.name = v.location.state;
            
            venueState.location.country = v.location.country;
            venueState.location.countryCode = v.location.countryCode;
            venueState.location.state = v.location.state;
        }
        if (!venueCity && v.location.city.length > 0){
            venueCity = [[FSGlobalVenue alloc] init];
            venueCity.name = v.location.city;
            
            venueCity.location.country = v.location.country;
            venueCity.location.countryCode = v.location.countryCode;
            venueCity.location.state = v.location.state;
            venueCity.location.city = v.location.city;
        }
        
        if (venueCountry && venueState && venueCity){
            break;
        }
    }
    
    NSMutableArray *venuesArray = [[NSMutableArray alloc] initWithArray:data];
    if (venueCity){
        [venuesArray insertObject:venueCity atIndex:0];
        _city = venueCity.name;
        
        // if no venue selected then let a city be this
        if (![DataManager getSelectedVenue]){
            [DataManager setSelectedVenue:venueCity];
        }
    }
    if (venueState){
        [venuesArray insertObject:venueState atIndex:0];
        _state = venueState.name;
    }
    if (venueCountry){
        [venuesArray insertObject:venueCountry atIndex:0];
        _country = venueCountry.name;
        _countryCode = venueCountry.location.countryCode;
    }
    
    venues = [[NSArray alloc] initWithArray:venuesArray];
    _venuesInitialized = YES;
    
    // Next: async load icons to the app db for the future fast access
    
    // prepare list of paths to load
    NSMutableArray *iconPathsToLoad = [[NSMutableArray alloc] init];
    for (FSVenue *v in venues) {
        UIImage *icon = [DataManager getIconForPath:v.iconURL];
        if (!icon && v.iconURL){
            [iconPathsToLoad addObject:v.iconURL];
        }
    }
    if (iconPathsToLoad.count > 0){
        // load missing icons
        dispatch_queue_t refreshQueue = dispatch_queue_create("foursquare icons queue", NULL);
        dispatch_async(refreshQueue, ^{
            @try {
                NSMutableDictionary *iconsToSave = [[NSMutableDictionary alloc] init];
                for (NSString *path in iconPathsToLoad) {
                    NSURL *url = [NSURL URLWithString:path];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *icon = [UIImage imageWithData:data];
                    [iconsToSave setObject:icon forKey:path];
                }
                if (iconsToSave.count > 0){
                    // save icons on the main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        for (NSString *keyPath in iconsToSave.allKeys) {
                            [DataManager addIcon:[iconsToSave objectForKey:keyPath] forPath:keyPath];
                        }
                    });
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }
}

-(NSArray*)getAllVenues{
    return venues;
}

@end
