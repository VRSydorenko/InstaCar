//
//  LocationSimple.m
//  InstaCar
//
//  Created by Viktor on 10/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "LocationSimple.h"

@interface LocationSimple(){
    CGFloat heightScaleFactor;
    CGFloat placeLabelHeightScaleFactor;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *movingViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *movingView;

@end

@implementation LocationSimple

-(void)layoutSubviews{
    self.movingViewHeightConstraint.constant = self.bounds.size.height * heightScaleFactor;
    self.placeLabelHeightConstraint.constant = self.movingView.bounds.size.height * placeLabelHeightScaleFactor;
    
    float newPlaceFontSize = self.bounds.size.width > 320.0 ? 70.0 : 35.0;
    self.textPlace.font = [UIFont fontWithName:self.textPlace.font.fontName size:newPlaceFontSize];
    
    float newLocationFontSize = self.bounds.size.width > 320.0 ? 30.0 : 15.0;
    self.textLocation.font = [UIFont fontWithName:self.textLocation.font.fontName size:newLocationFontSize];
    
    [super layoutSubviews];
}

-(void)initialise{
    [self setupGradient:0.3 inDirection:GRADIENT_UP];
    heightScaleFactor = self.movingView.bounds.size.height / self.bounds.size.height;
    placeLabelHeightScaleFactor = self.textPlace.bounds.size.height / self.movingView.bounds.size.height;
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];
    self.movingView.backgroundColor = [UIColor clearColor];
    
    canEditFieldLocation = YES;
}

-(void)moveContentUp{
    [super moveContentUp];
    [self setupGradient:0.3 inDirection:GRADIENT_UP];
}

-(void)moveContentDown{
    [super moveContentDown];
    [self setupGradient:0.3 inDirection:GRADIENT_DOWN];
}

-(void)fieldLocationDidUpdate{
    self.textPlace.text = [fieldLocation.name uppercaseString];
    
    self.textLocation.text = [fieldLocation getLocationString];
    self.constraintLocationHeight.constant = self.textLocation.text.length > 0 ? 20.0 : 0.0;
}

@end
