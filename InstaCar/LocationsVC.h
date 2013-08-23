//
//  LocationsVC.h
//  InstaCar
//
//  Created by VRS on 8/23/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SideViewControllerBase.h"
#import <CoreLocation/CoreLocation.h>

@class FSVenue;
@interface LocationsVC : SideViewControllerBase <UITableViewDelegate,
                                                 UITableViewDataSource,
                                                 CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableVenues;
@property (strong,nonatomic) FSVenue *selectedVenue;
@property (strong,nonatomic) NSArray *nearbyVenues;

@end