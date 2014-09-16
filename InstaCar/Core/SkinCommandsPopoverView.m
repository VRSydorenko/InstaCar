//
//  SkinCommandsPopoverView.m
//  InstaCar
//
//  Created by VRS on 15/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinCommandsPopoverView.h"

@implementation SkinCommandsPopoverView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self reset];
    }
    return self;
}

-(void)rebuildView{
    [self reset];
    
    CGFloat cmdWidth = [self getOneCommandWidth];
    CGFloat cmdHeight = [self getOneCommandHeight];
    
    CGRect frame = CGRectMake(SIDE_PADDING, SIDE_PADDING, cmdWidth, cmdHeight);
    
    if (skinCommands.canCmdInvertColors){
        UIButton *btn = [[UIButton alloc] initWithFrame:frame];
        [btn addTarget:self action:@selector(onCommandInvertPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor lightGrayColor];
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:@"Invert colors" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // images
        btn.imageView.contentMode = UIViewContentModeCenter;
        [btn setImage:[UIImage imageNamed:@"imgCmdInvertNormal.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"imgCmdInvertActive.png"] forState:UIControlStateHighlighted];
        
        [self addSubview:btn];
        
        frame.origin.x += cmdWidth;
    }
    
    if (skinCommands.canCmdEditText){
        UIButton *btn = [[UIButton alloc] initWithFrame:frame];
        [btn addTarget:self action:@selector(onCommandEditTextPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor lightGrayColor];
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:@"Edit text" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // images
        btn.imageView.contentMode = UIViewContentModeCenter;
        [btn setImage:[UIImage imageNamed:@"imgCmdEditNormal.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"imgCmdEditDisabled.png"] forState:UIControlStateDisabled];
        [btn setImage:[UIImage imageNamed:@"imgCmdEditActive.png"] forState:UIControlStateHighlighted];
        
        [self addSubview:btn];
        
        frame.origin.x += cmdWidth;
    }
    
    if (self.hasCloseButton){
        // TODO: create close button
    }
}

-(void)reset{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    stringEditMode = NO;
    
    // TODO: not reset these fields
    btnCancelStringEdit = nil;
    btnConfirmStringEdit = nil;
    stringEditor = nil;
}

-(void)switchStringEditView:(BOOL)editMode{
    if (stringEditMode == editMode){
        return;
    }
    
    if (editMode){
        [self createStringEditorControls];
    }
    
    [self.subviews makeObjectsPerformSelector:@selector(setHiddenWithNumber:) withObject:[NSNumber numberWithBool:editMode]];
    
    btnCancelStringEdit.hidden = !editMode;
    btnConfirmStringEdit.hidden = !editMode;
    stringEditor.hidden = !editMode;
    
    stringEditMode = editMode;
}

-(void)createStringEditorControls{
    // cancel button
    if (!btnCancelStringEdit){
        CGRect cancelBtnFrame = CGRectMake([self getCancelButtonX], SIDE_PADDING, [self getCancelConfirmButtonsWidth], [self getOneCommandHeight]);
        btnCancelStringEdit = [[UIButton alloc] initWithFrame:cancelBtnFrame];
        [btnCancelStringEdit addTarget:self action:@selector(onCancelEditButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnCancelStringEdit.backgroundColor = [UIColor lightGrayColor];
        
        // images
        btnCancelStringEdit.imageView.contentMode = UIViewContentModeCenter;
        [btnCancelStringEdit setImage:[UIImage imageNamed:@"imgCmdCancelNormal.png"] forState:UIControlStateNormal];
        [btnCancelStringEdit setImage:[UIImage imageNamed:@"imgCmdCancelActive.png"] forState:UIControlStateHighlighted];
        
        // ready
        [self addSubview:btnCancelStringEdit];
    }
    
    // text edit
    if (!stringEditor){
        CGRect editorFrame = CGRectMake([self getStringEditorX], SIDE_PADDING, [self getStringEditorWidth], [self getOneCommandHeight]);
        stringEditor = [[UITextField alloc] initWithFrame:editorFrame];
        stringEditor.clearButtonMode = UITextFieldViewModeWhileEditing;
        stringEditor.backgroundColor = [UIColor clearColor];
        
        if (NO == [self.delegatingSkin getAllowsEmptyContentText]){
            [stringEditor addTarget:self action:@selector(onTextChanged:) forControlEvents:UIControlEventEditingChanged];
        }
        
        [self addSubview:stringEditor];
    }
    
    // confirm button
    if (!btnConfirmStringEdit){
        CGRect confirmBtnFrame = CGRectMake([self getConfirmButtonX], SIDE_PADDING, [self getCancelConfirmButtonsWidth], [self getOneCommandHeight]);
        btnConfirmStringEdit = [[UIButton alloc] initWithFrame:confirmBtnFrame];
        [btnConfirmStringEdit addTarget:self action:@selector(onConfirmEditButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnConfirmStringEdit.backgroundColor = [UIColor lightGrayColor];
        
        // images
        btnConfirmStringEdit.imageView.contentMode = UIViewContentModeCenter;
        [btnConfirmStringEdit setImage:[UIImage imageNamed:@"imgCmdOkNormal.png"] forState:UIControlStateNormal];
        [btnConfirmStringEdit setImage:[UIImage imageNamed:@"imgCmdOkDisabled.png"] forState:UIControlStateDisabled];
        [btnConfirmStringEdit setImage:[UIImage imageNamed:@"imgCmdOkActive.png"] forState:UIControlStateHighlighted];
        
        // ready
        [self addSubview:btnConfirmStringEdit];
    }
}

#pragma mark Control dimentions

-(CGFloat)getOneCommandWidth{
    int actCmds = 0;
    if (skinCommands.canCmdInvertColors){
        actCmds++;
    }
    if (skinCommands.canCmdEditText){
        actCmds++;
    }
    return (self.bounds.size.width - 2 * SIDE_PADDING) / actCmds;
}

-(CGFloat)getOneCommandHeight{
    return self.bounds.size.height - 2 * SIDE_PADDING;
}

-(CGFloat)getStringEditorX{
    return SIDE_PADDING + [self getCancelConfirmButtonsWidth] + BTNS_EDITOR_MARGIN;
}

-(CGFloat)getStringEditorWidth{
    return self.bounds.size.width - 2 * SIDE_PADDING - 2 * BTNS_EDITOR_MARGIN - 2 * [self getCancelConfirmButtonsWidth];
}

-(CGFloat)getCancelConfirmButtonsWidth{
    return 50.0;
}

-(CGFloat)getCancelButtonX{
    return SIDE_PADDING;
}

-(CGFloat)getConfirmButtonX{
    return self.bounds.size.width - SIDE_PADDING - [self getCancelConfirmButtonsWidth];
}

#pragma mark Event handlers

-(IBAction)onCommandInvertPressed:(UIButton*)sender{
    [self.delegatingSkin onCmdInvertColors];
}

-(IBAction)onCommandEditTextPressed:(UIButton*)sender{
    [self switchStringEditView:YES];
    
    stringEditor.text = [self.delegatingSkin getSkinContentText];
    [stringEditor becomeFirstResponder];
}

-(IBAction)onCancelEditButtonPressed:(id)sender{
    [self switchStringEditView:NO];
    stringEditor.text = @"";
    [stringEditor resignFirstResponder];
}

-(IBAction)onConfirmEditButtonPressed:(id)sender{
    [self.delegatingSkin onCmdEditText:stringEditor.text];
    [self onCancelEditButtonPressed:btnCancelStringEdit];
}

- (IBAction)onTextChanged:(id)sender {
    btnConfirmStringEdit.enabled = stringEditor.text.length > 0;
}

#pragma mark -

-(void)setDelegatingSkin:(SkinViewBase *)delegatingSkin{
    skinCommands = [delegatingSkin getSkinCommands];
    _delegatingSkin = delegatingSkin;
    
    [self rebuildView];
}

@end
