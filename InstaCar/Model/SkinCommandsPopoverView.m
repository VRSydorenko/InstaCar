//
//  SkinCommandsPopoverView.m
//  InstaCar
//
//  Created by VRS on 15/09/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinCommandsPopoverView.h"

@implementation SkinCommandsPopoverView

-(void)rebuildView{
    [self cleanUpViews];
    
    CGFloat cmdWidth = [self getOneCommandWidth];
    CGFloat cmdHeight = self.bounds.size.height - 10.0;
    
    CGRect frame = CGRectMake(5.0, 5.0, cmdWidth, cmdHeight);
    
    if (skinCommands.canCmdInvertColors){
        UIButton *btn = [[UIButton alloc] initWithFrame:frame];
        [btn addTarget:self action:@selector(onCommandButtonPressed:) forControlEvents:UIControlEventTouchDown];
        btn.backgroundColor = [UIColor lightGrayColor];
        btn.titleLabel.textColor = [UIColor blueColor];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.text = @"Invert";
        
        [self addSubview:btn];
        
        frame.origin.x += cmdWidth;
    }
    
    if (self.hasCloseButton){
        // TODO: create close button
    }
}

-(void)cleanUpViews{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)startStringEditView{
}

-(void)stopStringEditView{
}

-(CGFloat)getOneCommandWidth{
    int actCmds = 0;
    if (skinCommands.canCmdInvertColors){
        actCmds++;
    }
    return (self.bounds.size.width - 10.0) / actCmds;
}

-(IBAction)onCommandButtonPressed:(UIButton*)sender{
    [self.delegatingSkin onCmdInvertColors];
}

-(void)setDelegatingSkin:(SkinViewBase *)delegatingSkin{
    skinCommands = [delegatingSkin getSkinCommands];
    _delegatingSkin = delegatingSkin;
    
    [self rebuildView];
}

@end
