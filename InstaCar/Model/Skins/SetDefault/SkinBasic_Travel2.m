//
//  SkinBasic_Travel2.m
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinBasic_Travel2.h"

@interface SkinBasic_Travel2()

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelAutoWidth;

@end

@implementation SkinBasic_Travel2

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height andMovingViewTopBottomMargin:0];

    canEditFieldAuto1 = YES;
    
    commands = [NSArray arrayWithObjects:
                [NSNumber numberWithInt:COMMAND_EDITTEXT],
                nil];
}

-(void)fieldAuto1DidUpdate{
    self.labelAuto.text = fieldAuto1.selectedTextFull;
    [self adjustAutoLabelSizeAccordingToText];
}
-(void)onCmdEditText:(NSString *)newText{
    self.labelAuto.text = newText;
    [self adjustAutoLabelSizeAccordingToText];
}
-(NSString*)getSkinContentText{
    return self.labelAuto.text;
}

-(void)adjustAutoLabelSizeAccordingToText{
    CGSize textSize = [self.labelAuto.text sizeWithAttributes:[NSDictionary dictionaryWithObject:self.labelAuto.font forKey:NSFontAttributeName]];
    self.constraintLabelAutoWidth.constant = MIN(5.0+textSize.width, self.bounds.size.width - self.labelAuto.frame.origin.x);
}

@end
