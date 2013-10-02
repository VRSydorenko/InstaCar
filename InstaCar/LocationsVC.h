//
//  LocationsVC.h
//  InstaCar
//
//  Created by VRS on 8/23/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SideViewControllerBase.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationsVC : SideViewControllerBase <UITableViewDelegate,
                                                 UITableViewDataSource,
                                                 CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableVenues;
@property (strong,nonatomic) NSArray *nearbyVenues; // FSVenue
@property (strong,nonatomic) IBOutlet UIBarButtonItem *btnRefresh;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)btnBackPressed;
- (IBAction)btnRefreshPressed:(id)sender;

@end