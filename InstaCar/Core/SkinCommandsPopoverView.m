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
    
    if (0 == [self getNumberOfActiveCommands]){ // no commands available for current skin
        UIButton *btn = [[UIButton alloc] initWithFrame:frame];
        btn.enabled = NO;
        [self setCmdButtonCommonValues:&btn];
        
        // title
        [btn setTitle:@"No actions" forState:UIControlStateNormal];
        [btn setTitle:@"No actions" forState:UIControlStateDisabled];
        // images
        [btn setImage:[UIImage imageNamed:@"imgCmdNoActionsDisabled.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"imgCmdNoActionsDisabled.png"] forState:UIControlStateDisabled];
        
        [self addSubview:btn];
    } else {
        if (skinCommands.canCmdInvertColors){
            UIButton *btn = [[UIButton alloc] initWithFrame:frame];
            [self setCmdButtonCommonValues:&btn];
            
            [btn addTarget:self action:@selector(onCommandInvertPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            // title
            [btn setTitle:@"Invert colors" forState:UIControlStateNormal];
            // images
            [btn setImage:[UIImage imageNamed:@"imgCmdInvertNormal.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"imgCmdInvertActive.png"] forState:UIControlStateHighlighted];
            
            [self addSubview:btn];
            frame.origin.x += cmdWidth;
        }
        
        if (skinCommands.canCmdEditText){
            UIButton *btn = [[UIButton alloc] initWithFrame:frame];
            [self setCmdButtonCommonValues:&btn];
            [btn addTarget:self action:@selector(onCommandEditTextPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setTitle:@"Edit text" forState:UIControlStateNormal];
            
            // images
            [btn setImage:[UIImage imageNamed:@"imgCmdEditNormal.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"imgCmdEditDisabled.png"] forState:UIControlStateDisabled];
            [btn setImage:[UIImage imageNamed:@"imgCmdEditActive.png"] forState:UIControlStateHighlighted];
            
            [self addSubview:btn];
            frame.origin.x += cmdWidth;
        }
        
        if (skinCommands.canCmdEditPrefix){
            UIButton *btn = [[UIButton alloc] initWithFrame:frame];
            [self setCmdButtonCommonValues:&btn];
            [btn addTarget:self action:@selector(onCommandEditPrefixPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setTitle:@"Edit prefix" forState:UIControlStateNormal];
            
            // images // TODO: icons for prefix
            [btn setImage:[UIImage imageNamed:@"imgCmdEditNormal.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"imgCmdEditDisabled.png"] forState:UIControlStateDisabled];
            [btn setImage:[UIImage imageNamed:@"imgCmdEditActive.png"] forState:UIControlStateHighlighted];
            
            [self addSubview:btn];
            frame.origin.x += cmdWidth;
        }
    }
    
    if (self.hasCloseButton){
        // TODO: create close button
    }
}

-(BOOL)isInEditMode{
    return stringEditMode;
}

-(CGFloat)heightOnTop{
    return HEIGHT_ON_TOP;
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
    stringEditMode = editMode;
    
    if (editMode){
        [self createStringEditorControls];
    }
    
    [self.subviews makeObjectsPerformSelector:@selector(setHiddenWithNumber:) withObject:[NSNumber numberWithBool:editMode]];
    
    btnCancelStringEdit.hidden = !editMode;
    btnConfirmStringEdit.hidden = !editMode;
    stringEditor.hidden = !editMode;
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
        
        stringEditor.autocorrectionType = UITextAutocorrectionTypeNo;
        
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
    return (self.bounds.size.width - 2 * SIDE_PADDING) / MAX(1 /*No Actions*/, [self getNumberOfActiveCommands]);
}

-(CGFloat)getOneCommandHeight{
    return (stringEditMode ? HEIGHT_ON_TOP : self.bounds.size.height) - 2 * SIDE_PADDING;
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
    currentlyEditingPrefix = NO;
    [stringEditor becomeFirstResponder];
}
-(IBAction)onCommandEditPrefixPressed:(UIButton*)sender{
    [self switchStringEditView:YES];
    
    stringEditor.text = [self.delegatingSkin getSkinPrefixText];
    currentlyEditingPrefix = YES;
    [stringEditor becomeFirstResponder];
}

-(IBAction)onCancelEditButtonPressed:(id)sender{
    [self switchStringEditView:NO];
    stringEditor.text = @"";
    [stringEditor resignFirstResponder];
}

-(IBAction)onConfirmEditButtonPressed:(id)sender{
    if (currentlyEditingPrefix){
        [self.delegatingSkin onCmdEditPrefix:stringEditor.text];
    } else {
        [self.delegatingSkin onCmdEditText:stringEditor.text];
    }
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

-(void)setCmdButtonCommonValues:(UIButton**)button{
    UIButton *btn = *button;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:[UIColor colorWithRed:1 green:1 blue:150/255 alpha:1.0] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:1 green:1 blue:150/255 alpha:1.0] forState:UIControlStateDisabled]; // TODO: dark the color
    [btn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateDisabled]; // TODO: dark the color
    
    btn.imageView.contentMode = UIViewContentModeCenter;
    btn.backgroundColor = [UIColor lightGrayColor];
    
    [btn centerButtonAndImageWithSpacing:3.0];
}

-(int)getNumberOfActiveCommands{
    int actCmds = 0;
    if (skinCommands.canCmdInvertColors){
        actCmds++;
    }
    if (skinCommands.canCmdEditText){
        actCmds++;
    }
    if (skinCommands.canCmdEditPrefix){
        actCmds++;
    }
    return actCmds;
}

@end
