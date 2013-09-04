//
//  ModelsVC.m
//  InstaCar
//
//  Created by VRS on 9/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "ModelsVC.h"
#import "CellModel.h"

@interface ModelsVC (){
    NSArray *models;
    
    int selectingSubmodelForModelIndex;
    SubmodelsVC *submodelsVC;
}

@end

@implementation ModelsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    selectingSubmodelForModelIndex = -1;
    models = [DataManager getModelsOfAuto:self.autoId];
    
    self.tableModels.delegate = self;
    self.tableModels.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    if (submodelsVC){
        [submodelsVC dismissViewControllerAnimated:NO completion:nil];
    }
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
    return @"Models";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellModel";
    CellModel *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    AutoModel *model = [models objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    cell.modelTitleLabel.text = model.name;
    cell.modelLogo.image = [UIImage imageNamed:model.logo];
    cell.sublevelPickerDelegate = self;
    
    NSArray *submodels = [DataManager getSubmodelsOfModel:model.modelId];
    cell.modelSubmodelsButton.hidden = submodels.count == 0;
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.modelSelectorDelegate){
        [self.modelSelectorDelegate newModelSelected:[models objectAtIndex:indexPath.row]];
    }
}

#pragma mark SubmodelSelectorDelegate

-(void)newSubmodelSelected:(AutoSubmodel*)newSubmodel{
    if (submodelsVC){
        [submodelsVC dismissViewControllerAnimated:NO completion:nil];
        submodelsVC = nil;
        if (selectingSubmodelForModelIndex != -1){
            AutoModel *model = [models objectAtIndex:selectingSubmodelForModelIndex];
            model.submodel = newSubmodel;
            if (self.modelSelectorDelegate){
                [self.modelSelectorDelegate newModelSelected:model];
            }
        }
    }
}

#pragma mark SublevelPickerDelegate

-(void)sublevelButtonPressedAtIndex:(int)index{
    if (!submodelsVC){
        submodelsVC = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"submodelsVC"];
        submodelsVC.submodelSelectorDelegate = self;
        AutoModel *model = [models objectAtIndex:index];
        submodelsVC.modelId = model.modelId;
        selectingSubmodelForModelIndex = index;
    }
    [self presentViewController:submodelsVC animated:YES completion:nil];
}

@end
