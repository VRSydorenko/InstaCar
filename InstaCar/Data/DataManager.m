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

+(NSArray*)getModelsOfAuto:(int)autoId{
    return [[self dbManager] getModelsOfAuto:autoId];
}

+(NSArray*)getSubmodelsOfModel:(int)modelId{
    return [[self dbManager] getSubmodelsOfModel:modelId];
}

+(NSArray*)getSkinSets{
    return [SkinProvider getInstance].skinSets;
}

+(Auto*)getSelectedAuto1{
    return [SkinProvider getInstance].selectedAuto1;
}
+(void)setSelectedAuto1:(Auto*)selectedAuto{
    [SkinProvider getInstance].selectedAuto1 = selectedAuto;
}

+(Auto*)getSelectedAuto2{
    return [SkinProvider getInstance].selectedAuto2;
}
+(void)setSelectedAuto2:(Auto*)selectedAuto{
    [SkinProvider getInstance].selectedAuto2 = selectedAuto;
}

+(SkinSet*)getSelectedSkinSet{
    return [SkinProvider getInstance].selectedSkinSet;
}
+(void)setSelectedSkinSet:(SkinSet*)set{
    [SkinProvider getInstance].selectedSkinSet = set;
    [UserSettings setLastUsedSkinSet:[set getTitle]];
}

@end
