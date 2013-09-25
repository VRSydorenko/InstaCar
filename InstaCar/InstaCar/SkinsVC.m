//
//  SkinsVC.m
//  InstaCar
//
//  Created by VRS on 9/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinsVC.h"
#import "CellSkinSet.h"
#import "CellSelectedAuto.h"
#import "DataManager.h"

@interface SkinsVC (){
    NSArray *sets;
    AutosVC *autosVC;
    int isSelectingSecondAuto;
}
@end

@implementation SkinsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    autosVC = nil;
    isSelectingSecondAuto = NO;
    
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
    return 30;
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
                return [DataManager getSelectedSkinSet].supportsSecondCar ? 2 : 1;
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
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSkinSetAtIndexPath:(NSIndexPath*)indexPath{
    CellSkinSet *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSkin" forIndexPath:indexPath];
    
    SkinSet *set = (SkinSet*)[sets objectAtIndex:indexPath.row];
    
    cell.skinTitleLabel.text = [set getTitle];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSelectedAutoAtIndexPath:(NSIndexPath*)indexPath{
    CellSelectedAuto *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSelectedAuto" forIndexPath:indexPath];
    Auto *_auto = indexPath.row == 0 ? [DataManager getSelectedAuto1] : [DataManager getSelectedAuto2];
    
    if (_auto){
        cell.autoTitleLabel.text = _auto.name;
        cell.autoLogo.contentMode = UIViewContentModeScaleAspectFit;
        cell.autoLogo.image = [UIImage imageNamed:_auto.logo];
    } else {
        cell.autoTitleLabel.text = @"Select auto...";
        cell.autoLogo.contentMode = UIViewContentModeRight;
        cell.autoLogo.image = [UIImage imageNamed:@"anycarLogo.png"]; // TODO: load placeholder logo
    }
    
    CGSize textSize = [cell.autoTitleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObject:cell.autoTitleLabel.font forKey: NSFontAttributeName]];
    cell.constraintMainTextWidth.constant = textSize.width; // TODO: set this size in the cell class
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableSelectedAuto){
        //[tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (!autosVC){
            autosVC = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"autosVC"];
            autosVC.autoSelectorDelegate = self;
        }
        isSelectingSecondAuto = indexPath.row == 1; // 0 or 1
        [self presentViewController:autosVC animated:YES completion:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (tableView == self.tableSets) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SkinSet *newSet = [sets objectAtIndex:indexPath.row];
        if (![[newSet getTitle] isEqualToString:[[DataManager getSelectedSkinSet] getTitle]]){
            [DataManager setSelectedSkinSet:newSet];
            [self.sideActionDelegate performSideAction:ACT_LOAD_NEW_SKINSET withArgument:nil]; // TODO: pass set instead of nil?
        } else {
            [self.sideActionDelegate performSideAction:ACT_EMPTY withArgument:nil];
        }
    }
}

#pragma mark -

#pragma mark AutoSelectorDelegate

-(void)newAutoSelected:(Auto*)newAuto{
    //[autosVC dismissViewControllerAnimated:NO completion:nil];
    if (newAuto){
        if (isSelectingSecondAuto){
            [DataManager setSelectedAuto2:newAuto];
            [[DataManager getSelectedSkinSet] updateData:newAuto ofType:AUTO2];
        } else {
            [DataManager setSelectedAuto1:newAuto];
            [[DataManager getSelectedSkinSet] updateData:newAuto ofType:AUTO1];
        }
        [self.tableSelectedAuto reloadData];
        //[self.tableSelectedAuto reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self.sideActionDelegate performSideAction:ACT_EMPTY withArgument:nil];
}

#pragma mark DDMenuControllerDelegate

-(void)menuControllerWillShowRootViewController{
    if (autosVC){
        [autosVC dismissViewControllerAnimated:NO completion:nil];
    }
}

- (IBAction)btnClosePressed:(id)sender {
    [self.sideActionDelegate performSideAction:ACT_EMPTY withArgument:nil];
}
@end
