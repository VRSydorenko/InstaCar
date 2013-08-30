//
//  SkinProvider.m
//  InstaCar
//
//  Created by VRS on 8/26/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinProvider.h"

@implementation SkinProvider

+(SkinProvider*)getInstance
{
    static SkinProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SkinProvider alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    self = [super init];
    if (self){
        [self initSkins];
    }
    return self;
}

-(void)initSkins{
    NSMutableArray *sets = [[NSMutableArray alloc] init];
    
    SetDefault *skinDefault = [[SetDefault alloc] init];
    [sets addObject:skinDefault];
    
    _skinSets = [[NSArray alloc] initWithArray:sets];
}

@end
