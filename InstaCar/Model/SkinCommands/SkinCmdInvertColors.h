//
//  SkinCmdInvertColors.h
//  InstaCar
//
//  Created by VRS on 19/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "SkinCommandProtocol.h"

@interface SkinCmdInvertColors : NSObject <SkinCommandProtocol>

@property (nonatomic) SkinCommandDelegate *delegate;
@property (nonatomic) SkinCommandContainerDelegate *container;

@end
