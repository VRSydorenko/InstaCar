//
//  CellSelectedAuto.h
//  InstaCar
//
//  Created by VRS on 9/3/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellSelectedAuto : UITableViewCell

@property (nonatomic) IBOutlet UILabel *autoTitleLabel;
@property (nonatomic) IBOutlet UIImageView *autoLogo;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintMainTextWidth;

@end
