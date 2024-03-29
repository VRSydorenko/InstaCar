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

+(BOOL)isFullVersion{
    return [UserSettings isFullVersion];
}

+(DbManager*)dbManager{
    return ((AppDelegate*)[UIApplication sharedApplication].delegate).dbManager;
}

+(BOOL)addCustomAutoModel:(NSString*)name ofAuto:(int)autoId logo:(NSString*)logoFileName startYear:(int)startYear endYear:(int)endYear{
    BOOL modelAcceptedAsNew = [[self dbManager] addCustomAutoModel:name ofAuto:autoId logo:logoFileName startYear:startYear endYear:endYear];
    if (modelAcceptedAsNew){ // if it is a new model then add it to iCloud
        [[iCloudHandler getInstance] updateInCloudModelsDataOfAuto:autoId];
    }
    return modelAcceptedAsNew;
}

+(void)deleteCustomModel:(int)modelId{
    int autoId = [[self dbManager] getIdOfAutoTheModelBelongsTo:modelId];
    if (-1 != autoId){
        [[self dbManager] deleteCustomAutoModel:modelId];
        [[iCloudHandler getInstance] updateInCloudModelsDataOfAuto:autoId];
    }
}

+(void)deleteCustomModelsOfAuto:(int)autoId{
    [[self dbManager] deleteCustomModelsOfAuto:autoId];
}

+(NSArray*)getAutos{
    return [[self dbManager] getAllAutos];
}

+(NSInteger)getModelsCountForAuto:(NSUInteger)autoId{
    return [[self dbManager] getModelsCountForAuto:autoId];
}

+(NSArray*)getBuiltInModelsOfAuto:(NSUInteger)autoId{
    return [[self dbManager] getBuiltInModelsOfAuto:autoId];
}

+(NSArray*)getUserDefinedModelsOfAuto:(NSUInteger)autoId{
    return [[self dbManager] getUserDefinedModelsOfAuto:autoId];
}

+(NSInteger)getSubmodelsCountOfModel:(NSUInteger)modelId{
    return [[self dbManager] getSubmodelsCountOfModel:(int)modelId];
}

+(NSArray*)getSubmodelsOfModel:(NSUInteger)modelId{
    return [[self dbManager] getSubmodelsOfModel:modelId];
}

+(NSArray*)getSkinSets{
    return [SkinProvider getInstance].skinSets;
}

+(UIImage*)getIconForPath:(NSString*)path{
    return [[self dbManager] getIconForPath:path];
}
+(void)addIcons:(NSDictionary*)icons{
    [[self dbManager] addIcons:icons];
}

+(int)getIdOfAutoWithIndependentId:(NSUInteger)intId{
    return [[self dbManager] getIdOfAutoWithIndependentId:intId];
}
+(int)getIndependentIdOfAutoWithDbId:(NSUInteger)dbId{
    return [[self dbManager] getIndependentIdOfAutoWithDbId:dbId];
}

+(BOOL)getHasLaunchedBefore{
    return [UserSettings getHasLaunchedBefore];
}
+(void)setHasLaunchedBefore{
    [UserSettings setHasLaunchedBefore];
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
    [[SkinProvider getInstance].selectedSkinSet freeSkins];
    [SkinProvider getInstance].selectedSkinSet = nil;
    [SkinProvider getInstance].selectedSkinSet = set;
    [UserSettings setLastUsedSkinSet:[set getTitle]];
}

+(FSVenue*)getSelectedVenue{
    return [SkinProvider getInstance].selectedVenue;
}
+(void)setSelectedVenue:(FSVenue*)venue{
    [SkinProvider getInstance].selectedVenue = venue;
}

+(BOOL)getLogoOverlayEnabled{
    return [UserSettings getLogoOverlayEnabled];
}

+(BOOL)getUseICloud{
    return [UserSettings getUseICloud];
}

+(BOOL)getSaveWhenSharing{
    return [UserSettings getSaveWhenSharing];
}

@end
