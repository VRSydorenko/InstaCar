//
//  SetEmotions.m
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SetEmotions.h"

@implementation SetEmotions

#pragma mark SkinSetProtocol

-(void)loadSkins{
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"SetEmotions" owner:self options:nil];
    NSMutableArray *skinsArray = [[NSMutableArray alloc] initWithCapacity:bundle.count];
    DLog(@"SetVersus Bundle objects: %lu",(unsigned long)bundle.count);
    
    // init with placeholders
    for (unsigned int i = 0; i < bundle.count; i++){
        [skinsArray addObject:[NSNull null]];
    }
    
    // init with data
    for (id object in bundle) {
        SkinViewBase *skin = nil;
        if ([object isKindOfClass:[SkinEmo_IHeartLogo class]]){
            skin = (SkinEmo_IHeartLogo*)object;
        } else if ([object isKindOfClass:[SkinEmo_IHeartName class]]){
            skin = (SkinEmo_IHeartName*)object;
        } else if ([object isKindOfClass:[SkinEmo_MyDream class]]){
            skin = (SkinEmo_MyDream*)object;
        } else if ([object isKindOfClass:[SkinEmo_BestPresent class]]){
            skin = (SkinEmo_BestPresent*)object;
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
    return @"Emotions";
}

@end
