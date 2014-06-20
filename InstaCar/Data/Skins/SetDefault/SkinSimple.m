//
//  SkinSimple.m
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinSimple.h"

@interface SkinSimple()

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *widthLogoConstraint;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinSimple

/*-(void)layoutSubviews{
    self.heightConstraint.constant = self.bounds.size.height * heightScaleFactor;
    self.widthLogoConstraint.constant = self.imgEmblem.bounds.size.height * 1.33; // 30% wider than taller
    
    float newFontSize = self.bounds.size.width > 320.0 ? 70.0 : 25.0;
    self.textAuto.font = [UIFont fontWithName:self.textAuto.font.fontName size:newFontSize];
    [self adjustAutoLabelSizeAccordingToText];
    
    [super layoutSubviews];
}*/

-(void)initialise{
    [self setupGradient:0.4 inDirection:GRADIENT_LEFT];
    [self.imgEmblem.layer setMinificationFilter:kCAFilterTrilinear];
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];

    canEditFieldAuto1 = YES;
    self.textAuto.adjustsFontSizeToFitWidth = YES;
}

-(void)fieldAuto1DidUpdate{
    self.imgEmblem.contentMode = UIViewContentModeScaleAspectFit;
    self.imgEmblem.image = [UIImage imageNamed:fieldAuto1.logo];
    self.textAuto.text = fieldAuto1.selectedText;
    
    [self adjustAutoLabelSizeAccordingToText];
}

-(void)adjustAutoLabelSizeAccordingToText{
    CGSize textSize = [self.textAuto.text sizeWithAttributes:[NSDictionary dictionaryWithObject:self.textAuto.font forKey:NSFontAttributeName]];
    self.autoTitleWidth.constant = MIN(textSize.width, self.bounds.size.width - self.widthLogoConstraint.constant - 10);
}

@end
