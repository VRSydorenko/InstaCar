//
//  CustomCarFormVC.m
//  InstaCar
//
//  Created by VRS on 10/9/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "CustomCarFormVC.h"
#import "DataManager.h"

@interface CustomCarFormVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;

@end

@implementation CustomCarFormVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.imgLogo.image = [UIImage imageNamed:self.logoFilename];
    self.barItemDone.enabled = NO;
    self.barItemText.title = [NSString stringWithFormat:@"New %@", self.autoName];
    
    self.textStartYear.delegate = self;
    self.textEndYear.delegate = self;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSValue *aValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newToolbarFrame = CGRectMake(0.0, keyboardTop - self.barBottom.bounds.size.height, self.barBottom.bounds.size.width, self.barBottom.bounds.size.height);
    
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.barBottom.frame = newToolbarFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.barBottom.frame = CGRectMake(0.0, self.view.bounds.size.height - self.barBottom.bounds.size.height, self.barBottom.bounds.size.width, self.barBottom.bounds.size.height);

    [UIView commitAnimations];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = textField.text.length - range.length + string.length;
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 4 || returnKey;
}

- (IBAction)btnCancelPressed:(id)sender {
    if (self.customCarDelegate){
        [self.customCarDelegate newAutoModelPreparedToAdd:nil preparedForAuto:self.autoId];
    }
}

- (IBAction)btnDonePressed:(id)sender {
    int startYear = self.textStartYear.text.intValue;
    int endYear = self.textEndYear.text.intValue;
    
    if (startYear == endYear && startYear != 0){
        endYear = -1; // concept car
    }
    
    AutoModel *toAdd = [[AutoModel alloc] initWithId:-1 andName:self.textModel.text];
    toAdd.logo = self.logoFilename;
    toAdd.startYear = startYear;
    toAdd.endYear = endYear;
    
    if (self.customCarDelegate){
        [self.customCarDelegate newAutoModelPreparedToAdd:toAdd preparedForAuto:self.autoId];
    } else {
        [self btnCancelPressed:self];
    }
}

- (IBAction)modelTextChanged:(id)sender {
    self.barItemDone.enabled = self.textModel.text.length > 0;
}
@end
