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
        self.logoName = @"";
        self.startYear = 0;
        self.endYear = 0;
    }
    return self;
}

-(UIImage*)logo128{
    if (nil == self.logoName || self.logoName.length == 0) {
        return nil;
    }
    NSString *logoFileName = [NSString stringWithFormat:@"%@_128.png", self.logoName];
    return [UIImage imageNamed:logoFileName];
}

-(UIImage*)logo256{
    if (nil == self.logoName || self.logoName.length == 0) {
        return nil;
    }
    NSString *logoFileName = [NSString stringWithFormat:@"%@_256.png", self.logoName];
    return [UIImage imageNamed:logoFileName];
}

-(NSString*)selectedTextYears{
    return [Utils getAutoYearsString:self.startYear endYear:self.endYear];
}

@end