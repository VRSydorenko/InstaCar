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

@interface MainNavController (){
    SideViewControllerBase *sideViewController;
}

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
            break;
        }
    }

    if (sideViewController){
        sideViewController = nil;
    }
    sideViewController = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:sideViewId];
    sideViewController.sideActionDelegate = self;
    if ([sideViewController conformsToProtocol:@protocol(DDMenuControllerDelegate)]){
        self.menuControllerDelegate = (NSObject<DDMenuControllerDelegate>*)sideViewController;
    }
    
    if (isLeft){
        menuController.leftViewController = sideViewController;
        [menuController showLeftController:YES];
    } else {
        menuController.rightViewController = sideViewController;
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
    
    switch (action) {
        case ACT_LOAD_NEW_SKINSET:
            [self.dataSelectionChangeDelegate selectedData:SKIN_SET changedTo:object];
            break;
        case ACT_UPDATE_SKINS_LOCATION:
            [self.dataSelectionChangeDelegate selectedData:LOCATION changedTo:object];
            break;
        default:
            break;
    }
}

#pragma mark DDMenuControllerDelegate

-(void)menuController:(DDMenuController *)controller willShowViewController:(UIViewController *)toShow{
    if (self.menuControllerDelegate && [self.menuControllerDelegate respondsToSelector:@selector(menuController:willShowViewController:)]){
        [self.menuControllerDelegate menuController:controller willShowViewController:toShow];
    }
}

- (void)menuControllerWillShowRootViewController{
    if (self.menuControllerDelegate && [self.menuControllerDelegate respondsToSelector:@selector(menuControllerWillShowRootViewController)]){
        [self.menuControllerDelegate menuControllerWillShowRootViewController];
    }
}

@end
