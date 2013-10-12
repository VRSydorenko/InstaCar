//
//  iCloudHandler.h
//  InstaCar
//
//  Created by VRS on 10/12/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "AutoModel.h"

@protocol iCloudHandlerDelegate <NSObject>
-(void)modelsChangedForAutos:(NSArray*)autoIds; // type: NSUInteger
@end

@interface iCloudHandler : NSObject

+(iCloudHandler*)getInstance;

@property id<iCloudHandlerDelegate> delegate;
-(void)putToCloudModelsDataOfAuto:(NSUInteger)autoId;
-(void)saveFromCloudNewModels:(NSDictionary*)models; // key: NSNumber as auto independent id; NSString as one or more models

@end
