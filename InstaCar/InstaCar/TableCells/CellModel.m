//
//  CellAuto.m
//  InstaCar
//
//  Created by VRS on 9/3/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)submodelsButtonPressed:(id)sender{
    [self.sublevelPickerDelegate sublevelButtonPressedAtIndex:self.tag];
}

@end
