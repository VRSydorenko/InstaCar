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

+(NSArray*)getAutos; // type: Auto
+(NSArray*)getSkinSets; // type: SkinSet

+(Auto*)getSelectedAuto1;
+(void)setSelectedAuto1:(Auto*)selectedAuto;

+(Auto*)getSelectedAuto2;
+(void)setSelectedAuto2:(Auto*)selectedAuto;

+(SkinSet*)getSelectedSkinSet;
+(void)setSelectedSkinSet:(SkinSet*)set;

@end