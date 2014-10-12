//
//  SkinAwd_Raiting.m
//  InstaCar
//
//  Created by VRS on 03/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinAwd_Raiting.h"

@interface SkinAwd_Raiting(){
    int raiting;
}

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinAwd_Raiting

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];
    
    _commandFlags.canCmdEditRaiting = YES;
    raiting = [super getSkinRaiting];
}

-(int)getSkinRaiting{
    return raiting;
}
-(void)onCmdEditRaiting:(int)newRaiting{
    raiting = newRaiting;
}

@end