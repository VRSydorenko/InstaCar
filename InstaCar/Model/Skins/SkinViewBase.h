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
#import "SkinCommandProtocol.h"

#import "SkinElementLabel.h"
#import "SkinElementImage.h"
#import "SkinElementRect.h"
#import "SkinElementRect.h"

#define MOVINGVIEW_TIME 0.5

typedef enum {
    fLOCATION,
    fAUTO1,
    fAUTO2,
    fTEXT1,
    fTEXT2,
} SkinField;

typedef struct {
    unsigned int canCmdInvertColors:1;
    unsigned int canCmdEditText:1;
    unsigned int canCmdEditPrefix:1;
    unsigned int canCmdEditRaiting:1;
} CommandFlags;
    
@interface SkinViewBase : UIView <SkinCommandDelegate> {
@protected
    BOOL canEditFieldLocation;
    BOOL canEditFieldAuto1;
    BOOL canEditFieldAuto2;
    BOOL canEditFieldText1;
    BOOL canEditFieldText2;
    
    NSArray *commands; // type: NSNumber
    
    Location *fieldLocation;
    Auto *fieldAuto1;
    Auto *fieldAuto2;
    NSString *fieldText1;
    NSString *fieldText2;
    
    CGFloat heightScaleFactor;
    CGFloat movingViewTopBottomMargin;
    
    BOOL isContentOnTop;
    
@private
    NSLayoutConstraint *movingViewTopMarginConstraint;
    unsigned short movingViewHeight;
    BOOL gradientInitialized;
}

-(void)baseInit;
-(void)initialise;
-(void)setMovingViewConstraint:(NSLayoutConstraint*)topMargin
                 andViewHeight:(unsigned short)height
  andMovingViewTopBottomMargin:(CGFloat)margin;
-(BOOL)canEditField:(SkinField)field;
-(void)updateField:(SkinField)field withValue:(NSObject*)value;
-(BOOL)isSkinContentAtTheTop;

-(UIImage*)getSkinImage;
-(UIImage*)getSkinImageWithBlur:(CGFloat)blurStrength;

-(NSArray*)getSkinCommands;

-(void)moveContentUp;
-(void)moveContentDown;

-(void)fieldLocationDidUpdate;
-(void)fieldAuto1DidUpdate;
-(void)fieldAuto2DidUpdate;
-(void)fieldText1DidUpdate;
-(void)fieldText2DidUpdate;

@end
