//
//  CustomCarFormVC.h
//  InstaCar
//
//  Created by VRS on 10/9/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoModel.h"

@protocol CustomCarFormDelegate <NSObject>
-(void)newAutoModelPreparedToAdd:(AutoModel*)model  preparedForAuto:(int)autoId;
@end

@interface CustomCarFormVC : UIViewController<UITextFieldDelegate>

- (IBAction)btnCancelPressed:(id)sender;
- (IBAction)btnDonePressed:(id)sender;
- (IBAction)modelTextChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIToolbar *barBottom;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barItemText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barItemDone;
@property (weak, nonatomic) IBOutlet UITextField *textModel;
@property (weak, nonatomic) IBOutlet UITextField *textStartYear;
@property (weak, nonatomic) IBOutlet UITextField *textEndYear;

@property (nonatomic) id<CustomCarFormDelegate> customCarDelegate;

@property (nonatomic) int autoId;
@property (nonatomic) NSString* logoFilename;
@property (nonatomic) NSString* autoName;

@end
