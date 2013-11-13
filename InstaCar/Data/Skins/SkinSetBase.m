//
//  SkinSetBase.m
//  InstaCar
//
//  Created by VRS on 13/11/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinSetBase.h"

@implementation SkinSetBase

-(id)init{
    self = [super init];
    if (self){
        skins = nil;
    }
    return self;
}

#pragma mark SkinSetProtocol

-(NSString*)getTitle{
    // overriden in descendants
    return @"";
}

-(unsigned short)getSkinsCount{
    if (!skins){
        [self loadSkins];
    }
    
    return skins.count;
}

-(void)loadSkins{
    // overriden in descendants
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
    // overriden in descendants
    return NO;
}

#pragma mark Internal methods

-(void)putSkin:(SkinViewBase*)skin intoArray:(NSMutableArray*)array{
    NSAssert(array.count > skin.tag, @"Skin index in higher than configured skins count");
    NSAssert([array objectAtIndex:skin.tag] == [NSNull null], @"Attempt to replace already configured skin");
    
    [array replaceObjectAtIndex:skin.tag withObject:skin];
}


@end
