//
//  SubmodelsVC.h
//  InstaCar
//
//  Created by VRS on 9/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@protocol SubmodelSelectorDelegate <NSObject>
-(void)newSubmodelSelected:(AutoSubmodel*)newSubmodel;
@end

@interface SubmodelsVC : UIViewController <UITableViewDelegate,
                                          UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableSubmodels;
@property id<SubmodelSelectorDelegate> submodelSelectorDelegate;
@property int modelId;

@end
