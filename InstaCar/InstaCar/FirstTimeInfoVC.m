//
//  FirstTimeInfoVC.m
//  InstaCar
//
//  Created by VRS on 10/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "FirstTimeInfoVC.h"

@interface FirstTimeInfoVC ()

@end

@implementation FirstTimeInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.infoView.frame = self.view.frame;
}

- (IBAction)didTap:(id)sender {
    if (self.delegate){
        [self.delegate firstTimeVCNeedsToDismiss:self];
    }
}
@end
