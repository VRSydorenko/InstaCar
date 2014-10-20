//
//  SkinCommandProvider.h
//  InstaCar
//
//  Created by VRS on 18/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkinCommandProtocol.h"

@interface SkinCommandProvider : NSObject{
    NSDictionary *skinCommands;
}

+(SkinCommandProvider*)getInstance;

-(SkinCommand*)getCommand:(NSNumber*)cmdId;

@end
