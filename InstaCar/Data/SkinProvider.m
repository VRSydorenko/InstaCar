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
        [self initLastUsedSkin];
    }
    return self;
}

-(void)initSkins{
    NSMutableArray *sets = [[NSMutableArray alloc] init];
    
    SetDefault *skinDefault = [[SetDefault alloc] init];
    [sets addObject:skinDefault];
    self.selectedSkinSet = skinDefault; // setting default skin set
    self.selectedAuto1 = nil;
    self.selectedAuto2 = nil;
    self.selectedVenue = nil;
    
    _skinSets = [[NSArray alloc] initWithArray:sets];
}
         
-(void)initLastUsedSkin{
    NSString *lastUsedSet = [UserSettings getLastUsedSkinSet];
    if (!lastUsedSet){
        return;
    }
    
    for (SkinSet *set in self.skinSets) {
        if ([[set getTitle] isEqualToString:lastUsedSet]){
            self.selectedSkinSet = set;
        }
    }
}

@end
