//
//  SkinCommandsPopoverView.m
//  InstaCar
//
//  Created by VRS on 15/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinCommandsView.h"
#import "SkinCommandProvider.h"
#import "SkinCmdNoCommands.h"

@implementation SkinCommandsView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self reset];
    }
    return self;
}

-(void)rebuildView{
    [self reset];
    
    int cmdCount = [self.delegatingSkin getSkinCommands].count;
    
    [self setCommandLenghts:[self getOneCommandWidth] forFirst:cmdCount];
    
    for (int cmdNdx = 0; cmdNdx < cmdCount; cmdNdx++) {
        NSArray *commands = [self.delegatingSkin getSkinCommands];
        assert(commands.count > 0);
        NSNumber *cmdId = [commands objectAtIndex:cmdNdx];
        assert(cmdId);
        SkinCommand *command = [[SkinCommandProvider getInstance] getCommand:cmdId];
        assert(command);
        
        UIButton *btn = [self getButtonForCommand:cmdNdx];
        btn.enabled = YES;
        
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
        
        if ([command isPro] && NO == [UserSettings isFullVersion]){
            [btn setImage:[[UIImage imageNamed:@"imgBadgePro.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        } else {
            [btn setImage:[[command getIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
        
        btn.hidden = NO;
    }
    
    self.cmdContainerView.hidden = NO;
}

-(void)setCommandLenghts:(CGFloat)width forFirst:(int)commandsNumber{
    self.constraintCmd1Width.constant = commandsNumber >= 1 ? width : 0;
    self.constraintCmd2Width.constant = commandsNumber >= 2 ? width : 0;
    self.constraintCmd3Width.constant = commandsNumber >= 3 ? width : 0;
    self.constraintCmd4Width.constant = commandsNumber >= 4 ? width : 0;
    self.constraintCmd5Width.constant = commandsNumber >= 5 ? width : 0;
}

-(UIButton*)getButtonForCommand:(int)cmdIndex{
    assert(cmdIndex >= 0 && cmdIndex < [self.delegatingSkin getSkinCommands].count);
    
    switch (cmdIndex) {
        case 0: return self.btnCmd1;
        case 1: return self.btnCmd2;
        case 2: return self.btnCmd3;
        case 3: return self.btnCmd4;
        case 4: return self.btnCmd5;
    }
    
    return nil;
}

-(BOOL)isInEditMode{
    return isEditMode;
}

-(CGFloat)heightOnTop{
    if ([UserSettings isIPhone5]){
        return HEIGHT_ON_TOP_IPHONE5;
    }
    
    if ([UserSettings isIPhone6]){
        return HEIGHT_ON_TOP_IPHONE6;
    }
    
    if ([UserSettings isIPhone6plus]){
        return HEIGHT_ON_TOP_IPHONE6PLUS;
    }
    
    return HEIGHT_ON_TOP_IPHONE4;
}

-(void)reset{
    // remove everything except the cmd container
    for (UIView* subview in self.subviews) {
        if (NO == [subview isEqual:self.cmdContainerView]){
            [subview removeFromSuperview];
        }
    }
    
    // make commands hidden
    //[self.cmdContainerView.subviews makeObjectsPerformSelector:@selector(setHiddenWithNumber:) withObject:[NSNumber numberWithBool:YES]];
    self.cmdContainerView.hidden = YES;
    
    isEditMode = NO;
}

-(void)switchToCommandView:(UIView*)cmdView{
    if ([cmdView isEqual:self.cmdContainerView]){
        [self rebuildView];
    } else {
        [self reset];
        
        cmdView.frame = self.bounds;
        [self addSubview:cmdView];
    }
}

#pragma mark Control dimentions

-(CGFloat)getOneCommandWidth{
    return self.bounds.size.width / [self.delegatingSkin getSkinCommands].count;
}

#pragma mark Event handlers

-(IBAction)onCommandPressed:(UIButton*)sender{
    assert(sender.tag >= 0 && sender.tag < [self.delegatingSkin getSkinCommands].count);
    
    NSNumber *cmdId = [[self.delegatingSkin getSkinCommands] objectAtIndex:sender.tag];
    assert(cmdId);
    SkinCommand *command = [[SkinCommandProvider getInstance] getCommand:cmdId];
    assert(command);
    [command prepare];
    
    UIView *cmdView = [command getCmdView];
    
    if (cmdView != nil){
        [self switchToCommandView:cmdView];
        [command cmdViewShown];
    } else {
        [command execute];
    }
}

-(void)skinCommandOnExecuted{
    [self rebuildView];
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
    btn.backgroundColor = [UIColor lightGrayColor];
    
    [btn centerButtonAndImageWithSpacing:3.0];
}

-(void)layoutSubviews{
    [super layoutSubviews];

    CGRect rect = self.bounds;
    for (UIView* subview in self.subviews) {
        if (NO == [subview isEqual:self.cmdContainerView]){
            subview.frame = rect;
        }
    }
}

@end
