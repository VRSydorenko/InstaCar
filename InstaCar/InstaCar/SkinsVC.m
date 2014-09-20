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
	
    self.tableSelectedData.delegate = self;
    self.tableSelectedData.dataSource = self;
}

#pragma mark Table methods

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *imageName = section == 0 ? @"logo_anycar.png" : @"Mask.png";
    UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    headerView.contentMode = section == 0 ? UIViewContentModeScaleAspectFit : UIViewContentModeCenter;
    headerView.backgroundColor = [UIColor lightGrayColor];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: // selected autos
            return [DataManager getSelectedSkinSet].supportsSecondCar ? 2 : 1;
        case 1: // skinsets
            return sets.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: // selected autos
            return  [self tableView:tableView cellForSelectedAutoAtIndexPath:indexPath];
        case 1: // skinsets
            return [self tableView:tableView cellForSkinSetAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSkinSetAtIndexPath:(NSIndexPath*)indexPath{
    CellSkinSet *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSkin" forIndexPath:indexPath];
    
    SkinSet *set = (SkinSet*)[sets objectAtIndex:indexPath.row];
    bool setSelected = [[set getTitle] isEqualToString:[[DataManager getSelectedSkinSet] getTitle]];
    
    cell.skinTitleLabel.text = [set getTitle];
    cell.accessoryType = setSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSelectedAutoAtIndexPath:(NSIndexPath*)indexPath{
    CellSelectedAuto *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSelectedAuto" forIndexPath:indexPath];
    [cell.autoLogo.layer setMinificationFilter:kCAFilterTrilinear];
    Auto *_auto = indexPath.row == 0 ? [DataManager getSelectedAuto1] : [DataManager getSelectedAuto2];
    
    if (_auto){
        cell.autoTitleLabel.text = _auto.name;
        cell.autoLogo.image = _auto.logo128;
    } else {
        cell.autoTitleLabel.text = @"Select car...";
        cell.autoLogo.image = nil;
    }
    
    CGSize textSize = [cell.autoTitleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObject:cell.autoTitleLabel.font forKey: NSFontAttributeName]];
    cell.constraintMainTextWidth.constant = textSize.width; // TODO: set this size in the cell class
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {// selected autos
            if (!autosVC){
                autosVC = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"autosVC"];
                autosVC.autoSelectorDelegate = self;
            }
            isSelectingSecondAuto = indexPath.row == 1; // 0 or 1
            [self presentViewController:autosVC animated:YES completion:nil];
            break;
        }
        case 1: {// skinsets
            SkinSet *newSet = [sets objectAtIndex:indexPath.row];
            if (![[newSet getTitle] isEqualToString:[[DataManager getSelectedSkinSet] getTitle]]){
                //[DataManager setSelectedSkinSet:newSet];
                [self.sideActionDelegate performSideAction:ACT_LOAD_NEW_SKINSET withArgument:newSet hidingSideController:YES];
            } else {
                [self.sideActionDelegate performSideAction:ACT_EMPTY withArgument:nil hidingSideController:YES];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -

#pragma mark AutoSelectorDelegate

-(void)newAutoSelected:(Auto*)newAuto{
    if (newAuto){
        if (isSelectingSecondAuto){
            [DataManager setSelectedAuto2:newAuto];
            [[DataManager getSelectedSkinSet] updateData:newAuto ofType:AUTO2];
        } else {
            [DataManager setSelectedAuto1:newAuto];
            [[DataManager getSelectedSkinSet] updateData:newAuto ofType:AUTO1];
        }
        [self.tableSelectedData reloadData];
    }
    
    [self.sideActionDelegate performSideAction:ACT_EMPTY withArgument:nil hidingSideController:YES];
}

-(void)userWantsProVersionInfo{
    [self.sideActionDelegate performSideAction:ACT_OPEN_PROINFO withArgument:nil hidingSideController:YES];
}

#pragma mark DDMenuControllerDelegate

-(void)menuControllerWillShowRootViewController{
    if (autosVC){
        [autosVC hideCustomCarFormIfOpened];
        [autosVC dismissViewControllerAnimated:NO completion:nil];
    }
}

- (IBAction)btnClosePressed:(id)sender {
    [self.sideActionDelegate performSideAction:ACT_EMPTY withArgument:nil hidingSideController:YES];
}
@end
