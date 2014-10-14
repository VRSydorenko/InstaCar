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
    placeLabelHeightScaleFactor = self.constraintLocationHeight.constant / self.movingView.bounds.size.height;
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height andMovingViewTopBottomMargin:0];
    self.movingView.backgroundColor = [UIColor clearColor];
    
    canEditFieldLocation = YES;
    _commandFlags.canCmdInvertColors = YES;
}

-(void)moveContentUp{
    [super moveContentUp];
}

-(void)moveContentDown{
    [super moveContentDown];
}

-(void)fieldLocationDidUpdate{
    self.textPlace.text = [fieldLocation.name uppercaseString];
    
    self.textLocation.text = [fieldLocation getLocationString];
    self.constraintLocationHeight.constant = self.textLocation.text.length > 0 ? 20.0 : 0.0;
}

-(void)onCmdInvertColors{
    [self.textPlace invertColors];
    [self.textLocation invertColors];
}

@end
