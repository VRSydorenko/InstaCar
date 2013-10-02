//
//  Location.h
//  InstaCar
//
//  Created by VRS on 8/29/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSVenue.h"

@interface Location : NSObject

@property (nonatomic) NSString* name;

@property (nonatomic) NSString* countryCode;
@property (nonatomic) NSString* country;
@property (nonatomic) NSString* state;
@property (nonatomic) NSString* city;

-(id)initWIthVenue:(FSVenue*)venue;

@end
