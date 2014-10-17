//
//  ProInfoVC.h
//  InstaCar
//
//  Created by VRS on 10/19/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProInfoVC;

@protocol ProInfoViewControllerDelegate <NSObject>
-(void)proInfoViewFinished:(ProInfoVC*)controller;
@end

@interface ProInfoVC : UIViewController

@property UIViewController<ProInfoViewControllerDelegate> *delegate;

- (IBAction)btnClosePressed:(id)sender;
- (IBAction)btnGetProPressed:(id)sender;

@end
