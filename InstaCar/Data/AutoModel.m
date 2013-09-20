//
//  AutoModel.m
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "AutoModel.h"

@implementation AutoModel

-(id)initWithId:(int)modelId andName:(NSString*)name{
    self = [super init];
    if (self){
        self.modelId = modelId;
        self.name = name;
        self.logo = @"";
        self.startYear = 0;
        self.endYear = 0;
        self.submodel = nil;
    }
    return self;
}

@end