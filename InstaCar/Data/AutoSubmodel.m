//
//  AutoSubmodel.m
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "AutoSubmodel.h"

@implementation AutoSubmodel

-(id)initWithName:(NSString*)name{
    self = [super init];
    if (self){
        self.name = name;
        self.logo = @"";
        self.startYear = 0;
        self.endYear = 0;
    }
    return self;
}

@end