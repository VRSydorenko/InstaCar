//
//  SkinDefault.m
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SetDefault.h"

@interface SetDefault(){
    NSArray *skins;
}
@end

@implementation SetDefault

-(id)init{
    self = [super init];
    if (self){
        skins = nil;
    }
    return self;
}

-(void)loadSkins{
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"SetDefault" owner:self options:nil];
    
    SkinSimple *skinSimple;
    for (id object in bundle) {
        if ([object isKindOfClass:[SkinSimple class]]){
            skinSimple = (SkinSimple*)object;
            continue;
        }
    }
}

#pragma mark SkinSetProtocol

-(NSString*)getTitle{
    return @"Default";
}

-(unsigned short)getSkinsCount{
    if (!skins){
        [self loadSkins];
    }
    
    return skins.count;
}

-(SkinViewBase*)getSkinAtIndex:(unsigned short)index{
    if (!skins){
        [self loadSkins];
    }
    
    if (index >= skins.count){
        return skins.lastObject;
    }
    
    return [skins objectAtIndex:index];
}

-(void)freeSkins{
    skins = nil;
}

@end
