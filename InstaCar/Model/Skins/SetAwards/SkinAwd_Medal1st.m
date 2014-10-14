//
//  SkinAwd_Medal1st.m
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinAwd_Medal1st.h"

@interface SkinAwd_Medal1st()

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinAwd_Medal1st

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height andMovingViewTopBottomMargin:0];
    
    canEditFieldAuto1 = YES;
}

-(void)fieldAuto1DidUpdate{
    self.labelAuto.text = fieldAuto1.selectedTextFull;
    
    NSString *autoYears = fieldAuto1.selectedTextYears;;
    if (autoYears.length > 0){
        autoYears = [NSString stringWithFormat:@", %@", autoYears];
    }
    
    self.labelMadeIn.text = [NSString stringWithFormat:@"Made in %@%@", fieldAuto1.country, autoYears];

}

@end
