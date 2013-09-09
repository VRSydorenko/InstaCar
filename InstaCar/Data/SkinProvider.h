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
#import "FSVenue.h"

typedef NSObject<SkinSetProtocol> SkinSet;

@interface SkinProvider : NSObject

+(SkinProvider*)getInstance;

@property (readonly) NSArray *skinSets;
@property SkinSet *selectedSkinSet;
@property Auto *selectedAuto1;
@property Auto *selectedAuto2;
@property FSVenue *selectedVenue;

@end
