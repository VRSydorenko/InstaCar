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
        // colors
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        [btn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateDisabled]; // TODO: dark the color
        
        // title
        [btn setTitle:@"No actions" forState:UIControlStateNormal];
        
        // images
        [btn setImage:[UIImage imageNamed:@"imgCmdNoActionsDisabled.png"] forState:UIControlStateNormal];
        
        [self addSubview:btn];
    } else {
        if (skinCommands.canCmdInvertColors){
            UIButton *btn = [[UIButton alloc] initWithFrame:frame];
            [self setCmdButtonCommonValues:&btn];
            
            [btn addTarget:self action:@selector(onCommandInvertPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            // title
            [btn setTitle:@"Invert" forState:UIControlStateNormal];
            // images
            [btn setImage:[UIImage imageNamed:@"imgCmdInvertNormal.png"] forState:UIControlStateNormal];
            
            [self addSubview:btn];
            frame.origin.x += cmdWidth;
        }
        
        if (skinCommands.canCmdEditPrefix){
            UIButton *btn = [[UIButton alloc] initWithFrame:frame];
            [self setCmdButtonCommonValues:&btn];
            [btn addTarget:self action:@selector(onCommandEditPrefixPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setTitle:@"Prefix" forState:UIControlStateNormal];
            
            // images // TODO: icons for prefix
            if ([UserSettings isFullVersion]){
                [btn setImage:[UIImage imageNamed:@"imgCmdEditNormal.png"] forState:UIControlStateNormal];
            } else {
                [btn setImage:[UIImage imageNamed:@"imgBadgePro.png"] forState:UIControlStateNormal];
            }
            
            [self addSubview:btn];
            frame.origin.x += cmdWidth;
        }
        
        if (skinCommands.canCmdEditText){
            UIButton *btn = [[UIButton alloc] initWithFrame:frame];
            [self setCmdButtonCommonValues:&btn];
            [btn addTarget:self action:@selector(onCommandEditTextPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setTitle:@"Text" forState:UIControlStateNormal];
            
            // images
            if ([UserSettings isFullVersion]){
                [btn setImage:[UIImage imageNamed:@"imgCmdEditNormal.png"] forState:UIControlStateNormal];
            } else {
                [btn setImage:[UIImage imageNamed:@"imgBadgePro.png"] forState:UIControlStateNormal];
            }
            
            [self addSubview:btn];
            frame.origin.x += cmdWidth;
        }
        
        if (skinCommands.canCmdEditRaiting){
            UIButton *btn = [[UIButton alloc] initWithFrame:frame];
            [self setCmdButtonCommonValues:&btn];
            [btn addTarget:self action:@selector(onCommandEditRaitingPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setTitle:@"Rate" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"imgCmdEditNormal.png"] forState:UIControlStateNormal];
            
            [self addSubview:btn];
            frame.origin.x += cmdWidth;
        }
    }
}

-(BOOL)isInEditMode{
    return isEditMode;
}

-(CGFloat)heightOnTop{
    return HEIGHT_ON_TOP;
}

-(void)reset{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    isEditMode = NO;
    
    // TODO: not reset these fields
    btnCancelStringEdit = nil;
    btnConfirmStringEdit = nil;
    stringEditor = nil;
    star1 = nil;
    star2 = nil;
    star3 = nil;
    star4 = nil;
    star5 = nil;
}

-(void)switchStringEditView:(BOOL)editMode raitingSubMode:(BOOL)raitingSubMode{
    if (isEditMode == editMode){
        return;
    }
    isEditMode = editMode;
    
    if (editMode){
        [self createStringEditorControls:raitingSubMode];
    }
    
    [self.subviews makeObjectsPerformSelector:@selector(setHiddenWithNumber:) withObject:[NSNumber numberWithBool:editMode]];
    
    btnCancelStringEdit.hidden = !editMode;
    btnConfirmStringEdit.hidden = !editMode;
    stringEditor.hidden = !editMode && raitingSubMode;
    star1.hidden = !editMode && !raitingSubMode;
    star2.hidden = !editMode && !raitingSubMode;
    star3.hidden = !editMode && !raitingSubMode;
    star4.hidden = !editMode && !raitingSubMode;
    star5.hidden = !editMode && !raitingSubMode;
}

-(void)createStringEditorControls:(BOOL)raitingView{
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
    
    // text edit or raiting stars
    if (raitingView){
        if (!star1){ // enough to check one button
            CGFloat oneStarWidth = [self getStringEditorWidth] / 5;
            
            CGRect starFrame = CGRectMake([self getStringEditorX], SIDE_PADDING, oneStarWidth, [self getOneCommandHeight]);
            star1 = [[UIButton alloc] initWithFrame:starFrame];
            [star1 addTarget:self action:@selector(onStarClick:) forControlEvents:UIControlEventTouchUpInside];
            star1.tag = 1;
            
            starFrame.origin.x += oneStarWidth;
            star2 = [[UIButton alloc] initWithFrame:starFrame];
            [star2 addTarget:self action:@selector(onStarClick:) forControlEvents:UIControlEventTouchUpInside];
            star2.tag = 2;
            
            starFrame.origin.x += oneStarWidth;
            star3 = [[UIButton alloc] initWithFrame:starFrame];
            [star3 addTarget:self action:@selector(onStarClick:) forControlEvents:UIControlEventTouchUpInside];
            star3.tag = 3;
            
            starFrame.origin.x += oneStarWidth;
            star4 = [[UIButton alloc] initWithFrame:starFrame];
            [star4 addTarget:self action:@selector(onStarClick:) forControlEvents:UIControlEventTouchUpInside];
            star4.tag = 4;
            
            starFrame.origin.x += oneStarWidth;
            star5 = [[UIButton alloc] initWithFrame:starFrame];
            [star5 addTarget:self action:@selector(onStarClick:) forControlEvents:UIControlEventTouchUpInside];
            star5.tag = 5;
            
            [self addSubview:star1];
            [self addSubview:star2];
            [self addSubview:star3];
            [self addSubview:star4];
            [self addSubview:star5];
        }
        
        [self updateStarsAccordingToRaiting:raiting];
    } else {
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
    return (isEditMode ? HEIGHT_ON_TOP : self.bounds.size.height) - 2 * SIDE_PADDING;
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
    if (NO == [UserSettings isFullVersion]){
        [Utils showAboutProVersionOnBehalfOf:self.ownerVC];
        return;
    }
    
    [self switchStringEditView:YES raitingSubMode:NO];
    
    stringEditor.text = [self.delegatingSkin getSkinContentText];
    currentlyEditingPrefix = NO;
    currentlyEditRaiting = NO;
    [stringEditor becomeFirstResponder];
}
-(IBAction)onCommandEditPrefixPressed:(UIButton*)sender{
    if (NO == [UserSettings isFullVersion]){
        [Utils showAboutProVersionOnBehalfOf:self.ownerVC];
        return;
    }
    
    [self switchStringEditView:YES raitingSubMode:NO];
    
    stringEditor.text = [self.delegatingSkin getSkinPrefixText];
    currentlyEditingPrefix = YES;
    currentlyEditRaiting = NO;
    [stringEditor becomeFirstResponder];
}
-(IBAction)onCommandEditRaitingPressed:(id)sender{
    raiting = [self.delegatingSkin getSkinRaiting];
    currentlyEditRaiting = YES;
    [self switchStringEditView:YES raitingSubMode:YES];
}

-(IBAction)onCancelEditButtonPressed:(id)sender{
    [self switchStringEditView:NO raitingSubMode:NO];
    stringEditor.text = @"";
    [stringEditor resignFirstResponder];
}

-(IBAction)onConfirmEditButtonPressed:(id)sender{
    if (currentlyEditRaiting){
        [self.delegatingSkin onCmdEditRaiting:raiting];
    } else if (currentlyEditingPrefix){
        [self.delegatingSkin onCmdEditPrefix:stringEditor.text];
    } else {
        [self.delegatingSkin onCmdEditText:stringEditor.text];
    }
    [self onCancelEditButtonPressed:btnCancelStringEdit];
}

- (IBAction)onTextChanged:(id)sender {
    btnConfirmStringEdit.enabled = stringEditor.text.length > 0;
}

-(IBAction)onStarClick:(id)sender{
    UIButton *starBtn = (UIButton*)sender;
    if (!starBtn)
        return;
    
    raiting = starBtn.tag;

    [self updateStarsAccordingToRaiting:raiting];
}

#pragma mark -

-(void)updateStarsAccordingToRaiting:(int)rate{
    star1.backgroundColor = rate >= star1.tag ? [UIColor orangeColor] : [UIColor grayColor];
    star2.backgroundColor = rate >= star2.tag ? [UIColor orangeColor] : [UIColor grayColor];
    star3.backgroundColor = rate >= star3.tag ? [UIColor orangeColor] : [UIColor grayColor];
    star4.backgroundColor = rate >= star4.tag ? [UIColor orangeColor] : [UIColor grayColor];
    star5.backgroundColor = rate >= star5.tag ? [UIColor orangeColor] : [UIColor grayColor];
}

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
    
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-5, -5, -5, -5)];
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
    if (skinCommands.canCmdEditRaiting){
        actCmds++;
    }
    return actCmds;
}

@end
