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

@property (nonatomic) IBOutlet UITableView *tableSelectedData;

- (IBAction)btnClosePressed:(id)sender;

@end
