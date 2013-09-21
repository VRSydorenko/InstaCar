//
//  AutosVC.m
//  InstaCar
//
//  Created by VRS on 9/2/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "AutosVC.h"

typedef enum {
    CONTENT_AUTOS = 0,
    CONTENT_MODELS = 1,
    CONTENT_SUBMODELS = 2,
} ContentType;

@interface AutosVC (){
    NSArray *data;
    
    int selectingModelForAutoIndex;
    
    ContentType currentContentType;
    
    Auto *selectedAuto;
    AutoModel *selectedModel;
    AutoSubmodel *selectedSubmodel;
}

@end

@implementation AutosVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    selectingModelForAutoIndex = -1;
    data = [DataManager getAutos];
    currentContentType = CONTENT_AUTOS;
    //[self.btnBack setTitle:@"Back" forState:UIControlStateNormal];
    
    self.tableAutos.delegate = self;
    self.tableAutos.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cellAuto";
    CellAuto *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (currentContentType) {
        case CONTENT_AUTOS:{
            Auto *_auto = [data objectAtIndex:indexPath.row];
            cell.tag = indexPath.row;
            cell.autoTitleLabel.text = _auto.name;
            cell.autoLogo.image = [UIImage imageNamed:_auto.logo];
            cell.sublevelPickerDelegate = self;
            
            NSArray *models = [DataManager getModelsOfAuto:_auto._id];
            cell.autoModelsButton.hidden = models.count == 0;
            break;
        }
        case CONTENT_MODELS:{
            AutoModel *model = [data objectAtIndex:indexPath.row];
            cell.tag = indexPath.row;
            cell.autoTitleLabel.text = model.name;
            cell.autoLogo.image = [UIImage imageNamed:model.logo];
            cell.sublevelPickerDelegate = self;
            
            NSArray *submodels = [DataManager getSubmodelsOfModel:model.modelId];
            cell.autoModelsButton.hidden = submodels.count == 0;
            break;
        }
        case CONTENT_SUBMODELS:{
            AutoSubmodel *submodel = [data objectAtIndex:indexPath.row];
            cell.autoTitleLabel.text = submodel.name;
            cell.autoLogo.image = [UIImage imageNamed:submodel.logo];
            cell.autoModelsButton.hidden = YES;
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.autoSelectorDelegate){
        switch (currentContentType) {
            case CONTENT_AUTOS:{
                selectedAuto = [data objectAtIndex:indexPath.row];
                break;
            }
            case CONTENT_MODELS:{
                selectedModel = [data objectAtIndex:indexPath.row];
                break;
            }
            case CONTENT_SUBMODELS:{
                selectedSubmodel = [data objectAtIndex:indexPath.row];
                break;
            }
        }
        [self.autoSelectorDelegate newAutoSelected:[self prepareResult]];
    }
}

#pragma mark SublevelPickerDelegate

-(void)sublevelButtonPressedAtIndex:(int)index{
    switch (currentContentType) {
        case CONTENT_AUTOS:{
            selectedAuto = [data objectAtIndex:index];
            data = [DataManager getModelsOfAuto:selectedAuto._id];
            currentContentType = CONTENT_MODELS;
            [self.tableAutos reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            //[self.btnBack setTitle:@"Cars" forState:UIControlStateNormal];
            break;
        }
        case CONTENT_MODELS:{
            selectedModel = [data objectAtIndex:index];
            data = [DataManager getSubmodelsOfModel:selectedModel.modelId];
            currentContentType = CONTENT_SUBMODELS;
            [self.tableAutos reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            //[self.btnBack setTitle:@"Models" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

#pragma mark private methods

-(Auto*)prepareResult{
    if (selectedModel){
        if (selectedSubmodel){
            selectedModel.submodel = selectedSubmodel;
        }
        selectedAuto.model = selectedModel;
    }
    return selectedAuto;
}

- (IBAction)btnBackPressed {
    switch (currentContentType) {
        case CONTENT_AUTOS:{
            [self dismissViewControllerAnimated:YES completion:nil];
//            [self.autoSelectorDelegate newAutoSelected:nil];
            break;
        }
        case CONTENT_MODELS:{
            data = [DataManager getAutos];
            currentContentType = CONTENT_AUTOS;
            [self.tableAutos reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            //[self.btnBack setTitle:@"Back" forState:UIControlStateNormal];
            break;
        }
        case CONTENT_SUBMODELS:{
            data = [DataManager getModelsOfAuto:selectedAuto._id];
            currentContentType = CONTENT_MODELS;
            [self.tableAutos reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            //[self.btnBack setTitle:@"Cars" forState:UIControlStateNormal];
            break;
        }
    }
}

- (IBAction)btnClosePressed:(id)sender {
    [self.autoSelectorDelegate newAutoSelected:nil];
}
@end
