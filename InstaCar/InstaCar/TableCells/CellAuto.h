//
//  CellAuto.h
//  InstaCar
//
//  Created by VRS on 9/3/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellAuto : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *autoTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *autoLogo;
@property (nonatomic, weak) IBOutlet UIButton *autoModelsButton;

@end
