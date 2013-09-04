//
//  CellAuto.h
//  InstaCar
//
//  Created by VRS on 9/3/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellAuto.h"

@interface CellModel : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *modelTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *modelLogo;
@property (nonatomic, weak) IBOutlet UIButton *modelSubmodelsButton;

@property id<SublevelPickerDelegate> sublevelPickerDelegate;

-(IBAction)submodelsButtonPressed:(id)sender;


@end
