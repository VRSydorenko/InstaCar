//
//  FirstTimeInfoVC.h
//  InstaCar
//
//  Created by VRS on 10/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstTimeInfoVC;

@protocol FirstTimeVCDelegate <NSObject>
-(void)firstTimeVCNeedsToDismiss:(FirstTimeInfoVC*)viewController;
@end

@interface FirstTimeInfoVC : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintArrowLeftTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMiddleTextTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintArrowRightTop;

@property id<FirstTimeVCDelegate> delegate;
@property (nonatomic) IBOutlet UIView *infoView;

- (IBAction)didTap:(id)sender;

@end
