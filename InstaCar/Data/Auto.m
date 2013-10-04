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

-(NSString*)selectedText{
    if (self.model){
        if (self.model.submodel){
            return [NSString stringWithFormat:@"%@ %@", self.model.isSelectable?self.model.name:self.name, self.model.submodel.name];
        } else {
            return [NSString stringWithFormat:@"%@ %@", self.name, self.model.name];
        }
    }
    return self.name;
}

@end
