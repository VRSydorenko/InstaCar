//
//  SkinCommandsPopoverView.m
//  InstaCar
//
//  Created by VRS on 15/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinCommandsPopoverView.h"
#import "SkinCommandProvider.h"
#import "SkinCmdNoCommands.h"

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
    
    for (NSNumber *cmdId in [self.delegatingSkin getSkinCommands]) {
        SkinCommand *command = [[SkinCommandProvider getInstance] getCommand:cmdId];
        assert(command);
        
        UIButton *btn = [[UIButton alloc] initWithFrame:frame];
        // no commands button has some other settings
        if ([command isKindOfClass:[SkinCmdNoCommands class]]){
            btn.enabled = NO;
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
            [btn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateDisabled]; // TODO: dark the color
        }
        [self setCmdButtonCommonValues:&btn];
        [btn setTitle:[command getTitle] forState:UIControlStateNormal];
        
        command.delegate = self.delegatingSkin;
        command.container = self;
        [btn addTarget:self action:@selector(onCommandPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([command isPro] && NO == [UserSettings isFullVersion]){
            [btn setImage:[UIImage imageNamed:@"imgBadgePro.png"] forState:UIControlStateNormal];
        } else {
            [btn setImage:[command getIcon] forState:UIControlStateNormal];
        }
        
        [self addSubview:btn];
        frame.origin.x += cmdWidth;
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
}

-(void)switchStringEditView:(BOOL)editMode raitingSubMode:(BOOL)raitingSubMode{
    if (isEditMode == editMode){
        return;
    }
    isEditMode = editMode;
    
    if (editMode){
        //[self createStringEditorControls:raitingSubMode];
    }
    
    [self.subviews makeObjectsPerformSelector:@selector(setHiddenWithNumber:) withObject:[NSNumber numberWithBool:editMode]];
}

#pragma mark Control dimentions

-(CGFloat)getOneCommandWidth{
    return (self.bounds.size.width - 2 * SIDE_PADDING) / [self.delegatingSkin getSkinCommands].count;
}

-(CGFloat)getOneCommandHeight{
    return (isEditMode ? HEIGHT_ON_TOP : self.bounds.size.height) - 2 * SIDE_PADDING;
}

#pragma mark Event handlers

-(IBAction)onCommandPressed:(UIButton*)sender{
    // TODO:
}

-(void)skinCommandOnExecuted{
    // TODO:
}

#pragma mark -

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

@end
