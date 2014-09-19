//
//  Auto.h
//  InstaCar
//
//  Created by VRS on 8/26/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AutoModel.h"

@interface Auto : NSObject

@property (readonly, nonatomic) int _id;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *logoName;
@property (readonly, nonatomic) UIImage *logo128;
@property (readonly, nonatomic) UIImage *logo256;
@property (readonly, nonatomic) BOOL logoAsName;
@property (readonly, nonatomic) NSString *country;
@property (nonatomic) AutoModel *model;

// strings
@property (readonly, nonatomic) NSString* selectedTextShort;
@property (readonly, nonatomic) NSString* selectedTextFull;
@property (readonly, nonatomic) NSString* selectedTextMarkModel;
@property (readonly, nonatomic) NSString* selectedTextModel;
@property (readonly, nonatomic) NSString* selectedTextSubmodel;
@property (readonly, nonatomic) NSString* selectedTextModelSubmodel;
@property (readonly, nonatomic) NSString* selectedTextYears;

@property (readonly, nonatomic) CGFloat logoWidthHeightRate;

-(id)initWithId:(int)_id name:(NSString*)name logo:(NSString*)logo logoAsName:(BOOL)logoAsName country:(NSString*)country;

@end