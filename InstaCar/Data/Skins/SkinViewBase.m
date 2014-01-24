//
//  SkinViewBase.m
//  InstaCar
//
//  Created by VRS on 8/28/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinViewBase.h"
#import "Utils.h"

@implementation SkinViewBase

#pragma mark Initialization

-(void)setupGradient:(CGFloat)alpha inDirection:(GradientDirection)direction{
    if (!gradient){
        gradient = [[UIAlphaGradientView alloc] initWithFrame:self.frame];
        gradient.color = [UIColor blackColor];
        gradient.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    
    gradient.direction = direction;
    gradient.alpha = alpha;
    
    if (!gradientInitialized){
        [self addSubview:gradient];
        [self sendSubviewToBack:gradient];
        gradientInitialized = YES;
    }
}

#pragma mark -

-(BOOL) canEditField:(SkinField)field{
    switch (field) {
        case fLOCATION:
            return canEditFieldLocation;
        case fAUTO1:
            return canEditFieldAuto1;
        case fAUTO2:
            return canEditFieldAuto2;
        case fTEXT1:
            return canEditFieldText1;
        case fTEXT2:
            return canEditFieldText2;
        default:
            return NO;
    }
}

-(void) updateField:(SkinField)field withValue:(NSObject*)value{
    if (![self canEditField:field]){
        return;
    }
    switch (field) {
        case fLOCATION:
            if ([value isKindOfClass:FSVenue.class]){
                fieldLocation = [[Location alloc] initWIthVenue:(FSVenue*)value];
                [self fieldLocationDidUpdate];
            }
            break;
        case fAUTO1:
            if ([value isKindOfClass:Auto.class]){
                fieldAuto1 = (Auto*)value;
                [self fieldAuto1DidUpdate];
            }
            break;
        case fAUTO2:
            if ([value isKindOfClass:Auto.class]){
                fieldAuto2 = (Auto*)value;
                [self fieldAuto2DidUpdate];
            }
            break;
        case fTEXT1:
            if ([value isKindOfClass:NSString.class]){
                fieldText1 = (NSString*)value;
                [self fieldText1DidUpdate];
            }
            break;
        case fTEXT2:
            if ([value isKindOfClass:NSString.class]){
                fieldText2 = (NSString*)value;
                [self fieldText2DidUpdate];
            }
            break;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

// initial values for the base class
-(void)baseInit{
    canEditFieldLocation = NO;
    canEditFieldAuto1 = NO;
    canEditFieldAuto2 = NO;
    canEditFieldText1 = NO;
    canEditFieldText2 = NO;
    
    self.userInteractionEnabled = YES;
    gradient = nil;
    gradientInitialized = NO;
    isContentOnTop = YES;
    movingViewTopBottomMargin = 0.0;
}

-(void)initialise{
    // overriden by descendants
}

-(void)setMovingViewConstraint:(NSLayoutConstraint*)topMargin andViewHeight:(unsigned short)height{
    movingViewTopMarginConstraint = topMargin;
    movingViewHeight = height;
    heightScaleFactor = height / self.bounds.size.height;
}

-(UIImage*)getSkinImage{
    return [self getSkinImageWithBlur:0.0];
}

-(UIImage*)getSkinImageWithBlur:(CGFloat)blurStrength {
    CGFloat desiredSideLength = 918.0;
    CGFloat scaleFactorHeight = desiredSideLength/self.bounds.size.height;
    
    self.layer.contentsScale = scaleFactorHeight;
    CGRect currentFrame = self.frame;
    bool movingViewIsOnTop = movingViewTopMarginConstraint.constant == movingViewTopBottomMargin;
    if (movingViewIsOnTop){
        movingViewTopMarginConstraint.constant = movingViewTopBottomMargin*scaleFactorHeight;
    } else {
        movingViewTopMarginConstraint.constant = desiredSideLength - movingViewHeight*scaleFactorHeight - movingViewTopBottomMargin*scaleFactorHeight;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, desiredSideLength, desiredSideLength);
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self layoutSubviews];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(desiredSideLength, desiredSideLength), NO, scaleFactorHeight);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.frame = currentFrame;
    if (movingViewIsOnTop){
        movingViewTopMarginConstraint.constant = movingViewTopBottomMargin;
    } else {
        movingViewTopMarginConstraint.constant = currentFrame.size.height - movingViewHeight - movingViewTopBottomMargin;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self layoutSubviews];
    
    if (blurStrength > 0){
        result = [Utils blurImage:result strength:blurStrength];
    }
    
    return result;
}

-(BOOL)isSkinContentAtTheTop{
    return isContentOnTop;
}

-(void)moveContentUp{
    if (!movingViewTopMarginConstraint || movingViewHeight == 0){
        return;
    }
    
    if (movingViewTopMarginConstraint.constant == movingViewTopBottomMargin){
        return; // already at the top
    }

    [UIView animateWithDuration:MOVINGVIEW_TIME
            animations:^(void){
                movingViewTopMarginConstraint.constant = movingViewTopBottomMargin;
                [self layoutIfNeeded];
            }
            completion:^(BOOL finished){
            }
     ];
    isContentOnTop = YES;
}

-(void)moveContentDown{
    if (!movingViewTopMarginConstraint || movingViewHeight == 0){
        return;
    }
    
    if (movingViewTopMarginConstraint.constant != movingViewTopBottomMargin){
        return; // already at the bottom (at least not on the top)
    }
    
    [UIView animateWithDuration:MOVINGVIEW_TIME
            animations:^(void){
                movingViewTopMarginConstraint.constant = self.bounds.size.height - movingViewHeight - movingViewTopBottomMargin;
                [self layoutIfNeeded];
            }
            completion:^(BOOL finished){
            }
     ];
    isContentOnTop = NO;
}

-(void)fieldLocationDidUpdate{
    // overriden in descendants
}

-(void)fieldAuto1DidUpdate{
    // overriden in descendants
}

-(void)fieldAuto2DidUpdate{
    // overriden in descendants
}

-(void)fieldText1DidUpdate{
    // overriden in descendants
}

-(void)fieldText2DidUpdate{
    // overriden in descendants
}

@end
