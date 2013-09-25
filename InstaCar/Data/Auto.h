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

@property (nonatomic) int _id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *logo;
@property (nonatomic) NSString *country;
@property (nonatomic) AutoModel *model;
@property (readonly) NSString* selectedText;

-(id)initWithId:(int)_id name:(NSString*)name logo:(NSString*)logo country:(NSString*)country;

@end
