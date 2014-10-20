//
//  SkinCmdRatingEditor.h
//  InstaCar
//
//  Created by VRS on 19/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinCommandProtocol.h"

@interface SkinCmdRatingEditor : UIView <SkinCommandProtocol>{
    int rating;
}

@property (nonatomic) SkinCommandDelegate *delegate;
@property (nonatomic) SkinCommandContainerDelegate *container;

@property (weak, nonatomic) IBOutlet UIButton *btnStar1;
@property (weak, nonatomic) IBOutlet UIButton *btnStar2;
@property (weak, nonatomic) IBOutlet UIButton *btnStar3;
@property (weak, nonatomic) IBOutlet UIButton *btnStar4;
@property (weak, nonatomic) IBOutlet UIButton *btnStar5;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnCancelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintbtnConfirmWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintStar1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintStar2Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintStar4Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintStar5Width;

- (IBAction)onBtnCancel:(id)sender;
- (IBAction)onBtnConfirm:(id)sender;
- (IBAction)onStarClick:(id)sender;

@end
