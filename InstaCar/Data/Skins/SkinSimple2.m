//
//  SkinSimple2.m
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinSimple2.h"
#import "DataManager.h"

@interface SkinSimple2(){
    CGFloat heightScaleFactor;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLogoConstraint;
@property (weak, nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinSimple2

-(void)layoutSubviews{
    self.heightConstraint.constant = self.bounds.size.height * heightScaleFactor;
    self.widthLogoConstraint.constant = self.imgEmblem.bounds.size.height; // 30% wider than taller
    
    [super layoutSubviews];
}

-(void)initialise{
    heightScaleFactor = self.movingView.bounds.size.height / self.bounds.size.height;
    [self.imgEmblem.layer setMinificationFilter:kCAFilterTrilinear];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];

    canEditFieldAuto1 = YES;
}

-(void)fieldAuto1DidUpdate{
    Auto *auto1 = [DataManager getSelectedAuto1];
    self.imgEmblem.contentMode = UIViewContentModeScaleAspectFit;
    self.imgEmblem.image = [UIImage imageNamed:auto1.logo];
}

@end
