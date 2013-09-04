//
//  AutosVC.m
//  InstaCar
//
//  Created by VRS on 9/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "AutosVC.h"

@interface AutosVC (){
    NSArray *autos;
    
    ModelsVC *modelsVC;
    int selectingModelForAutoIndex;
}

@end

@implementation AutosVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    selectingModelForAutoIndex = -1;
    autos = [DataManager getAutos];
    
    self.tableAutos.delegate = self;
    self.tableAutos.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    if (modelsVC){
        [modelsVC dismissViewControllerAnimated:NO completion:nil];
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
    return @"Cars";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return autos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellAuto";
    CellAuto *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Auto *_auto = [autos objectAtIndex:indexPath.row];
    cell.tag = indexPath.row; // store index for model button handler
    cell.autoTitleLabel.text = _auto.name;
    cell.autoLogo.image = [UIImage imageNamed:_auto.logo];
    cell.sublevelPickerDelegate = self;
    
    NSArray *models = [DataManager getModelsOfAuto:_auto._id];
    cell.autoModelsButton.hidden = models.count == 0;
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.autoSelectorDelegate){
        [self.autoSelectorDelegate newAutoSelected:[autos objectAtIndex:indexPath.row]];
    }
}

#pragma mark ModelSelectorDelegate

-(void)newModelSelected:(AutoModel*)newModel{
    if (modelsVC){
        [modelsVC dismissViewControllerAnimated:NO completion:nil];
        modelsVC = nil;
        if (selectingModelForAutoIndex != -1){
            Auto *_auto = [autos objectAtIndex:selectingModelForAutoIndex];
            _auto.model = newModel;
            if (self.autoSelectorDelegate){
                [self.autoSelectorDelegate newAutoSelected:[autos objectAtIndex:selectingModelForAutoIndex]];
            }
        }
    }
}

#pragma mark SublevelPickerDelegate

-(void)sublevelButtonPressedAtIndex:(int)index{
    if (!modelsVC){
        modelsVC = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"modelsVC"];
        modelsVC.modelSelectorDelegate = self;
        Auto *_auto = [autos objectAtIndex:index];
        modelsVC.autoId = _auto._id;
        selectingModelForAutoIndex = index;
    }
    [self presentViewController:modelsVC animated:YES completion:nil];
}

@end
