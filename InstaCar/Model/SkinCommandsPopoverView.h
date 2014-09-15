//
//  SkinCommandsPopoverView.h
//  InstaCar
//
//  Created by VRS on 15/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinViewBase.h"

@interface SkinCommandsPopoverView : UIView{
@private
    CommandFlags skinCommands;
}

@property (nonatomic) SkinViewBase *delegatingSkin;
@property BOOL hasCloseButton;

@end
