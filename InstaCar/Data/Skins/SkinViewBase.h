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
#import "MainNavController.h"
#import "UIBluredView.h"
#import "UIAlphaGradientView.h"

#define MOVINGVIEW_TIME 0.5

@class SkinViewBase;

@protocol SkinSetProtocol <NSObject>
-(NSString*)getTitle;
-(unsigned short)getSkinsCount;
-(SkinViewBase*)getSkinAtIndex:(unsigned short)index;
-(void)freeSkins;
-(void)updateData:(id)data ofType:(SelectedDataChange)type;
-(BOOL)supportsSecondCar;
@end

typedef enum {
    fLOCATION,
    fAUTO1,
    fAUTO2,
    fTEXT1,
    fTEXT2,
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
    UIAlphaGradientView *gradient;
    BOOL gradientInitialized;
    BOOL isContentOnTop;
}

-(void)baseInit;
-(void)initialise;
-(void)setupGradient:(CGFloat)alpha inDirection:(GradientDirection)direction;
-(void)setMovingViewConstraint:(NSLayoutConstraint*)topMargin andViewHeight:(unsigned short)height;
-(BOOL)canEditField:(SkinField)field;
-(void)updateField:(SkinField)field withValue:(NSObject*)value;
-(BOOL)isSkinContentAtTheTop;

-(UIImage*)getSkinImage;
-(UIImage*)getSkinImageWithBlur:(CGFloat)blurStrength;

-(void)moveContentUp;
-(void)moveContentDown;

-(void)fieldLocationDidUpdate;
-(void)fieldAuto1DidUpdate;
-(void)fieldAuto2DidUpdate;
-(void)fieldText1DidUpdate;
-(void)fieldText2DidUpdate;

@end
