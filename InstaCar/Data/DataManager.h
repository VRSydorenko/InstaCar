//
//  DataManager.h
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbManager.h"
#import "SkinProvider.h"

@interface DataManager : NSObject

+(BOOL)isFullVersion;

+(void)addCustomAutoModel:(NSString*)name ofAuto:(int)autoId logo:(NSString*)logoFileName startYear:(int)startYear endYear:(int)endYear;
+(NSArray*)getAutos; // type: Auto
+(NSInteger)getModelsCountForAuto:(int)autoId;
+(NSArray*)getBuiltInModelsOfAuto:(int)autoId; // type: AutoModel
+(NSArray*)getUserDefinedModelsOfAuto:(int)autoId; // type: AutoModel
+(NSArray*)getSubmodelsOfModel:(int)modelId; // type: AutoSubModel
+(NSArray*)getSkinSets; // type: SkinSet
+(UIImage*)getIconForPath:(NSString*)path;
+(void)addIcon:(UIImage*)icon forPath:(NSString*)path;

+(Auto*)getSelectedAuto1;
+(void)setSelectedAuto1:(Auto*)selectedAuto;

+(Auto*)getSelectedAuto2;
+(void)setSelectedAuto2:(Auto*)selectedAuto;

+(SkinSet*)getSelectedSkinSet;
+(void)setSelectedSkinSet:(SkinSet*)set;

+(FSVenue*)getSelectedVenue;
+(void)setSelectedVenue:(FSVenue*)venue;

@end
