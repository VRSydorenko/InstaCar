//
//  SkinEmo_BestPresent.m
//  InstaCar
//
//  Created by VRS on 03/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinEmo_BestPresent.h"

@interface SkinEmo_BestPresent()

@property (nonatomic) IBOutlet NSLayoutConstraint *constraintTopMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinEmo_BestPresent

-(void)initialise{
    [self setMovingViewConstraint:self.constraintTopMargin andViewHeight:self.movingView.bounds.size.height andMovingViewTopBottomMargin:0];
    
    self.movingView.backgroundColor = [UIColor clearColor];
    
    canEditFieldAuto1 = YES;
    
    commands = [NSArray arrayWithObjects:
                [NSNumber numberWithInt:COMMAND_EDITTEXT],
                [NSNumber numberWithInt:COMMAND_INVERTCOLORS],
                nil];
}

-(void)fieldAuto1DidUpdate{
    self.labelAuto.text = fieldAuto1.selectedTextFull;
}

-(NSString*)getSkinContentText{
    return self.labelText.text;
}

-(void)onCmdEditText:(NSString *)newText{
    self.labelText.text = newText;
}

-(void)onCmdInvertColors{
    [self.labelAuto invertColors];
    [self.labelText invertColors];
}

@end
