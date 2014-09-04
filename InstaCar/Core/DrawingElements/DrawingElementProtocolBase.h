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
    ELEM_RECT,
} ElementType;

@protocol DrawElemBaseProtocol <NSObject>
-(UIColor*)elemColor;
-(CGRect)elemRectInParent;
-(ElementType)elemType;
@end

@protocol DrawElemImageProtocol <DrawElemBaseProtocol>
-(void)setImageLogoName:(NSString*)logoName;
-(UIImage*)elemImage128;
-(UIImage*)elemImage256;
@end

@protocol DrawElemTextProtocol <DrawElemBaseProtocol>
-(UIFont*)elemFont;
-(NSString*)elemString;
-(NSTextAlignment)elemAlignment;
@end

@protocol DrawElemGradientProtocol <DrawElemBaseProtocol>
-(void) drawGradientInContext:(CGContextRef*)context inRect:(CGRect)rect;
@end

@protocol DrawElemRectProtocol <DrawElemBaseProtocol>
-(UIColor*)borderColor;
-(CGFloat)borderWidth;
@end