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
    UITableViewCellAccessoryType type = UITableViewCellAccessoryDisclosureIndicator;
    return type;
}

-(SideAction)getSideActionForMenuItem:(NSString*)itemTitle{
    SideAction action = ACT_EMPTY;
    
    if ([itemTitle isEqualToString:INSTACARAPP_USER]){
        action = ACT_OPEN_INSTA_SELF_PROFILE;
    } if ([itemTitle isEqualToString:INSTACARAPP_TAG]){
        action = ACT_OPEN_INSTA_SELF_TAG;
    } if ([itemTitle isEqualToString:LIKE_IT]){
        action = ACT_OPEN_FB_PAGE;
    } if ([itemTitle isEqualToString:RATE_APP]){
        action = ACT_OPEN_APPSTORE_TO_RATE;
    } if ([itemTitle isEqualToString:CONTACT_US]){
        action = ACT_PREPARE_FEEDBACK_MAIL;
    }
    
    return action;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *menuItemTitle = [data objectAtIndex:indexPath.row];
    
    [self.sideActionDelegate performSideAction:[self getSideActionForMenuItem:menuItemTitle] withArgument:nil hidingSideController:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)btnClosePressed:(id)sender {
    [self.sideActionDelegate performSideAction:ACT_EMPTY withArgument:nil hidingSideController:YES];
}
@end
