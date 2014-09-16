//
//  SkinCommandsPopoverView.h
//  InstaCar
//
//  Created by VRS on 15/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "UIView+MyExtentions.h"
#import "SkinViewBase.h"

#define SIDE_PADDING 5.0
#define BTNS_EDITOR_MARGIN 2.0

@interface SkinCommandsPopoverView : UIView{
@private
    CommandFlags skinCommands;
    
    BOOL stringEditMode;
    UITextField *stringEditor;
    UIButton *btnCancelStringEdit;
    UIButton *btnConfirmStringEdit;
}

@property (nonatomic) SkinViewBase *delegatingSkin;
@property BOOL hasCloseButton;

-(void)rebuildView;

@end
