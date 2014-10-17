//
//  CellAuto.h
//  InstaCar
//
//  Created by VRS on 9/3/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SublevelPickerDelegate <NSObject>
-(void)sublevelButtonPressedAtIndex:(long)index;
@end

@interface CellAuto : UITableViewCell

@property (nonatomic) IBOutlet UILabel *autoTitleLabel;
@property (nonatomic) IBOutlet UILabel *autoYearsLabel;
@property (nonatomic) IBOutlet NSLayoutConstraint *constraintDetailTextHeight;

@property (nonatomic) IBOutlet UIImageView *autoLogo;
@property (nonatomic) IBOutlet UIButton *autoModelsButton;
@property id<SublevelPickerDelegate> sublevelPickerDelegate;

-(IBAction)modelsButtonPressed:(id)sender;

@end
