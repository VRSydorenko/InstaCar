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
    float newHeight = self.heightConstraint.constant;
    self.widthLogoConstraint.constant = self.imgEmblem.bounds.size.height * 1.33; // 30% wider than taller
    float newWidth = self.widthLogoConstraint.constant;
    self.text.font = [UIFont fontWithName:self.text.font.fontName size:initialFontSize * heightScaleFactor];
    NSLog(@"New font size: %f", initialFontSize * heightScaleFactor);
    NSLog(@"New size: width: %f; height: %f", newWidth, newHeight);
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
    CGSize textSize = [autoText sizeWithAttributes:[NSDictionary dictionaryWithObject:self.textAuto.font forKey: NSFontAttributeName]];

    self.autoTitleWidth.constant = textSize.width;
}

-(void)fieldText1DidUpdate{
    self.text.text = fieldText1;
}

@end
