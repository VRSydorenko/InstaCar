//
//  SkinBasic_BestIn.m
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinBasic_BestIn.h"

@interface SkinBasic_BestIn()

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinBasic_BestIn

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];
    
    canEditFieldLocation = YES;
}

-(void)fieldLocationDidUpdate{
    self.labelLocation.text = fieldLocation.name;
    [self adjustWidthSizeAccordingToText];
}

-(void)adjustWidthSizeAccordingToText{
    CGSize textSize = [self.labelLocation.text sizeWithAttributes:[NSDictionary dictionaryWithObject:self.labelLocation.font forKey:NSFontAttributeName]];
    self.constraintLocWidth.constant = MIN(5.0+textSize.width, self.bounds.size.width);
    self.constraintLocBkgWidth.constant = self.constraintLocWidth.constant + 25.0 /*exclamation mark label width*/;
}

@end
