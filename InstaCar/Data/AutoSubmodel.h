//
//  AutoSubmodel.h
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoSubmodel : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *logoName;
@property (readonly, nonatomic) UIImage *logo128;
@property (readonly, nonatomic) UIImage *logo256;
@property (nonatomic) int startYear;
@property (nonatomic) int endYear;

-(id)initWithName:(NSString*)name;

@end
