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
#import "UIAlphaGradientView.h"

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
} CommandFlags;

@protocol SkinCommandProtocol <NSObject>
// commands
-(void)onCmdInvertColors;
-(void)onCmdEditText:(NSString*)newText;
-(void)onCmdEditPrefix:(NSString*)newPrefix;
// data getters
-(NSString*)getSkinContentText;
-(NSString*)getSkinPrefixText;
-(BOOL)getAllowsEmptyContentText;
@end
    
@interface SkinViewBase : UIView <SkinCommandProtocol> {
@protected
    BOOL canEditFieldLocation;
    BOOL canEditFieldAuto1;
    BOOL canEditFieldAuto2;
    BOOL canEditFieldText1;
    BOOL canEditFieldText2;
    
    CommandFlags _commandFlags;
    
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
    UIAlphaGradientView *gradient;
    BOOL gradientInitialized;
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

-(CommandFlags)getSkinCommands;

-(void)moveContentUp;
-(void)moveContentDown;

#pragma mark SkinCommand protocols
-(void)onCmdInvertColors;
-(void)onCmdEditText:(NSString *)newText;

-(void)fieldLocationDidUpdate;
-(void)fieldAuto1DidUpdate;
-(void)fieldAuto2DidUpdate;
-(void)fieldText1DidUpdate;
-(void)fieldText2DidUpdate;

@end
