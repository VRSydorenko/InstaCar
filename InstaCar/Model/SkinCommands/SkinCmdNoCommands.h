//
//  SkinCmdNoCommands.h
//  InstaCar
//
//  Created by VRS on 20/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkinCommandProtocol.h"

@interface SkinCmdNoCommands : NSObject <SkinCommandProtocol>

@property (nonatomic) SkinCommandDelegate *delegate;
@property (nonatomic) SkinCommandContainerDelegate *container;

@end
