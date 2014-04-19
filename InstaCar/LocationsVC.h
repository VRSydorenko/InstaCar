//
//  LocationsVC.h
//  InstaCar
//
//  Created by VRS on 8/23/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "AppDelegate.h"
#import "SideViewControllerBase.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationsVC : SideViewControllerBase <UITableViewDelegate,
                                                 UITableViewDataSource,
                                                 LocationUpdateReceiverDelegate>

@property (nonatomic) IBOutlet UITableView *tableVenues;
@property (nonatomic) NSArray *nearbyVenues; // FSVenue
@property (nonatomic) IBOutlet UIBarButtonItem *btnRefresh;
@property (nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)btnBackPressed;
- (IBAction)btnRefreshPressed:(id)sender;

@end