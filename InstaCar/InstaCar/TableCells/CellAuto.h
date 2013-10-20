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

@property (nonatomic, weak) IBOutlet UILabel *autoTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *autoYearsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDetailTextHeight;

@property (nonatomic, weak) IBOutlet UIImageView *autoLogo;
@property (nonatomic, weak) IBOutlet UIButton *autoModelsButton;
@property id<SublevelPickerDelegate> sublevelPickerDelegate;

-(IBAction)modelsButtonPressed:(id)sender;

@end
