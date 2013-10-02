//
//  VenueProvider.m
//  InstaCar
//
//  Created by Viktor on 10/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "VenueProvider.h"

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
    }
    if (venueState){
        [venuesArray insertObject:venueState atIndex:0];
    }
    if (venueCountry){
        [venuesArray insertObject:venueCountry atIndex:0];
    }
    
    venues = [[NSArray alloc] initWithArray:venuesArray];
    _venuesInitialized = YES;
}

-(NSArray*)getAllVenues{
    return venues;
}

@end
