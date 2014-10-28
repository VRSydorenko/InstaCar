//
//  SkinCmdTextEditor.m
//  InstaCar
//
//  Created by VRS on 18/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinCmdTextEditor.h"

@implementation SkinCmdTextEditor

-(id)init{
    self = [SkinCmdTextEditor loadFromNib];
    if (nil == self){
        self = [super init];
    }
    if (self){
        sizeInitialized = NO;
        self.editorMode = EDITORMODE_TEXT;
    }
    return self;
}

+(instancetype)loadFromNib{
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"SkinCmdUITextEditor" owner:self options:nil];
    assert(bundle);
    
    return [bundle objectAtIndex:0];
}

-(BOOL)isPro{
    return YES;
}

-(UIView*)getCmdView{
    assert(self.delegate);
    assert(self.container);
    
    return self;
}

-(void)cmdViewShown{
    [self.txtText becomeFirstResponder];
}

-(void)execute{
    assert(false);
}

-(void)prepare{
    switch (self.editorMode) {
        case EDITORMODE_PREFIX:
            self.txtText.text = [self.delegate getSkinPrefixText];
            break;
            
        case EDITORMODE_TEXT:
            self.txtText.text = [self.delegate getSkinContentText];
            break;
    }
}

-(UIImage*)getIcon{
    return [UIImage imageNamed:@"imgCmdEdit"];
}

-(NSString*)getTitle{
    switch (self.editorMode) {
        case EDITORMODE_PREFIX: return @"Prefix";
        case EDITORMODE_TEXT: return @"Text";
    }
    
    return @"Text"; // default
}

- (IBAction)onBtnCancel:(id)sender {
    [self.container skinCommandOnExecuted];
}

- (IBAction)onBtnConfirm:(id)sender {
    switch (self.editorMode) {
        case EDITORMODE_PREFIX:
            [self.delegate onCmdEditPrefix:self.txtText.text];
            break;
        case EDITORMODE_TEXT:
            [self.delegate onCmdEditText:self.txtText.text];
            break;
    }
    
    [self.txtText resignFirstResponder];
    [self.container skinCommandOnExecuted];
}

- (IBAction)onTextChanged:(id)sender {
    if (self.editorMode == EDITORMODE_TEXT){
        self.btnConfirm.enabled = [self.delegate getAllowsEmptyContentText] || self.txtText.text.length > 0;
    }
}

-(void)layoutSubviews{
    if (YES == sizeInitialized){
        [super layoutSubviews];
        return;
    }
    
    self.constraintBtnCancelWidth.constant = self.bounds.size.height; // TODO: don't update it
    self.constraintbtnConfirmWidth.constant = self.bounds.size.height;
    
    CGFloat margin = (0.5 /*50%*/ * self.bounds.size.height) / 2;
    self.btnConfirm.imageEdgeInsets = UIEdgeInsetsMake(margin, margin, margin, margin);
    self.btnDecline.imageEdgeInsets = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    sizeInitialized = YES;
    
    [super layoutSubviews];
}
@end
