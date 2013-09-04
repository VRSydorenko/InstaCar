//
//  Auto.m
//  InstaCar
//
//  Created by VRS on 8/26/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "Auto.h"

@implementation Auto

-(id)initWithId:(int)_id name:(NSString*)name logo:(NSString*)logo country:(NSString*)country{
    self = [super init];
    if (self){
        self._id = _id;
        self.name = name;
        self.logo = logo;
        self.country = country;
        self.model = nil;
    }
    return self;
}

@end
