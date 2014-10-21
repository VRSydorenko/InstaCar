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

#define SIDE_PADDING 2.0
#define BTNS_EDITOR_MARGIN 2.0
#define HEIGHT_ON_TOP 40.0

@interface SkinCommandsView : UIView <SkinCommandContainerDelegate>{
@private
    CommandFlags skinCommands;
    
    BOOL isEditMode;
}

@property (nonatomic) UIViewController<ProInfoViewControllerDelegate> *ownerVC;
@property (nonatomic) SkinViewBase *delegatingSkin;
@property (nonatomic) BOOL isInEditMode;
@property (nonatomic) CGFloat heightOnTop;

-(void)rebuildView;

@end
