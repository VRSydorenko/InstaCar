//
//  SetVersus.m
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SetVersus.h"

@implementation SetVersus

#pragma mark SkinSetProtocol

-(void)loadSkins{
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"SetVersus" owner:self options:nil];
    NSMutableArray *skinsArray = [[NSMutableArray alloc] initWithCapacity:bundle.count];
    DLog(@"SetVersus Bundle objects: %lu",(unsigned long)bundle.count);
    
    // init with placeholders
    for (unsigned int i = 0; i < bundle.count; i++){
        [skinsArray addObject:[NSNull null]];
    }
    
    // init with data
    for (id object in bundle) {
        SkinViewBase *skin = nil;
        if ([object isKindOfClass:[SkinVersusName class]]){
            skin = (SkinVersusName*)object;
        } else if ([object isKindOfClass:[SkinVersusLogo class]]){
            skin = (SkinVersusLogo*)object;
        } else if ([object isKindOfClass:[SkinVersus_TwoAtFinish class]]){
            skin = (SkinVersus_TwoAtFinish*)object;
        } else if ([object isKindOfClass:[SkinVersus_DriftTime class]]){
            skin = (SkinVersus_DriftTime*)object;
        } else if ([object isKindOfClass:[SkinVersus_RaceTime class]]){
            skin = (SkinVersus_RaceTime*)object;
        } else if ([object isKindOfClass:[SkinVersus_Finish class]]){
            skin = (SkinVersus_Finish*)object;
        }
        
        NSAssert(skin, @"Undefined skin!");
        [skin baseInit];
        [skin initialise];
        [self putSkin:skin intoArray:skinsArray];
    }
    
    [self freeSkins];
    
    skins = [[NSArray alloc] initWithArray:skinsArray];
}

-(NSString*)getTitle{
    return @"Versus";
}

-(BOOL)supportsSecondCar{
    return YES;
}

@end
