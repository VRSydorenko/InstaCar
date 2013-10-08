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

@end
