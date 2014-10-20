//
//  SkinBasic_Travel1.m
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinBasic_Travel1.h"

@interface SkinBasic_Travel1(){
    NSString *prefix;
}

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelWithMyCarWidth;
@property (weak, nonatomic) IBOutlet SkinElementRect *viewLabelBackground;
@property (weak, nonatomic) IBOutlet SkinElementLabel *labelWithMyCar;
@end

@implementation SkinBasic_Travel1

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height andMovingViewTopBottomMargin:0];

    self.movingView.backgroundColor = [UIColor clearColor];
    
    canEditFieldAuto1 = YES;
    prefix = @"With my";
    
    commands = [NSArray arrayWithObjects:
                [NSNumber numberWithInt:COMMAND_EDITPREFIX],
                nil];
    
    [self fieldAuto1DidUpdate]; // initial skin text
}

-(void)fieldAuto1DidUpdate{
    NSString *car = fieldAuto1 ? fieldAuto1.selectedTextFull : @"[select car...]";
    NSString *pref = prefix.length > 0 ? [NSString stringWithFormat:@"%@ ", prefix] : @"";
    self.labelWithMyCar.text = [NSString stringWithFormat:@"%@%@", pref, car];
    [self adjustAutoLabelSizeAccordingToText];
}

-(NSString*)getSkinPrefixText{
    return prefix;
}
-(void)onCmdEditPrefix:(NSString *)newPrefix{
    prefix = newPrefix;
    [self fieldAuto1DidUpdate];
}

-(void)adjustAutoLabelSizeAccordingToText{
    CGSize textSize = [self.labelWithMyCar.text sizeWithAttributes:[NSDictionary dictionaryWithObject:self.labelWithMyCar.font forKey:NSFontAttributeName]];
    self.constraintLabelWithMyCarWidth.constant = MIN(5.0+textSize.width, self.labelWithMyCar.frame.origin.x + self.labelWithMyCar.bounds.size.width);
}

@end
