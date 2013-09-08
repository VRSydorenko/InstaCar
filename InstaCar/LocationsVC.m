//
//  LocationsVC.m
//  InstaCar
//
//  Created by VRS on 8/23/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "LocationsVC.h"
#import "Foursquare2.h"
#import "FSConverter.h"
#import "CellVenue.h"

@interface LocationsVC (){
    CLLocationManager *locationManager;
}

@end

@implementation LocationsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableVenues.delegate = self;
    self.tableVenues.dataSource = self;
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.delegate = self;
    
    [self btnRefreshPressed:self.btnRefresh];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nearbyVenues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellVenue";
    CellVenue *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    FSVenue *venue = [self.nearbyVenues objectAtIndex:indexPath.row];
    
    cell.textVenueName.text =  venue.name;
    NSURL *url = [NSURL URLWithString:venue.iconURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    cell.imgVenueIcon.image = img;
    
    return cell;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [locationManager stopUpdatingLocation];
    CLLocation *newLocation = (CLLocation*)locations.lastObject;
    [Foursquare2 searchVenuesNearByLatitude:@(newLocation.coordinate.latitude)
                 longitude:@(newLocation.coordinate.longitude)
                 accuracyLL:nil
                 altitude:nil
                 accuracyAlt:nil
                 query:nil
                 limit:nil
                 intent:intentBrowse
                 radius:@(500)
                 categoryId:nil
                 callback:^(BOOL success, id result){
                     if (success) {
                         NSDictionary *dic = result;
                         NSArray* venues = [dic valueForKeyPath:@"response.venues"];
                         FSConverter *converter = [[FSConverter alloc]init];
                         self.nearbyVenues = [converter convertToObjects:venues];
                         [self.tableVenues reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                         
                         [self restoreRefreshButtonIfHidden];
                     } else {
                         [locationManager startUpdatingLocation];
                     }
                }
     ];
}

- (IBAction)btnBackPressed {
    [locationManager stopUpdatingLocation];
    
    [self restoreRefreshButtonIfHidden];
    
    if (self.sideActionDelegate){
        [self.sideActionDelegate performSideAction:EMPTY withArgument:nil];
    }
}

- (IBAction)btnRefreshPressed:(id)sender {
    // hide refresh button
    NSMutableArray *toolBarButtons = [self.toolBar.items mutableCopy];
    [toolBarButtons removeObject:self.btnRefresh];
    self.toolBar.items = toolBarButtons;
    [self.activityIndicator startAnimating];
    
    [locationManager startUpdatingLocation];
}

-(void)restoreRefreshButtonIfHidden{
    NSMutableArray *toolBarButtons = [self.toolBar.items mutableCopy];
    if (![toolBarButtons containsObject:self.btnRefresh]){
        [toolBarButtons insertObject:self.btnRefresh atIndex:0];
        self.toolBar.items = toolBarButtons;
    }
    [self.activityIndicator stopAnimating];
}

@end
