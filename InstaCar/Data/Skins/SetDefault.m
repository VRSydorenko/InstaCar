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
    NSMutableArray *skinsArray = [[NSMutableArray alloc] init];
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"SetDefault" owner:self options:nil];
    
    for (id object in bundle) {
        if ([object isKindOfClass:[SkinSimple class]]){
            SkinSimple *skinSimple = (SkinSimple*)object;
            [skinSimple initialise];
            [skinsArray addObject:skinSimple];
            continue;
        }
        if ([object isKindOfClass:[SkinSimple2 class]]){
            SkinSimple2 *skinSimple = (SkinSimple2*)object;
            [skinSimple initialise];
            [skinsArray addObject:skinSimple];
            continue;
        }
    }
    
    [self freeSkins];
    
    skins = [[NSArray alloc] initWithArray:skinsArray];
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

-(void)updateData:(id)data ofType:(SelectedDataChange)type{
    // TODO: go through all skins and update possible values
    switch (type) {
        case AUTO1:
            for (SkinViewBase *skinView in skins) {
                [skinView updateField:fAUTO1 withValue:data];
            }
            break;
        case AUTO2:
            for (SkinViewBase *skinView in skins) {
                [skinView updateField:fAUTO2 withValue:data];
            }
            break;
        case LOCATION:
            for (SkinViewBase *skinView in skins) {
                [skinView updateField:fLOCATION withValue:data];
            }
            break;
        default:
            break;
    }
}

-(BOOL)supportsSecondCar{
    return NO;
}

@end
