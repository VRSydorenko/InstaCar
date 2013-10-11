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

-(void)addCustomAutoModel:(NSString*)name ofAuto:(int)autoId logo:(NSString*)logoFileName startYear:(int)startYear endYear:(int)endYear;
-(NSArray*)getAllAutos; // type: Auto
-(NSInteger)getModelsCountForAuto:(int)autoId;
-(NSArray*)getBuiltInModelsOfAuto:(int)autoId; // type: AutoModel
-(NSArray*)getUserDefinedModelsOfAuto:(int)autoId; // type: AutoModel
-(NSInteger)getSubmodelsCountOfModel:(int)modelId;
-(NSArray*)getSubmodelsOfModel:(int)modelId; // type: AutoSubmodel
-(UIImage*)getIconForPath:(NSString*)path;

-(void)addIcon:(UIImage*)icon forPath:(NSString*)iconPath;

@end
