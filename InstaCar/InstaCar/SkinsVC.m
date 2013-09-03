//
//  SkinsVC.m
//  InstaCar
//
//  Created by VRS on 9/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinsVC.h"
#import "AutosVC.h"

@interface SkinsVC (){
    NSArray *sets;
    AutosVC *autosVC;
}
@end

@implementation SkinsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    autosVC = nil;
    
    sets = [DataManager getSkinSets];
	
    self.tableSets.delegate = self;
    self.tableSets.dataSource = self;
    
    self.tableSelectedAuto.delegate = self;
    self.tableSelectedAuto.dataSource = self;
}

-(void)dealloc{
    sets = nil;
    autosVC = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table methods

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

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

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableSelectedAuto){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (!autosVC){
            autosVC = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"autosVC"];
        }
        [self presentViewController:autosVC animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark DDMenuControllerDelegate

-(void)menuControllerWillShowRootViewController{
    if (autosVC){
        [autosVC dismissViewControllerAnimated:NO completion:nil];
        autosVC = nil;
    }
}

@end
