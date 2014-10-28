//
//  SkinCmdTextEditor.h
//  InstaCar
//
//  Created by VRS on 18/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinCommandProtocol.h"

typedef enum {
    EDITORMODE_TEXT,
    EDITORMODE_PREFIX,
} EditorModes;

@interface SkinCmdTextEditor : UIView <SkinCommandProtocol>{
    BOOL sizeInitialized;
}

@property (nonatomic) EditorModes editorMode;
@property (nonatomic) SkinCommandDelegate *delegate;
@property (nonatomic) SkinCommandContainerDelegate *container;

@property (weak, nonatomic) IBOutlet UIButton *btnDecline;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UITextField *txtText;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnCancelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintbtnConfirmWidth;

- (IBAction)onBtnCancel:(id)sender;
- (IBAction)onBtnConfirm:(id)sender;
- (IBAction)onTextChanged:(id)sender;

@end
