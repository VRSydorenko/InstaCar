//
//  SkinProvider.h
//  InstaCar
//
//  Created by VRS on 8/26/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserSettings.h"
#import "SetDefault.h"
#import "SetVersus.h"
#import "FSVenue.h"

typedef NSObject<SkinSetProtocol> SkinSet;

@interface SkinProvider : NSObject

+(SkinProvider*)getInstance;

@property (nonatomic, readonly) NSArray *skinSets;
@property (nonatomic) SkinSet *selectedSkinSet;
@property (nonatomic) Auto *selectedAuto1;
@property (nonatomic) Auto *selectedAuto2;
@property (nonatomic) FSVenue *selectedVenue;

@end
