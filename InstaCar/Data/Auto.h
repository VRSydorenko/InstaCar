//
//  Auto.h
//  InstaCar
//
//  Created by VRS on 8/26/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Auto : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSArray *models; // type: AutoModel
@property (nonatomic) UIImage *emblem;

@end
