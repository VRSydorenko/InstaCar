//
//  AppMenuTableVC.h
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SideViewControllerBase.h"

#define INSTACARAPP_TAG @"#instacarapp"
#define INSTACARAPP_USER @"@instacarapp"
#define LIKE_IT @"Like it"
#define RATE_APP @"Rate App"
#define CONTACT_US @"Contact us"

@interface AppMenuTableVC : SideViewControllerBase <UITableViewDelegate,
                                                    UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableAppMenu;
- (IBAction)btnClosePressed:(id)sender;

@end
