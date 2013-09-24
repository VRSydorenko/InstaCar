//
//  SkinSimple.m
//  InstaCar
//
//  Created by VRS on 8/30/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinSimple.h"
#import "DataManager.h"

@interface SkinSimple(){
    CGFloat heightScaleFactor;
    CGFloat initialFontSize;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLogoConstraint;
@property (weak, nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinSimple

-(void)layoutSubviews{
    self.heightConstraint.constant = self.bounds.size.height * heightScaleFactor;
    self.widthLogoConstraint.constant = self.imgEmblem.bounds.size.height * 1.33; // 30% wider than taller
    
    float newFontSize = self.bounds.size.width > 320.0 ? 40.0 : 20.0;
    self.text.font = [UIFont fontWithName:self.text.font.fontName size:newFontSize];
    self.textAuto.font = [UIFont fontWithName:self.textAuto.font.fontName size:newFontSize];
    [self adjustAutoLabelSizeAccordingToText];
    
    [super layoutSubviews];
}

-(void)initialise{
    heightScaleFactor = self.movingView.frame.size.height / self.frame.size.height;
    initialFontSize = self.text.font.pointSize;
    //self.widthLogoConstraint.constant = self.imgEmblem.frame.size.height * 1.3;
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.frame.size.height];

    canEditFieldAuto1 = YES;
    canEditFieldText1 = YES;
}

-(void)fieldAuto1DidUpdate{
    Auto *auto1 = [DataManager getSelectedAuto1];
    self.imgEmblem.contentMode = UIViewContentModeScaleAspectFit;
    self.imgEmblem.image = [UIImage imageNamed:auto1.logo];
    NSString *autoText = auto1.name;
    if (auto1.model){
        if (auto1.model.submodel){
            autoText = auto1.model.submodel.name;
        } else {
            autoText = auto1.model.name;
        }
    }
    self.textAuto.text = autoText;
    [self adjustAutoLabelSizeAccordingToText];
}

-(void)fieldText1DidUpdate{
    self.text.text = fieldText1;
}

-(void)adjustAutoLabelSizeAccordingToText{
    CGSize textSize = [self.textAuto.text sizeWithAttributes:[NSDictionary dictionaryWithObject:self.textAuto.font forKey:NSFontAttributeName]];
    self.autoTitleWidth.constant = textSize.width;
}

@end
