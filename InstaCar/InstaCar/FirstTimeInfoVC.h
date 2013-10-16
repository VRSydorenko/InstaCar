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

@property (nonatomic) id<FirstTimeVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *infoView;

- (IBAction)didTap:(id)sender;

@end
