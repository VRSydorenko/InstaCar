//
//  LocationSimple.m
//  InstaCar
//
//  Created by Viktor on 10/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "LocationSimple.h"

@interface LocationSimple(){
    CGFloat placeLabelHeightScaleFactor;
}

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet NSLayoutConstraint *movingViewHeightConstraint;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation LocationSimple

-(void)initialise{
    [self setupGradient:0.3 inDirection:GRADIENT_UP];
    placeLabelHeightScaleFactor = self.constraintLocationHeight.constant / self.movingView.bounds.size.height;
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
