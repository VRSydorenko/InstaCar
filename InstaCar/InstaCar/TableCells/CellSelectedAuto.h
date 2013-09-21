//
//  CellSelectedAuto.h
//  InstaCar
//
//  Created by VRS on 9/3/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellSelectedAuto : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *autoTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *autoLogo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMainTextWidth;

@end
