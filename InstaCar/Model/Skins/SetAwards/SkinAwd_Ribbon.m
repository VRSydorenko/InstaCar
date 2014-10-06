//
//  SkinAwd_Placeholder1.m
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinAwd_Ribbon.h"

@interface SkinAwd_Ribbon()

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinAwd_Ribbon

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];
    
    _commandFlags.canCmdEditText = YES;
    isContentOnTop = NO;
}

-(NSString*)getSkinContentText{
    return self.labelText.text;
}

-(void)onCmdEditText:(NSString *)newText{
    self.labelText.text = newText;
}

@end
