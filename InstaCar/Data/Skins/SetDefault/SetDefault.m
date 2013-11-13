//
//  SkinDefault.m
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SetDefault.h"

@implementation SetDefault

#pragma mark SkinSetProtocol overrides

-(void)loadSkins{
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"SetDefault" owner:self options:nil];
    NSMutableArray *skinsArray = [[NSMutableArray alloc] initWithCapacity:bundle.count];
    DLog(@"SetBasic Bundle objects: %lu",(unsigned long)bundle.count);
    
    // init with placeholders
    for (int i = 0; i < bundle.count; i++){
        [skinsArray addObject:[NSNull null]];
    }
    
    // init with data
    for (id object in bundle) {
        SkinViewBase *skin = nil;
        if ([object isKindOfClass:[SkinSimple class]]){
            skin = (SkinSimple*)object;
        } else if ([object isKindOfClass:[SkinSimple2 class]]){
            skin = (SkinSimple2*)object;
        } else if ([object isKindOfClass:[LogoRight class]]){
            skin = (LogoRight*)object;
        } else if ([object isKindOfClass:[LogoNameLeft class]]){
            skin = (LogoNameLeft*)object;
        } else if ([object isKindOfClass:[LocationSimple class]]){
            skin = (LocationSimple*)object;
        } else if ([object isKindOfClass:[SkinLogoCountryBadge class]]){
            skin = (SkinLogoCountryBadge*)object;
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
    return @"Basic";
}

@end
