//
//  AutosVC.h
//  InstaCar
//
//  Created by VRS on 9/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@protocol AutoSelectorDelegate <NSObject>
-(void)newAutoSelected:(Auto*)newAuto;
@end

@interface AutosVC : UIViewController <UITableViewDelegate,
                                       UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableAutos;
@property id<AutoSelectorDelegate> autoSelectorDelegate;

@end
