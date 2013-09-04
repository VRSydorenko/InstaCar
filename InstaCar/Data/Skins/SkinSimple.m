//
//  SkinSimple.m
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinSimple.h"
#import "DataManager.h"

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
    Auto *auto1 = [DataManager getSelectedAuto1];
    self.imgEmblem.image = [UIImage imageNamed:auto1.logo];
    self.textAuto.text = auto1.name;
    CGSize textSize = [auto1.name sizeWithFont:self.textAuto.font];
    self.autoTitleWidth.constant = textSize.width;
}

-(void)fieldText1DidUpdate{
    self.text.text = fieldText1;
}

@end
