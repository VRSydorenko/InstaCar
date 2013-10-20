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
#import "DataManager.h"
#import "ProInfoVC.h"

@interface MainNavController (){
    SideViewControllerBase *sideViewController;
}

@end

@implementation MainNavController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSelectionChangeDelegate = nil;
    
    [self initLeftBarButton];
    [self initRightBarButton];
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

-(void)showAboutProVersionButtonPressed{
    ProInfoVC *infoVC = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"proInfoVC"];
    
    infoVC.delegate = self;
    [self presentViewController:infoVC animated:YES completion:nil];
}

-(void)showLeft{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
}

-(void)showRight{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showRightController:YES];
}

#pragma mark Location update delegate

// should get this notification when Location view is null (has not been opened or has been destroyed)
-(void)locationDidUpdate{
    [self performSideAction:ACT_UPDATE_SKINS_LOCATION withArgument:[DataManager getSelectedVenue] hidingSideController:NO];
}

#pragma mark SideActionProtocol methods

-(void) performSideAction:(SideAction)action withArgument:(id)object hidingSideController:(BOOL)hiding{
    if (hiding){
        DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
        [menuController showRootController:YES];
    }
    
    switch (action) {
        case ACT_LOAD_NEW_SKINSET:
            [self.dataSelectionChangeDelegate selectedData:SKIN_SET changedTo:object];
            break;
        case ACT_UPDATE_SKINS_LOCATION:
            [self.dataSelectionChangeDelegate selectedData:LOCATION changedTo:object];
            break;
        case ACT_OPEN_INSTA_SELF_PROFILE:{
            NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=instacarapp"];
            if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
                [[UIApplication sharedApplication] openURL:instagramURL];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You do not have Instagram App installed. Do you want to download it now?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alert show];
            }
            break;
        }
        case ACT_OPEN_INSTA_SELF_TAG:{
            NSURL *instagramURL = [NSURL URLWithString:@"instagram://tag?name=instacarapp"];
            if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
                [[UIApplication sharedApplication] openURL:instagramURL];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You do not have Instagram App installed. Do you want to download it now?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alert show];
            }
            break;
        }
        case ACT_OPEN_FB_PAGE:{
            [Utils openAppPageOnFacebook];
            break;
        }
        case ACT_OPEN_APPSTORE_TO_RATE:{
            [Utils openAppInAppStore:[DataManager isFullVersion]];
            break;
        }
        case ACT_PREPARE_FEEDBACK_MAIL:{
            if ([MFMailComposeViewController canSendMail]){
                MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                
                picker.mailComposeDelegate = self;
                picker.Subject = @"InstaCar feedback";
                // TODO: change email address
                picker.toRecipients = [NSArray arrayWithObject:@"viktor.sydorenko@gmail.com"];
                NSString *messageBody = [object isKindOfClass:[NSString class]] ? (NSString*)object : @"";
                [picker setMessageBody:messageBody isHTML:NO];

                [self presentViewController:picker animated:YES completion:NULL];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Device not configured to send mail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark Mail composer delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [controller dismissViewControllerAnimated:YES completion:^(void){
        if (result == MFMailComposeResultSent){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Thank you so much for your feedback!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    // 0 is OK
    // 1 is Yes about downloading Instagram
    if (buttonIndex == 1){
        NSString* url = @"itms-apps://itunes.apple.com/app/id389801252"; // Instargam app
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
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

#pragma mark Info view delegate

-(void)proInfoViewFinished:(ProInfoVC *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark private methods

-(void)initLeftBarButton{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu_icon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showAppMenuButtonPressed)];
    button.TintColor = [UIColor whiteColor];
    UIViewController *topController = [self.viewControllers objectAtIndex:0];
    topController.navigationItem.leftBarButtonItem = button;
}

-(void)initRightBarButton{
    if (NO == [DataManager isFullVersion]){
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:/*@"nav_about_pro_icon.png"*/@"nav_menu_icon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showAboutProVersionButtonPressed)];
        button.TintColor = [UIColor whiteColor];
        UIViewController *topController = [self.viewControllers objectAtIndex:0];
        topController.navigationItem.rightBarButtonItem = button;
    }
}

@end
