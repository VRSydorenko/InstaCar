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

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *logo;
@property (nonatomic) NSString *country;
@property (nonatomic) AutoModel *model;

-(id)initWithName:(NSString*)name logo:(NSString*)logo country:(NSString*)country;

@end
