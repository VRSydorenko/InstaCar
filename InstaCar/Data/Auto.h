//
//  Auto.h
//  InstaCar
//
//  Created by VRS on 8/26/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AutoModel.h"
#import "AutoSubmodel.h"

@interface Auto : NSObject

@property (readonly, nonatomic) int _id;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *logo;
@property (readonly, nonatomic) BOOL logoAsName;
@property (readonly, nonatomic) NSString *country;
@property (nonatomic) AutoModel *model;
@property (readonly, nonatomic) NSString* selectedText;
@property (readonly, nonatomic) CGFloat logoWidthHeightRate;

-(id)initWithId:(int)_id name:(NSString*)name logo:(NSString*)logo logoAsName:(BOOL)logoAsName country:(NSString*)country;

@end
