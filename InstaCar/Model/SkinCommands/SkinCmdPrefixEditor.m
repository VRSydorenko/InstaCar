//
//  SkinCmdPrefixEditor.m
//  InstaCar
//
//  Created by VRS on 20/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinCmdPrefixEditor.h"

@implementation SkinCmdPrefixEditor

-(void)prepare{
    self.txtText.text = [self.delegate getSkinPrefixText];
}

-(NSString*)getTitle{
    return @"Prefix";
}

- (IBAction)onBtnConfirm:(id)sender {
    [self.delegate onCmdEditPrefix:self.txtText.text];
    [self.container skinCommandOnExecuted];
}

- (IBAction)onTextChanged:(id)sender {
    // suppress base implementation
}

@end
