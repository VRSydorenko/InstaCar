//
//  ModelsVC.h
//  InstaCar
//
//  Created by VRS on 9/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "SubmodelsVC.h"
#import "CellAuto.h"

@protocol ModelSelectorDelegate <NSObject>
-(void)newModelSelected:(AutoModel*)newModel;
@end

@interface ModelsVC : UIViewController <UITableViewDelegate,
                                       UITableViewDataSource,
                                       SublevelPickerDelegate,
                                       SubmodelSelectorDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableModels;
@property id<ModelSelectorDelegate> modelSelectorDelegate;
@property int autoId;

@end
