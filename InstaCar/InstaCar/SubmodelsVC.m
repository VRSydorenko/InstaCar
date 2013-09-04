//
//  SubmodelsVC.m
//  InstaCar
//
//  Created by VRS on 9/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SubmodelsVC.h"
#import "CellSubmodel.h"

@interface SubmodelsVC (){
    NSArray *submodels;
}

@end

@implementation SubmodelsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    submodels = [DataManager getSubmodelsOfModel:self.modelId];
    
    self.tableSubmodels.delegate = self;
    self.tableSubmodels.dataSource = self;
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
    return @"Submodels";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return submodels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellSubmodel";
    CellSubmodel *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    AutoSubmodel *submodel = [submodels objectAtIndex:indexPath.row];
    cell.submodelTitleLabel.text = submodel.name;
    cell.submodelLogo.image = [UIImage imageNamed:submodel.logo];
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.submodelSelectorDelegate){
        [self.submodelSelectorDelegate newSubmodelSelected:[submodels objectAtIndex:indexPath.row]];
    }
}

@end
