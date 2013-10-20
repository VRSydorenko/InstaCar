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
}

-(void)initialise{
    // overriden by descendants
}

-(void)setMovingViewConstraint:(NSLayoutConstraint*)topMargin andViewHeight:(unsigned short)height{
    movingViewTopMarginConstraint = topMargin;
    movingViewHeight = height;
}

-(UIImage*)getSkinImage{
    return [self getSkinImageWithBlur:0.0];
}

-(UIImage*)getSkinImageWithBlur:(CGFloat)blurStrength {
    CGFloat scaleFactorHeight = 612.0/self.bounds.size.height;
    
    self.layer.contentsScale = scaleFactorHeight;
    CGRect currentFrame = self.frame;
    if (movingViewTopMarginConstraint.constant > 0){
        movingViewTopMarginConstraint.constant = 612.0 - movingViewHeight*scaleFactorHeight;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 612.0, 612.0);
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self layoutSubviews];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(612.0, 612.0), NO, scaleFactorHeight);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.frame = currentFrame;
    if (movingViewTopMarginConstraint.constant > 0){
        movingViewTopMarginConstraint.constant = currentFrame.size.height - movingViewHeight;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self layoutSubviews];
    
    if (blurStrength > 0){
        result = [Utils blurImage:result strength:blurStrength];
    }
    
    return result;
}

-(void)setViewContentScaleFactor:(CGFloat)scale forView:(UIView*)view{
    view.contentScaleFactor = scale;
    for (UIView *subview in view.subviews) {
        [self setViewContentScaleFactor:scale forView:subview];
    }
}

-(BOOL)isSkinContentAtTheTop{
    return isContentOnTop;
}

-(void)moveContentUp{
    if (!movingViewTopMarginConstraint || movingViewHeight == 0){
        return;
    }
    
    if (movingViewTopMarginConstraint.constant == 0){
        return; // already at the top
    }

    [UIView animateWithDuration:MOVINGVIEW_TIME
            animations:^(void){
                movingViewTopMarginConstraint.constant = 0;
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
    
    if (movingViewTopMarginConstraint.constant != 0){
        return; // already at the bottom (at least not on the top)
    }
    
    [UIView animateWithDuration:MOVINGVIEW_TIME
            animations:^(void){
                movingViewTopMarginConstraint.constant = self.bounds.size.height - movingViewHeight;
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
