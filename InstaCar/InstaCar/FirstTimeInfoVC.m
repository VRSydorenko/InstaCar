//
//  FirstTimeInfoVC.m
//  InstaCar
//
//  Created by VRS on 10/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "FirstTimeInfoVC.h"
#import "UserSettings.h"

@interface FirstTimeInfoVC ()
@end

@implementation FirstTimeInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.infoView.frame = self.view.frame;
}

-(void)viewDidAppear:(BOOL)animated{
    if ([UserSettings getHasLaunchedBefore]){
        return;
    }
    
    if ([UserSettings isIPhone6] || [UserSettings isIPhone6plus]){
        self.constraintArrowLeftTop.constant *= 2;
        self.constraintMiddleTextTop.constant *= 2;
        self.constraintArrowRightTop.constant *= 2;
    }
}

- (IBAction)didTap:(id)sender {
    if (self.delegate){
        [self.delegate firstTimeVCNeedsToDismiss:self];
    }
}
@end
