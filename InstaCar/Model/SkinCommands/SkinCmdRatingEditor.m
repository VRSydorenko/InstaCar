//
//  SkinCmdRatingEditor.m
//  InstaCar
//
//  Created by VRS on 19/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinCmdRatingEditor.h"

@implementation SkinCmdRatingEditor

-(BOOL)isPro{
    return NO;
}

-(UIView*)getCmdView{
    assert(self.delegate);
    assert(self.container);
    
    return self;
}

-(void)execute{
    assert(false);
}

-(void)prepare{
    rating = [self.delegate getSkinRaiting];
}

-(UIImage*)getIcon{ // TODO: add rating icon
    return [UIImage imageNamed:@"imgCmdEditNormal@2x.png"]; // TODO: use name w/o scale factor
}

-(NSString*)getTitle{
    return @"Rate";
}

- (IBAction)onBtnCancel:(id)sender {
    [self.container skinCommandOnExecuted];
}

- (IBAction)onBtnConfirm:(id)sender {
    [self.delegate onCmdEditRaiting:rating];
    [self.container skinCommandOnExecuted];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.constraintBtnCancelWidth.constant = self.bounds.size.height;
    self.constraintbtnConfirmWidth.constant = self.bounds.size.height;
    
    CGFloat oneStarWidth = (self.bounds.size.width - 2 * self.bounds.size.height /*cancel & confirm buttons*/) / 5 /*stars count*/;
    self.constraintStar1Width.constant = oneStarWidth;
    self.constraintStar2Width.constant = oneStarWidth;
    self.constraintStar4Width.constant = oneStarWidth;
    self.constraintStar5Width.constant = oneStarWidth;
}

-(IBAction)onStarClick:(id)sender{
    UIButton *starBtn = (UIButton*)sender;
    if (!starBtn)
        return;
    
    if (starBtn == self.btnStar1)
        rating = 1;
    else if (starBtn == self.btnStar2)
        rating = 2;
    else if (starBtn == self.btnStar3)
        rating = 3;
    else if (starBtn == self.btnStar4)
        rating = 4;
    else // if (starBtn == self.btnStar5)
        rating = 5;
    
    [self updateStarsAccordingToRaiting:rating];
}

-(void)updateStarsAccordingToRaiting:(int)rate{
    UIImage *starFull = [UIImage imageNamed:@"star_full.png"]; // TODO: use image from asset / scaled
    UIImage *starDark = [UIImage imageNamed:@"star_dark.png"]; // TODO: use image from asset / scaled
    
    [self.btnStar1 setImage:rate >= 1 ? starFull : starDark forState:UIControlStateNormal];
    [self.btnStar2 setImage:rate >= 2 ? starFull : starDark forState:UIControlStateNormal];
    [self.btnStar3 setImage:rate >= 3 ? starFull : starDark forState:UIControlStateNormal];
    [self.btnStar4 setImage:rate >= 4 ? starFull : starDark forState:UIControlStateNormal];
    [self.btnStar5 setImage:rate >= 5 ? starFull : starDark forState:UIControlStateNormal];
    
    [self.btnStar1 setImage:rate >= 1 ? starFull : starDark forState:UIControlStateHighlighted];
    [self.btnStar2 setImage:rate >= 2 ? starFull : starDark forState:UIControlStateHighlighted];
    [self.btnStar3 setImage:rate >= 3 ? starFull : starDark forState:UIControlStateHighlighted];
    [self.btnStar4 setImage:rate >= 4 ? starFull : starDark forState:UIControlStateHighlighted];
    [self.btnStar5 setImage:rate >= 5 ? starFull : starDark forState:UIControlStateHighlighted];
}
@end
