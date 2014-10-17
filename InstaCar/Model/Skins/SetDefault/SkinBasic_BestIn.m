//
//  SkinBasic_BestIn.m
//  InstaCar
//
//  Created by VRS on 9/7/13.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinBasic_BestIn.h"

@interface SkinBasic_BestIn()

@property (nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic) IBOutlet UIView *movingView;

@end

@implementation SkinBasic_BestIn

-(void)initialise{
    self.movingView.backgroundColor = [UIColor clearColor];
    
    [self setMovingViewConstraint:self.topMargin andViewHeight:self.movingView.bounds.size.height andMovingViewTopBottomMargin:0];
    
    canEditFieldLocation = YES;
    _commandFlags.canCmdInvertColors = YES;
    _commandFlags.canCmdEditPrefix = YES;
    _commandFlags.canCmdEditText = YES;
}

-(void)fieldLocationDidUpdate{
    self.labelLocation.text = fieldLocation.name;
}

-(void)onCmdInvertColors{
    [self.labelBestIn invertColors];
    [self.labelLocation invertColors];
    [self.labelExclamationMark invertColors];
}

-(void)onCmdEditPrefix:(NSString *)newPrefix{
    self.labelBestIn.text = newPrefix;
}

-(void)onCmdEditText:(NSString *)newText{
    self.labelLocation.text = newText;
}

-(NSString*)getSkinPrefixText{
    return self.labelBestIn.text;
}
-(NSString*)getSkinContentText{
    return self.labelLocation.text;
}

@end
