//
//  Location.m
//  InstaCar
//
//  Created by VRS on 8/29/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "Location.h"

@implementation Location

-(id)initWIthVenue:(FSVenue*)venue{
    self = [super init];
    if (self){
        self.name = venue.name;
        
        self.countryCode = venue.location.countryCode;
        self.country = venue.location.country;
        self.state = venue.location.state;
        self.city = venue.location.city;
    }
    return self;
}

-(NSString*)getLocationString{
    NSString *first = @"";
    NSString *separator = @"";
    NSString *second = @"";
    
    if (self.country){
        second = self.country;
    }
    
    if (self.city){
        first = self.city;
    } else if (self.state && second){
        first = self.state;
    } else { // if there is no city & no state then what's the reason to show the country...
        second = @"";
    }
    
    if (first.length > 0 && second.length > 0){
        separator = @", ";
    }
    
    return [NSString stringWithFormat:@"%@%@%@", first, separator, second];
}

@end
