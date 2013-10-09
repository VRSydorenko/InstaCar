//
//  CustomCarFormVC.m
//  InstaCar
//
//  Created by VRS on 10/9/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "CustomCarFormVC.h"

@interface CustomCarFormVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;

@end

@implementation CustomCarFormVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imgLogo.image = [UIImage imageNamed:self.logoFilename];
}

- (IBAction)btnCancelPressed:(id)sender {
    if (self.customCarDelegate){
        [self.customCarDelegate newAutoModelPreparedToAdd:nil preparedForAuto:self.autoId];
    }
}
@end
