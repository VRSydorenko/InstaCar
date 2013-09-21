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

-(NSArray*)getAllAutos; // type: Auto
-(NSArray*)getModelsOfAuto:(int)autoId; // type: AutoModel
-(NSArray*)getSubmodelsOfModel:(int)modelId; // type: AutoSubmodel
-(UIImage*)getIconForPath:(NSString*)path;

-(void)addIcon:(UIImage*)icon forPath:(NSString*)iconPath;

@end
