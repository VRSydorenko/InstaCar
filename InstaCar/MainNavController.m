//
//  MainNavController.m
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "MainNavController.h"
#import "DDMenuController.h"
#import "AppDelegate.h"

@interface MainNavController ()

@end

@implementation MainNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SideActionProtocol methods

-(void) performSideAction:(SideAction)action{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showRootController:YES];
}

@end
