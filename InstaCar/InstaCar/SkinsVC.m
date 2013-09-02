//
//  SkinsVC.m
//  InstaCar
//
//  Created by VRS on 9/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinsVC.h"

@interface SkinsVC (){
    NSArray *sets;
}
@end

@implementation SkinsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sets = [DataManager getSkinSets];
	
    self.tableSets.delegate = self;
    self.tableSets.dataSource = self;
    
    self.tableSelectedAuto.delegate = self;
    self.tableSelectedAuto.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table methods

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableSelectedAuto){
        switch (section) {
            case 0:
                return @"Selected Car";
        }
    } else if (tableView == self.tableSets){
        switch (section) {
            case 0:
                return @"Skins";
        }
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableSelectedAuto){
        switch (section) {
            case 0:
                return 1;
        }
    } else if (tableView == self.tableSets){
        switch (section) {
            case 0:
                return sets.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableSelectedAuto){
        return  [self tableView:tableView cellForSelectedAutoAtIndexPath:indexPath];
    } else if (tableView == self.tableSets){
        return [self tableView:tableView cellForSkinSetAtIndexPath:indexPath];
    }
    return [[UITableViewCell alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSkinSetAtIndexPath:(NSIndexPath*)indexPath{
    static NSString *CellIdentifier = @"cellSkin";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSObject<SkinSetProtocol> *set = (NSObject<SkinSetProtocol>*)[sets objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [set getTitle];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSelectedAutoAtIndexPath:(NSIndexPath*)indexPath{
    static NSString *CellIdentifier = @"cellSelectedAuto";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSObject<SkinSetProtocol> *set = (NSObject<SkinSetProtocol>*)[sets objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [set getTitle];
    
    return cell;
}

#pragma mark -

@end
