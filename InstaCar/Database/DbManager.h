//
//  DbHelper.h
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "Auto.h"

@interface DbManager : NSObject

-(id) init;

-(void) open;
-(void) close;

#pragma mark Custom methods

-(int)addCustomAutoModel:(NSString*)name ofAuto:(int)autoId logo:(NSString*)logoFileName startYear:(int)startYear endYear:(int)endYear;
-(int)getIdOfAutoTheModelBelongsTo:(int)modelId;
-(void)deleteCustomAutoModel:(int)modelId;
-(void)deleteCustomModelsOfAuto:(int)autoId;
-(NSArray*)getAllAutos; // type: Auto
-(NSInteger)getModelsCountForAuto:(NSUInteger)autoId;
-(NSArray*)getBuiltInModelsOfAuto:(NSUInteger)autoId; // type: AutoModel
-(NSArray*)getUserDefinedModelsOfAuto:(NSUInteger)autoId; // type: AutoModel
-(NSInteger)getSubmodelsCountOfModel:(NSUInteger)modelId;
-(NSArray*)getSubmodelsOfModel:(NSUInteger)modelId; // type: AutoSubmodel
-(UIImage*)getIconForPath:(NSString*)path;
-(int)getIdOfAutoWithIndependentId:(NSUInteger)indId;
-(int)getIndependentIdOfAutoWithDbId:(NSUInteger)dbId;

-(void)addIcon:(UIImage*)icon forPath:(NSString*)iconPath;

@end
