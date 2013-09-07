//
//  SkinsVC.h
//  InstaCar
//
//  Created by VRS on 9/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SideViewControllerBase.h"
#import "DataManager.h"
#import "SkinViewBase.h"
#import "AutosVC.h"

@interface SkinsVC : SideViewControllerBase <UITableViewDelegate,
                                             UITableViewDataSource,
                                             DDMenuControllerDelegate,
                                             AutoSelectorDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableSets;
@property (weak, nonatomic) IBOutlet UITableView *tableSelectedAuto;
- (IBAction)btnClosePressed:(id)sender;

@end
