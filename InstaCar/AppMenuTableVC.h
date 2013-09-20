//
//  AppMenuTableVC.h
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SideViewControllerBase.h"

@interface AppMenuTableVC : SideViewControllerBase <UITableViewDelegate,
                                                    UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableAppMenu;
- (IBAction)btnClosePressed:(id)sender;

@end
