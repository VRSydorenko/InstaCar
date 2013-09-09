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
#import "DataManager.h"

@interface LocationsVC (){
    CLLocationManager *locationManager;
}

@end

@implementation LocationsVC

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

#pragma mark Table methods

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
    
    if (venue.iconURL && venue.iconURL.length > 0){
        UIImage *icon = [DataManager getIconForPath:venue.iconURL];
        if (!icon){
            NSURL *url = [NSURL URLWithString:venue.iconURL];
            NSData *data = [NSData dataWithContentsOfURL:url];
            icon = [UIImage imageWithData:data];
            [DataManager addIcon:icon forPath:venue.iconURL];
        }
        cell.imgVenueIcon.image = icon;
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FSVenue *selectedVenue = [self.nearbyVenues objectAtIndex:indexPath.row];
    [DataManager setSelectedVenue:selectedVenue];
    [self.sideActionDelegate performSideAction:ACT_UPDATE_SKINS_LOCATION withArgument:selectedVenue];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Location manager delegate

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

#pragma mark Event handlers

- (IBAction)btnBackPressed {
    [locationManager stopUpdatingLocation];
    
    [self restoreRefreshButtonIfHidden];
    
    if (self.sideActionDelegate){
        [self.sideActionDelegate performSideAction:ACT_EMPTY withArgument:nil];
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

#pragma marj private methods

-(void)restoreRefreshButtonIfHidden{
    NSMutableArray *toolBarButtons = [self.toolBar.items mutableCopy];
    if (![toolBarButtons containsObject:self.btnRefresh]){
        [toolBarButtons insertObject:self.btnRefresh atIndex:0];
        self.toolBar.items = toolBarButtons;
    }
    [self.activityIndicator stopAnimating];
}

@end
