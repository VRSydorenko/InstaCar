//
//  AutoModel.h
//  InstaCar
//
//  Created by VRS on 9/1/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoModel : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *logo;
@property (nonatomic) int startYear;
@property (nonatomic) int endYear;

-(id)initWithName:(NSString*)name;

@end