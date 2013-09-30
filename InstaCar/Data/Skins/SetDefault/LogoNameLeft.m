//
//  LogoNameLeft.m
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "LogoNameLeft.h"
#import "DataManager.h"

@interface LogoNameLeft(){
    CGFloat heightScaleFactor;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLogoConstraint;
@property (weak, nonatomic) IBOutlet UIView *movingView;

@end

@implementation LogoNameLeft

-(void)layoutSubviews{
    self.heightConstraint.constant = self.bounds.size.height * heightScaleFactor;
    self.widthLogoConstraint.constant = self.imgEmblem.bounds.size.height * 1.33; // 30% wider than taller
    
    float newFontSize = self.bounds.size.width > 320.0 ? 50.0 : 25.0;
    self.textAuto.font = [UIFont fontWithName:self.textAuto.font.fontName size:newFontSize];
    [self adjustAutoLabelSizeAccordingToText];
    
    [super layoutSubviews];
}

-(void)initialise{
    [self setupGradient:0.4 inDirection:GRADIENT_RIGHT];
    
    heightScaleFactor = self.movingView.bounds.size.height / self.bounds.size.height;
    [self.imgEmblem.layer setMinificationFilter:kCAFilterTrilinear];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];

    canEditFieldAuto1 = YES;
}

-(void)fieldAuto1DidUpdate{
    Auto *auto1 = [DataManager getSelectedAuto1];
    self.imgEmblem.contentMode = UIViewContentModeScaleAspectFit;
    self.imgEmblem.image = [UIImage imageNamed:auto1.logo];
    self.textAuto.text = auto1.selectedText;
    
    [self adjustAutoLabelSizeAccordingToText];
}

-(void)adjustAutoLabelSizeAccordingToText{
    CGSize textSize = [self.textAuto.text sizeWithAttributes:[NSDictionary dictionaryWithObject:self.textAuto.font forKey:NSFontAttributeName]];
    self.autoTitleWidth.constant = textSize.width;
}

@end
