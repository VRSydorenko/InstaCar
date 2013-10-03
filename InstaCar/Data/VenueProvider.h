//
//  VenueProvider.h
//  InstaCar
//
//  Created by Viktor on 10/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSVenue.h"

@interface VenueProvider : NSObject{
    NSArray *venues;
}

+(VenueProvider*) getInstance;

@property (readonly) BOOL venuesInitialized;

@property (readonly) NSString* city;
@property (readonly) NSString* state;
@property (readonly) NSString* country;
@property (readonly) NSString* countryCode;

-(void)setVenues:(NSArray*)data;
-(NSArray*)getAllVenues;

@end
