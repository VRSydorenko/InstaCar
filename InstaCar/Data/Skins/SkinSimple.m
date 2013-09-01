//
//  SkinSimple.m
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinSimple.h"

@interface SkinSimple()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinSimple

-(void)initialise{
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.frame.size.height];

    canEditFieldAuto1 = YES;
    canEditFieldText1 = YES;
}

-(void)fieldAuto1DidUpdate{
    self.imgEmblem.image = [UIImage imageNamed:@"nav_menu_icon.png"];
    self.textAuto.text = @"BMW";
    CGSize textSize = [self.text.text sizeWithFont:self.text.font];
    self.autoTitleWidth.constant = textSize.width;
}

-(void)fieldText1DidUpdate{
    self.text.text = fieldText1;
}

@end
