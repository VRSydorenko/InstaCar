//
//  SkinElementLabel.h
//  InstaCar
//
//  Created by VRS on 23/06/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingElementProtocolBase.h"

@interface SkinElementLabel : UILabel <DrawElemTextProtocol>

-(void)invertColors;

@end
