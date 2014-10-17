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

@property (nonatomic) IBOutlet UIToolbar *barBottom;
@property (nonatomic) IBOutlet UIBarButtonItem *barItemText;
@property (nonatomic) IBOutlet UIBarButtonItem *barItemDone;
@property (nonatomic) IBOutlet UITextField *textModel;
@property (nonatomic) IBOutlet UITextField *textStartYear;
@property (nonatomic) IBOutlet UITextField *textEndYear;

@property id<CustomCarFormDelegate> customCarDelegate;

@property (nonatomic) int autoId;
@property (nonatomic) NSString* logoFilename;
@property (nonatomic) NSString* autoName;

@end
