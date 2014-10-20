//
//  SkinBasic_Info1.m
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinBasic_Info1.h"

@interface SkinBasic_Info1(){
    CGFloat initialLabelsHeight;
}

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinBasic_Info1

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height andMovingViewTopBottomMargin:0];

    canEditFieldAuto1 = YES;
    
    commands = [NSArray arrayWithObjects:
                [NSNumber numberWithInt:COMMAND_INVERTCOLORS],
                nil];
    
    initialLabelsHeight = self.labelModelHeight.constant;
}

-(void)fieldAuto1DidUpdate{
    self.labelAuto.text = [NSString stringWithFormat:@"Title: %@", fieldAuto1.selectedTextFull];
    
    self.labelModel.text = [NSString stringWithFormat:@"Country: %@", fieldAuto1.country];
    self.labelModelHeight.constant = self.labelModel.text.length > 0 ? initialLabelsHeight : 0;
    
    self.labelYears.text = [NSString stringWithFormat:@"Production: %@", fieldAuto1.selectedTextYears];
    self.labelYearsHeight.constant = fieldAuto1.selectedTextYears.length > 0 ? initialLabelsHeight : 0;
}

-(void)onCmdInvertColors{
    [self.labelAuto invertColors];
    [self.labelModel invertColors];
    self.labelYears.textColor = [Utils invertColor:self.labelYears.textColor];
}


@end
