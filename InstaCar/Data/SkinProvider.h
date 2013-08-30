//
//  SkinProvider.h
//  InstaCar
//
//  Created by VRS on 8/26/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SetDefault.h"

@interface SkinProvider : NSObject

+(SkinProvider*)getInstance;

@property (readonly) NSArray *skinSets;

@end
