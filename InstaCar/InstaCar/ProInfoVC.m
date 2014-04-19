//
//  ProInfoVC.m
//  InstaCar
//
//  Created by VRS on 10/19/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "ProInfoVC.h"

@interface ProInfoVC ()
@end

@implementation ProInfoVC

- (IBAction)btnClosePressed:(id)sender {
    if (self.delegate){
        [self.delegate proInfoViewFinished:self];
    }
}

- (IBAction)btnGetProPressed:(id)sender {
    NSString *url = @"itms-apps://itunes.apple.com/app/id726603505";
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

@end
