//
//  AutosVC.h
//  InstaCar
//
//  Created by VRS on 9/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface AutosVC : UIViewController <UITableViewDelegate,
                                       UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableAutos;

@end
