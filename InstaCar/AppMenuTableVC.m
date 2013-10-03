//
//  AppMenuTableVC.m
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "AppMenuTableVC.h"

@interface AppMenuTableVC (){
    NSArray *data;
}
@end

@implementation AppMenuTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    data = [[NSArray alloc] initWithObjects:INSTACARAPP_TAG, INSTACARAPP_USER, LIKE_IT, RATE_APP, CONTACT_US, nil];
    
    self.tableAppMenu.delegate = self;
    self.tableAppMenu.dataSource = self;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellMenuItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSString *menuItemTitle = [data objectAtIndex:indexPath.row];
    
    cell.textLabel.text = menuItemTitle;
    cell.imageView.image = [self getIconForMenuItem:menuItemTitle];
    cell.accessoryType = [self getAccessoryTypeForMenuItem:menuItemTitle];
    
    return cell;
}

#pragma Helper methods

-(UIImage*)getIconForMenuItem:(NSString*)itemTitle{
    UIImage *icon = nil;
    
    if ([itemTitle isEqualToString:INSTACARAPP_USER]){
        icon = [UIImage imageNamed:@"SmallCamera.png"];
    } if ([itemTitle isEqualToString:INSTACARAPP_TAG]){
        icon = [UIImage imageNamed:@"SmallTag.png"];
    } if ([itemTitle isEqualToString:LIKE_IT]){
        icon = [UIImage imageNamed:@"SmallFacebook.png"];
    } if ([itemTitle isEqualToString:RATE_APP]){
        icon = [UIImage imageNamed:@"SmallStar.png"];
    } if ([itemTitle isEqualToString:CONTACT_US]){
        icon = [UIImage imageNamed:@"SmallEnvelope.png"];
    }
    
    return icon;
}

-(UITableViewCellAccessoryType)getAccessoryTypeForMenuItem:(NSString*)itemTitle{
    UITableViewCellAccessoryType type = UITableViewCellAccessoryNone;

    if ([itemTitle isEqualToString:INSTACARAPP_USER]
        || [itemTitle isEqualToString:INSTACARAPP_TAG]
        || [itemTitle isEqualToString:LIKE_IT]
        || [itemTitle isEqualToString:RATE_APP]
        || [itemTitle isEqualToString:CONTACT_US]){
        
        type = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return type;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // TODO: determine the action and pass it in the delegate method further
    
    [self.sideActionDelegate performSideAction:ACT_EMPTY withArgument:nil hidingSideController:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)btnClosePressed:(id)sender {
    [self.sideActionDelegate performSideAction:ACT_EMPTY withArgument:nil hidingSideController:YES];
}
@end
