//
//  DrawingElementProtocolBase.h
//  InstaCar
//
//  Created by VRS on 20/06/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ELEM_BASE,
    ELEM_IMAGE,
    ELEM_TEXT,
    ELEM_GRADIENT,
} ElementType;

@protocol DrawElemBaseProtocol <NSObject>
-(UIColor*)elemColor;
-(CGRect)elemRectInParent;
-(ElementType)elemType;
@end

@protocol DrawElemImageProtocol <DrawElemBaseProtocol>
-(UIImage*)elemImage;
@end

@protocol DrawElemTextProtocol <DrawElemBaseProtocol>
-(UIFont*)elemFont;
-(NSString*)elemString;
@end

@protocol DrawElemGradientProtocol <DrawElemBaseProtocol>
-(int)elemGradDirection;
@end