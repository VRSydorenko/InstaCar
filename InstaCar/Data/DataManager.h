//
//  DataManager.h
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbManager.h"

@interface DataManager : NSObject

+(NSArray*)getAutos; // type: Auto
+(NSArray*)getSkinSets; // type: SkinSet

@end
