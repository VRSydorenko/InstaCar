//
//  SetAwards.m
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SetAwards.h"

@implementation SetAwards

#pragma mark SkinSetProtocol

-(void)loadSkins{
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"SetAwards" owner:self options:nil];
    NSMutableArray *skinsArray = [[NSMutableArray alloc] initWithCapacity:bundle.count];
    DLog(@"SetVersus Bundle objects: %lu",(unsigned long)bundle.count);
    
    // init with placeholders
    for (unsigned int i = 0; i < bundle.count; i++){
        [skinsArray addObject:[NSNull null]];
    }
    
    // init with data
    for (id object in bundle) {
        SkinViewBase *skin = nil;
        if ([object isKindOfClass:[SkinAwd_BestChoise class]]){
            skin = (SkinAwd_BestChoise*)object;
        } else if ([object isKindOfClass:[SkinAwd_BestChoise2 class]]){
            skin = (SkinAwd_BestChoise2*)object;
        } else if ([object isKindOfClass:[SkinAwd_BestChoise3 class]]){
            skin = (SkinAwd_BestChoise3*)object;
        } else if ([object isKindOfClass:[SkinAwd_BestLuxury class]]){
            skin = (SkinAwd_BestLuxury*)object;
        } else if ([object isKindOfClass:[SkinAwd_Raiting class]]){
            skin = (SkinAwd_Raiting*)object;
        } else if ([object isKindOfClass:[SkinAwd_Eco class]]){
            skin = (SkinAwd_Eco*)object;
        } else if ([object isKindOfClass:[SkinAwd_Medal1st class]]){
            skin = (SkinAwd_Medal1st*)object;
        } else if ([object isKindOfClass:[SkinAwd_Medal2nd class]]){
            skin = (SkinAwd_Medal2nd*)object;
        } else if ([object isKindOfClass:[SkinAwd_Ribbon class]]){
            skin = (SkinAwd_Ribbon*)object;
        } else if ([object isKindOfClass:[SkinAwd_Placeholder2 class]]){
            skin = (SkinAwd_Placeholder2*)object;
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
    return @"Awards";
}

@end
