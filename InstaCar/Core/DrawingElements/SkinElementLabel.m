//
//  SkinElementLabel.m
//  InstaCar
//
//  Created by VRS on 23/06/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinElementLabel.h"

@implementation SkinElementLabel

// base

-(UIColor*)elemColor{
    return self.textColor;
}

-(CGRect)elemRectInParent{
    return self.frame;
}

-(ElementType)elemType;
{
    return ELEM_TEXT;
}

// label

-(UIFont*)elemFont{
    return self.font;
}

-(NSString*)elemString{
    return self.text;
}

-(NSTextAlignment)elemAlignment{
    return self.textAlignment;
}

-(UIColor*)elemShadowColor{
    return self.shadowColor;
}

-(CGSize)elemShadowOffset{
    return self.shadowOffset;
}

-(void)invertColors{
    self.textColor = [Utils invertColor:self.textColor];
    self.shadowColor = [Utils invertColor:self.shadowColor];
}

@end
