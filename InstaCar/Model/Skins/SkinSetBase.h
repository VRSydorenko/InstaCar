//
//  SkinSetBase.h
//  InstaCar
//
//  Created by VRS on 13/11/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkinViewBase.h"

@protocol SkinSetProtocol <NSObject>
-(NSString*)getTitle;
-(unsigned short)getSkinsCount;
-(SkinViewBase*)getSkinAtIndex:(unsigned short)index;
-(void)loadSkins;
-(void)freeSkins;
-(void)updateData:(id)data ofType:(SelectedDataChange)type;
-(BOOL)supportsSecondCar;
@end

@interface SkinSetBase : NSObject <SkinSetProtocol> {
@protected
    NSArray *skins;
}

-(void)putSkin:(SkinViewBase*)skin intoArray:(NSMutableArray*)array;

@end
