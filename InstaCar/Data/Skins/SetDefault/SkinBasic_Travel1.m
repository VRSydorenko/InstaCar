//
//  SkinBasic_Travel1.m
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinBasic_Travel1.h"

@interface SkinBasic_Travel1()

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelWithMyCarWidth;
@property (weak, nonatomic) IBOutlet SkinElementRect *viewLabelBackground;
@property (weak, nonatomic) IBOutlet SkinElementLabel *labelWithMyCar;
@end

@implementation SkinBasic_Travel1

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];

    self.movingView.backgroundColor = [UIColor clearColor];
    self.labelWithMyCar.hidden = YES;
    self.viewLabelBackground.hidden = YES;
    
    canEditFieldAuto1 = YES;
}

-(void)fieldAuto1DidUpdate{
    self.labelWithMyCar.hidden = fieldAuto1 == nil;
    self.viewLabelBackground.hidden = fieldAuto1 == nil;
    
    if (fieldAuto1){
        self.labelWithMyCar.text = [NSString stringWithFormat:@"with my %@", fieldAuto1.selectedTextFull];
        [self.labelWithMyCar sizeToFit];
        [self adjustAutoLabelSizeAccordingToText];
    }
}

-(void)adjustAutoLabelSizeAccordingToText{
    CGSize textSize = [self.labelWithMyCar.text sizeWithAttributes:[NSDictionary dictionaryWithObject:self.labelWithMyCar.font forKey:NSFontAttributeName]];
    self.constraintLabelWithMyCarWidth.constant = MIN(5.0+textSize.width, self.bounds.size.width * 0.8 /* label takes max 80% of the screen width*/);
}

@end
