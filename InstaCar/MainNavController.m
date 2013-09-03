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
#import "AppMenuTableVC.h"
#import "LocationsVC.h"

@interface MainNavController ()

@end

@implementation MainNavController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSelectionChangeDelegate = nil;
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu_icon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showAppMenuButtonPressed)];
    UIViewController *topController = [self.viewControllers objectAtIndex:0];
    topController.navigationItem.leftBarButtonItem = button;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setSideViewController:(SideView)sideView andShowOnTheLeftSide:(BOOL)isLeft{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[UIApplication sharedApplication].delegate).menuController;
    if (!menuController){
        return;
    }
    
    NSString *sideViewId = @"";
    
    switch (sideView) {
        case APP_MENU:{
            sideViewId = @"appMenuTableVC";
            break;
        }
        case LOCATIONS:{
            sideViewId = @"locationsVC";
            break;
        }
        case SKINS:{
            sideViewId = @"skinsVC";
            //sideViewId = @"rightNavCon";
            break;
        }
    }
    
    SideViewControllerBase *sideController = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:sideViewId];
    sideController.sideActionDelegate = self;
    
    if (isLeft){
        menuController.leftViewController = sideController;
        [menuController showLeftController:YES];
    } else {
        menuController.rightViewController = sideController;
        [menuController showRightController:YES];
    }
}

-(void)showAppMenuButtonPressed{
    [self setSideViewController:APP_MENU andShowOnTheLeftSide:YES];
}

-(void)showLeft{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
}

-(void)showRight{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showRightController:YES];
}

#pragma mark - SideActionProtocol methods

-(void) performSideAction:(SideAction)action withArgument:(id)object{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showRootController:YES];
}

@end
