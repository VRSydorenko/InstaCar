//
//  SkinViewBase.h
//  InstaCar
//
//  Created by VRS on 8/28/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "Auto.h"

#define MOVINGVIEW_TIME 0.5f

@class SkinViewBase;

@protocol SkinSetProtocol <NSObject>
-(NSString*)getTitle;
-(unsigned short)getSkinsCount;
-(SkinViewBase*)getSkinAtIndex:(unsigned short)index;
-(void)freeSkins;
@end

typedef enum {
    LOCATION,
    AUTO1,
    AUTO2,
    TEXT1,
    TEXT2,
} SkinField;
    
@interface SkinViewBase : UIView {
@protected
    BOOL canEditFieldLocation;
    BOOL canEditFieldAuto1;
    BOOL canEditFieldAuto2;
    BOOL canEditFieldText1;
    BOOL canEditFieldText2;
    
    Location *fieldLocation;
    Auto *fieldAuto1;
    Auto *fieldAuto2;
    NSString *fieldText1;
    NSString *fieldText2;
    
@private
    NSLayoutConstraint *movingViewTopMarginConstraint;
    unsigned short movingViewHeight;
    
    UISwipeGestureRecognizer *swipeUp;
    UISwipeGestureRecognizer *swipeDown;
}

-(void)setMovingViewConstraint:(NSLayoutConstraint*)topMargin andViewHeight:(unsigned short)height;
-(BOOL) canEditField:(SkinField)field;
-(void) updateField:(SkinField)field withValue:(NSObject*)value;
-(UIImage*)getImage;

//-(void)moveContentUp;
//-(void)moveContentDown;

-(void)fieldLocationDidUpdate;
-(void)fieldAuto1DidUpdate;
-(void)fieldAuto2DidUpdate;
-(void)fieldText1DidUpdate;
-(void)fieldText2DidUpdate;

@end
