//
//  SkinEmo_MyDream.m
//  InstaCar
//
//  Created by VRS on 03/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinEmo_MyDream.h"

@interface SkinEmo_MyDream()

@property (nonatomic) IBOutlet NSLayoutConstraint *constraintTopMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinEmo_MyDream

-(void)initialise{
    [self setMovingViewConstraint:self.constraintTopMargin andViewHeight:self.movingView.bounds.size.height];
    
    self.movingView.backgroundColor = [UIColor clearColor];
    
    canEditFieldAuto1 = YES;
}

-(void)fieldAuto1DidUpdate{
    self.labelAuto.text = fieldAuto1.name;
}
@end