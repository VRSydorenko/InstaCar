//
//  SkinCommandsPopoverView.h
//  InstaCar
//
//  Created by VRS on 15/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "UIView+MyExtentions.h"
#include "UIButton+MyExtensions.h"
#import "SkinViewBase.h"

#define BTNS_EDITOR_MARGIN 2.0
#define HEIGHT_ON_TOP_IPHONE4 40.0 // TODO: calc these sizes
#define HEIGHT_ON_TOP_IPHONE5 40.0
#define HEIGHT_ON_TOP_IPHONE6 40.0
#define HEIGHT_ON_TOP_IPHONE6PLUS 40.0

@interface SkinCommandsView : UIView <SkinCommandContainerDelegate>{
@private
    BOOL isEditMode;
}

@property (nonatomic) IBOutlet UIView *cmdContainerView;

@property (nonatomic) IBOutlet UIButton *btnCmd1;
@property (nonatomic) IBOutlet UIButton *btnCmd2;
@property (nonatomic) IBOutlet UIButton *btnCmd3;
@property (nonatomic) IBOutlet UIButton *btnCmd4;
@property (nonatomic) IBOutlet UIButton *btnCmd5;

@property (nonatomic) IBOutlet NSLayoutConstraint *constraintCmd1Width;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintCmd2Width;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintCmd3Width;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintCmd4Width;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintCmd5Width;

@property (nonatomic) UIViewController<ProInfoViewControllerDelegate> *ownerVC;
@property (nonatomic) SkinViewBase *delegatingSkin;
@property (nonatomic) BOOL isInEditMode;
@property (nonatomic) CGFloat heightOnTop;

-(void)rebuildView;

@end
