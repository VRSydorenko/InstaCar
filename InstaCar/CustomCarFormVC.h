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

@interface CustomCarFormVC : UIViewController

- (IBAction)btnCancelPressed:(id)sender;

@property (nonatomic) id<CustomCarFormDelegate> customCarDelegate;
@property (nonatomic) int autoId;
@property (nonatomic) NSString* logoFilename;

@end
