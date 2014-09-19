//
//  AutoModel.h
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AutoSubmodel.h"

@interface AutoModel : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *logoName;
@property (readonly, nonatomic) UIImage *logo128;
@property (readonly, nonatomic) UIImage *logo256;
@property (nonatomic) int startYear;
@property (nonatomic) int endYear;
@property (nonatomic) int modelId;
@property (nonatomic) AutoSubmodel *submodel;
@property (nonatomic) BOOL isSelectable;
@property (nonatomic) BOOL isUserDefined;

@property (nonatomic, readonly) NSString* selectedTextYears;

-(id)initWithId:(int)modelId andName:(NSString*)name;

@end
