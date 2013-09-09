//
//  CellVenue.m
//  InstaCar
//
//  Created by VRS on 9/8/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "CellVenue.h"

@implementation CellVenue

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    self.textVenueName.textColor = selected ? [UIColor blueColor] : [UIColor lightGrayColor];
}

@end
