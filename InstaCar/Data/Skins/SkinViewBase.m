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
        
        [self initGestures];
    }
    return self;
}

-(void)initGestures{
    swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveContentUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeUp];
    
    swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveContentDown)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeDown];

}

#pragma mark -

-(BOOL) canEditField:(SkinField)field{
    switch (field) {
        case LOCATION:
            return canEditFieldLocation;
        case AUTO1:
            return canEditFieldAuto1;
        case AUTO2:
            return canEditFieldAuto2;
        case TEXT1:
            return canEditFieldText1;
        case TEXT2:
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
        case LOCATION:
            if ([value isKindOfClass:Location.class]){
                fieldLocation = (Location*)value;
                [self fieldLocationDidUpdate];
            }
            break;
        case AUTO1:
            if ([value isKindOfClass:Auto.class]){
                fieldAuto1 = (Auto*)value;
                [self fieldAuto1DidUpdate];
            }
            break;
        case AUTO2:
            if ([value isKindOfClass:Auto.class]){
                fieldAuto2 = (Auto*)value;
                [self fieldAuto2DidUpdate];
            }
            break;
        case TEXT1:
            if ([value isKindOfClass:NSString.class]){
                fieldText1 = (NSString*)value;
                [self fieldText1DidUpdate];
            }
            break;
        case TEXT2:
            if ([value isKindOfClass:NSString.class]){
                fieldText2 = (NSString*)value;
                [self fieldText2DidUpdate];
            }
            break;
    }
}

-(void)setMovingViewConstraint:(NSLayoutConstraint*)topMargin andViewHeight:(unsigned short)height{
    movingViewTopMarginConstraint = topMargin;
    movingViewHeight = height;
}

-(UIImage*)getImage{
    return nil;
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
