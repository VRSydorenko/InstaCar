//
//  AppMenuTableVC.m
//  InstaCar
//
//  Created by VRS on 8/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "AppMenuTableVC.h"

@interface AppMenuTableVC ()

@end

@implementation AppMenuTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableAppMenu.delegate = self;
    self.tableAppMenu.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellSomeItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"some item...";
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // TODO: determine the action and pass it in the delegate method further
    
    [self.sideActionDelegate performSideAction:ACT_EMPTY withArgument:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)btnClosePressed:(id)sender {
    [self.sideActionDelegate performSideAction:ACT_EMPTY withArgument:nil];
}
@end
