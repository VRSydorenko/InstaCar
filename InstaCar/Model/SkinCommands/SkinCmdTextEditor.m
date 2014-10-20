//
//  SkinCmdTextEditor.m
//  InstaCar
//
//  Created by VRS on 18/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinCmdTextEditor.h"

@implementation SkinCmdTextEditor

-(BOOL)isPro{
    return YES;
}

-(UIView*)getCmdView{
    assert(self.delegate);
    assert(self.container);
    
    return self;
}

-(void)execute{
    assert(false);
}

-(void)prepare{
    self.txtText.text = [self.delegate getSkinContentText];
}

-(UIImage*)getIcon{
    return [UIImage imageNamed:@"imgCmdEditNormal@2x.png"]; // TODO: use name w/o scale factor
}

-(NSString*)getTitle{
    return @"Text";
}

- (IBAction)onBtnCancel:(id)sender {
    [self.container skinCommandOnExecuted];
}

- (IBAction)onBtnConfirm:(id)sender {
    [self.delegate onCmdEditText:self.txtText.text];
    [self.container skinCommandOnExecuted];
}

- (IBAction)onTextChanged:(id)sender {
    self.btnConfirm.enabled = [self.delegate getAllowsEmptyContentText] || self.txtText.text.length > 0;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.constraintBtnCancelWidth.constant = self.bounds.size.height;
    self.constraintbtnConfirmWidth.constant = self.bounds.size.height;
}
@end
