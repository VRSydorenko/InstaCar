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
        [btn addTarget:self action:@selector(onCommandInvertPressed:) forControlEvents:UIControlEventTouchDown];
        btn.backgroundColor = [UIColor lightGrayColor];
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:@"Invert colors" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self addSubview:btn];
        
        frame.origin.x += cmdWidth;
    }
    
    if (skinCommands.canCmdEditText){
        UIButton *btn = [[UIButton alloc] initWithFrame:frame];
        [btn addTarget:self action:@selector(onCommandEditTextPressed:) forControlEvents:UIControlEventTouchDown];
        btn.backgroundColor = [UIColor lightGrayColor];
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:@"Edit text" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        
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
        [btnCancelStringEdit addTarget:self action:@selector(onCancelEditButtonPressed:) forControlEvents:UIControlEventTouchDown];
        btnCancelStringEdit.backgroundColor = [UIColor lightGrayColor];
    
        btnCancelStringEdit.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnCancelStringEdit setTitle:@"Cancel" forState:UIControlStateNormal];
        [btnCancelStringEdit setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btnCancelStringEdit setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];

        [self addSubview:btnCancelStringEdit];
    }
    // text edit
    if (!stringEditor){
        CGRect editorFrame = CGRectMake([self getStringEditorX], SIDE_PADDING, [self getStringEditorWidth], [self getOneCommandHeight]);
        stringEditor = [[UITextField alloc] initWithFrame:editorFrame];
        stringEditor.clearButtonMode = UITextFieldViewModeWhileEditing;
        stringEditor.backgroundColor = [UIColor grayColor];
        
        [self addSubview:stringEditor];
    }
    
    // confirm button
    if (!btnConfirmStringEdit){
        CGRect confirmBtnFrame = CGRectMake([self getConfirmButtonX], SIDE_PADDING, [self getCancelConfirmButtonsWidth], [self getOneCommandHeight]);
        btnConfirmStringEdit = [[UIButton alloc] initWithFrame:confirmBtnFrame];
        [btnConfirmStringEdit addTarget:self action:@selector(onConfirmEditButtonPressed:) forControlEvents:UIControlEventTouchDown];
        btnConfirmStringEdit.backgroundColor = [UIColor lightGrayColor];
        
        btnConfirmStringEdit.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnConfirmStringEdit setTitle:@"OK" forState:UIControlStateNormal];
        [btnConfirmStringEdit setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btnConfirmStringEdit setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        
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

#pragma mark -

-(void)setDelegatingSkin:(SkinViewBase *)delegatingSkin{
    skinCommands = [delegatingSkin getSkinCommands];
    _delegatingSkin = delegatingSkin;
    
    [self rebuildView];
}

@end
