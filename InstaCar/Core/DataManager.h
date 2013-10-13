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
#import "iCloudHandler.h"

@interface DataManager : NSObject

+(BOOL)isFullVersion;

+(BOOL)addCustomAutoModel:(NSString*)name ofAuto:(int)autoId logo:(NSString*)logoFileName startYear:(int)startYear endYear:(int)endYear;
+(NSArray*)getAutos; // type: Auto
+(NSInteger)getModelsCountForAuto:(NSUInteger)autoId;
+(NSArray*)getBuiltInModelsOfAuto:(NSUInteger)autoId; // type: AutoModel
+(NSArray*)getUserDefinedModelsOfAuto:(NSUInteger)autoId; // type: AutoModel
+(NSInteger)getSubmodelsCountOfModel:(NSUInteger)modelId;
+(NSArray*)getSubmodelsOfModel:(NSUInteger)modelId; // type: AutoSubModel
+(NSArray*)getSkinSets; // type: SkinSet
+(UIImage*)getIconForPath:(NSString*)path;
+(void)addIcon:(UIImage*)icon forPath:(NSString*)path;
+(int)getIdOfAutoWithIndependentId:(NSUInteger)intId;
+(int)getIndependentIdOfAutoWithDbId:(NSUInteger)dbId;

+(BOOL)getLogoOverlayDisabled;
+(void)setLogoOverlayDisabled:(BOOL)disabled;

+(Auto*)getSelectedAuto1;
+(void)setSelectedAuto1:(Auto*)selectedAuto;

+(Auto*)getSelectedAuto2;
+(void)setSelectedAuto2:(Auto*)selectedAuto;

+(SkinSet*)getSelectedSkinSet;
+(void)setSelectedSkinSet:(SkinSet*)set;

+(FSVenue*)getSelectedVenue;
+(void)setSelectedVenue:(FSVenue*)venue;

@end
