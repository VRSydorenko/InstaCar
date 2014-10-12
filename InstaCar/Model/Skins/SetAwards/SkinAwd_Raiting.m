//
//  SkinAwd_Raiting.m
//  InstaCar
//
//  Created by VRS on 03/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinAwd_Raiting.h"

@interface SkinAwd_Raiting(){
    int raiting;
}

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinAwd_Raiting

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height];
    
    canEditFieldAuto1 = YES;
    isContentOnTop = NO;
    
    _commandFlags.canCmdEditRaiting = YES;
    _commandFlags.canCmdEditText = YES;
    raiting = [super getSkinRaiting];
    [self lightUpStars];
}

-(int)getSkinRaiting{
    return raiting;
}
-(void)onCmdEditRaiting:(int)newRaiting{
    raiting = newRaiting;
    [self lightUpStars];
}
-(NSString*)getSkinContentText{
    return self.labelText.text;
}
-(void)onCmdEditText:(NSString *)newText{
    self.labelText.text = newText;
}
-(void)fieldAuto1DidUpdate{
    self.labelText.text = fieldAuto1.selectedTextFull;
}

-(void)lightUpStars{
    UIImage *starLight = [UIImage imageNamed:@"star_full.png"];
    UIImage *starDark = [UIImage imageNamed:@"star_dark.png"];
    [self.imgStar1 setInvertedImage:raiting >= 1 ? starLight : starDark];
    [self.imgStar2 setInvertedImage:raiting >= 2 ? starLight : starDark];
    [self.imgStar3 setInvertedImage:raiting >= 3 ? starLight : starDark];
    [self.imgStar4 setInvertedImage:raiting >= 4 ? starLight : starDark];
    [self.imgStar5 setInvertedImage:raiting >= 5 ? starLight : starDark];
}

@end