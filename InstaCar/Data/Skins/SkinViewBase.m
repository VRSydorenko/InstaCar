//
//  SkinViewBase.m
//  InstaCar
//
//  Created by VRS on 8/28/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinViewBase.h"

@implementation SkinViewBase

#pragma mark Initialization

-(id)init{
    self = [super init];
    if (self) {
        canEditFieldLocation = NO;
        canEditFieldAuto1 = NO;
        canEditFieldAuto2 = NO;
        canEditFieldText1 = NO;
        canEditFieldText2 = NO;
        
        self.userInteractionEnabled = YES;
    }
    return self;
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
            if ([value isKindOfClass:Location.class]){
                fieldLocation = (Location*)value;
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
}

-(void)initialise{
    // overriden by descendants
}

-(void)setMovingViewConstraint:(NSLayoutConstraint*)topMargin andViewHeight:(unsigned short)height{
    movingViewTopMarginConstraint = topMargin;
    movingViewHeight = height;
}

-(UIImage*)getImageOfSize:(CGSize)size andScale:(CGFloat)scale{
    CGFloat scaleFactorHeight = size.height/self.frame.size.height;
    CGFloat scaleFactorWidth = size.width/self.frame.size.width;
    
    //[self setViewContentScaleFactor:scale forView:self];
        
    //self.transform = CGAffineTransformMakeScale(scaleFactorWidth, scaleFactorHeight);
    //[self setNeedsDisplay];

    self.layer.contentsScale = scaleFactorHeight;
    CGRect currentFrame = self.frame;
    self.frame = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, scaleFactorHeight);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.frame = currentFrame;
    return result;
}

-(void)setViewContentScaleFactor:(CGFloat)scale forView:(UIView*)view{
    view.contentScaleFactor = scale;
    for (UIView *subview in view.subviews) {
        [self setViewContentScaleFactor:scale forView:subview];
    }
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
                movingViewTopMarginConstraint.constant = self.frame.size.height - movingViewHeight;
                [self layoutIfNeeded];
            }
            completion:^(BOOL finished){
            }
     ];
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
