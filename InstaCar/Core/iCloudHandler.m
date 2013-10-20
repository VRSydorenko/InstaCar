//
//  iCloudHandler.m
//  InstaCar
//
//  Created by VRS on 10/12/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "iCloudHandler.h"

// don't change these constants
#define MODEL_SEPARATOR @"modelSprtr"
#define MODEL_PARTS_SEPARATOR @"dataSprtr"

@implementation iCloudHandler

+(iCloudHandler*)getInstance
{
    static iCloudHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[iCloudHandler alloc] init];
    });
    return sharedInstance;
}

-(void)updateInCloudModelsDataOfAuto:(NSUInteger)autoId{
    if ([DataManager getUseICloud] == NO){
        return;
    }
    
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    
    NSArray *models = [DataManager getUserDefinedModelsOfAuto:autoId];
    NSMutableString *modelsString = [[NSMutableString alloc] init];
    
    if (models.count > 0){
        for (AutoModel *model in models) {
            if (modelsString.length > 0){
                [modelsString appendString:MODEL_SEPARATOR];
            }
            [modelsString appendFormat:@"%@%@", model.name, MODEL_PARTS_SEPARATOR];
            [modelsString appendFormat:@"%@%@", model.logo, MODEL_PARTS_SEPARATOR];
            [modelsString appendFormat:@"%d%@", model.startYear, MODEL_PARTS_SEPARATOR];
            [modelsString appendFormat:@"%d", model.endYear];
        }
    }
    
    NSString *independentAutoIdKey = [NSString stringWithFormat:@"%d", [DataManager getIndependentIdOfAutoWithDbId:autoId]];
    
    if (modelsString.length > 0){
        [store setString:modelsString forKey:independentAutoIdKey];
        [store synchronize];
    } else {
        [store removeObjectForKey:independentAutoIdKey];
    }
}

// key: number as NSString; value: NSString to parse
// string format: modelName:logoFilename:startYear:endYear
-(void)saveFromCloudNewModels:(NSDictionary*)data{
    if ([DataManager isFullVersion] == NO){
        return;
    }
    if ([DataManager getUseICloud] == NO){
        return;
    }
    
    NSMutableArray *updatedAutoIds = [[NSMutableArray alloc] init];
    
    for (NSString *autoIndId in data) {
        NSArray *models = [[data objectForKey:autoIndId] componentsSeparatedByString:MODEL_SEPARATOR];
        int autoDbId = [DataManager getIdOfAutoWithIndependentId:autoIndId.intValue];
        [DataManager deleteCustomModelsOfAuto:autoDbId];
        
        for (NSString *modelToParse in models) {
            if (modelToParse.length == 0){
                continue;
            }
            
            NSArray *modelParts = [modelToParse componentsSeparatedByString:MODEL_PARTS_SEPARATOR];
            
            NSString *name = [modelParts objectAtIndex:0];
            NSString *logo = [modelParts objectAtIndex:1];
            int startYear = ((NSString*)[modelParts objectAtIndex:2]).intValue;
            int endYear = ((NSString*)[modelParts objectAtIndex:3]).intValue;
            
            BOOL modelAcceptedAsNew = [DataManager addCustomAutoModel:name ofAuto:autoDbId logo:logo startYear:startYear endYear:endYear];
            
            if (modelAcceptedAsNew){
                [updatedAutoIds addObject:[NSNumber numberWithInt:autoDbId]];
            }
        }
    }
    
    if (updatedAutoIds.count > 0 && self.delegate){
        [self.delegate modelsChangedForAutos:updatedAutoIds];
    }
}

@end
