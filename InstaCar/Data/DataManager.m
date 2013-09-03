//
//  DataManager.m
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "AppDelegate.h"
#import "DataManager.h"

@implementation DataManager

+(DbManager*)dbManager{
    return ((AppDelegate*)[UIApplication sharedApplication].delegate).dbManager;
}

+(NSArray*)getAutos{
    return [[self dbManager] getAllAutos];
}

+(NSArray*)getSkinSets{
    return [SkinProvider getInstance].skinSets;
}

+(Auto*)getSelectedAuto{
    return [SkinProvider getInstance].selectedAuto;
}
+(void)setSelectedAuto:(Auto*)selectedAuto{
    [SkinProvider getInstance].selectedAuto = selectedAuto;
}

+(SkinSet*)getSelectedSkinSet{
    return [SkinProvider getInstance].selectedSkinSet;
}
+(void)setSelectedSkinSet:(SkinSet*)set{
    [SkinProvider getInstance].selectedSkinSet = set;
    [UserSettings setLastUsedSkinSet:[set getTitle]];
}

@end
