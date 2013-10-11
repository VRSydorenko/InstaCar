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
    NSArray *userDefinedData;
    
    int selectingModelForAutoIndex;
    
    ContentType currentContentType;
    
    Auto *selectedAuto;
    AutoModel *selectedModel;
    AutoSubmodel *selectedSubmodel;
    
    CustomCarFormVC *customCarForm;
}

@end

@implementation AutosVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    selectingModelForAutoIndex = -1;
    data = [DataManager getAutos];
    userDefinedData = nil;
    customCarForm = nil;
    
    currentContentType = CONTENT_AUTOS;
    //[self.btnBack setTitle:@"Back" forState:UIControlStateNormal];
    
    self.tableAutos.delegate = self;
    self.tableAutos.dataSource = self;
}

-(void)hideCustomCarFormIfOpened{
    if (customCarForm){
        [customCarForm dismissViewControllerAnimated:NO completion:nil];
        customCarForm = nil;
    }
}

#pragma mark CustomCarFormDelegate

-(void)newAutoModelPreparedToAdd:(AutoModel*)model  preparedForAuto:(int)autoId{
    [customCarForm dismissViewControllerAnimated:NO completion:nil];
    customCarForm = nil;
    
    if (model){
        [DataManager addCustomAutoModel:model.name ofAuto:autoId logo:model.logo startYear:model.startYear endYear:model.endYear];
        
        [self updateTableSourceDataWithNewContentType:currentContentType];
    }
}

#pragma mark Table methods

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [DataManager isFullVersion] && section == 1 && currentContentType == CONTENT_MODELS ? 30.0 : 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([DataManager isFullVersion] && section == 1 && currentContentType == CONTENT_MODELS){ // user cars
        UIToolbar *header = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.tableAutos.bounds.size.width, 30.0)];
        header.barTintColor = [UIColor blackColor];
        header.tintColor = [UIColor lightTextColor];
        
        UIBarButtonItem *fixSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(addCustomCarPressed)];
        fixSpace.width = 40.0;
        NSString *barString = (userDefinedData ? userDefinedData.count : 0) == 0 ? @"Didn't find a car? Add it!" : @"Your custom cars";
        UIBarButtonItem *barText = [[UIBarButtonItem alloc] initWithTitle:barString style:UIBarButtonItemStylePlain target:nil action:nil];
        [barText setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} forState:UIControlStateNormal];

        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCustomCarPressed)];
        
        NSArray *barButtonItems = [[NSArray alloc] initWithObjects:fixSpace, barText, flexSpace, btnAdd, nil];
        header.items = barButtonItems;
        
        return header;
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1){
        return userDefinedData ? userDefinedData.count : 0;
    }
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cellAuto";
    CellAuto *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row; // for sublevel picker callback
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (currentContentType) {
        case CONTENT_AUTOS:{
            Auto *_auto = [data objectAtIndex:indexPath.row];
            cell.autoTitleLabel.text = _auto.name;
            cell.autoLogo.image = [UIImage imageNamed:_auto.logo];
            cell.sublevelPickerDelegate = self;
            
            NSInteger modelsCount = [DataManager getModelsCountForAuto:_auto._id]; // TODO: get count instead of all models
            cell.autoModelsButton.hidden = modelsCount == 0;
            break;
        }
        case CONTENT_MODELS:{
            if (indexPath.section == 0){ // built-in model
                AutoModel *model = [data objectAtIndex:indexPath.row];
                cell.autoTitleLabel.text = model.name;
                cell.autoLogo.image = [UIImage imageNamed:model.logo];
                cell.sublevelPickerDelegate = self;
                
                NSArray *submodels = [DataManager getSubmodelsOfModel:model.modelId]; // TODO: get count instead of all submodels
                cell.autoModelsButton.hidden = !model.isSelectable || submodels.count == 0;
                if (!model.isSelectable){
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            } else { // user defined model
                AutoModel *model = [userDefinedData objectAtIndex:indexPath.row];
                cell.autoTitleLabel.text = model.name;
                cell.autoLogo.image = [UIImage imageNamed:model.logo];
                cell.autoModelsButton.hidden = YES;
            }
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
                if (indexPath.section == 0){
                    selectedModel = [data objectAtIndex:indexPath.row];
                } else {
                    selectedModel = [userDefinedData objectAtIndex:indexPath.row];
                }
                // if current model cannot be picked then simulate its '...' button click and return
                if (!selectedModel.isSelectable){
                   [self sublevelButtonPressedAtIndex:indexPath.row];
                    return;
                }
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

-(void)sublevelButtonPressedAtIndex:(long)index{
    switch (currentContentType) {
        case CONTENT_AUTOS:{
            selectedAuto = [data objectAtIndex:index];
            [self updateTableSourceDataWithNewContentType:CONTENT_MODELS];
            break;
        }
        case CONTENT_MODELS:{
            selectedModel = [data objectAtIndex:index];
            [self updateTableSourceDataWithNewContentType:CONTENT_SUBMODELS];
            break;
        }
        default:
            break;
    }
}

#pragma mark private methods

-(void)addCustomCarPressed{
    if (!customCarForm){
        customCarForm = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"customCarFormVC"];
        customCarForm.customCarDelegate = self;
    }
    customCarForm.autoId = selectedAuto._id;
    customCarForm.logoFilename = selectedAuto.logo;
    customCarForm.autoName = selectedAuto.name;
    
    [self presentViewController:customCarForm animated:YES completion:nil];
}

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
            break;
        }
        case CONTENT_MODELS:{
            [self updateTableSourceDataWithNewContentType:CONTENT_AUTOS];
            break;
        }
        case CONTENT_SUBMODELS:{
            [self updateTableSourceDataWithNewContentType:CONTENT_MODELS];
            break;
        }
    }
}

- (IBAction)btnClosePressed:(id)sender {
    [self.autoSelectorDelegate newAutoSelected:nil];
}

-(void)updateTableSourceDataWithNewContentType:(ContentType)type{
    NSUInteger dataRowsDelta = data.count;
    data = nil;
    switch (type) {
        case CONTENT_AUTOS:{ data = [DataManager getAutos]; break;}
        case CONTENT_MODELS:{ data = [DataManager getBuiltInModelsOfAuto:selectedAuto._id]; break;}
        case CONTENT_SUBMODELS:{ data = [DataManager getSubmodelsOfModel:selectedModel.modelId]; break;}
    }
    dataRowsDelta = data.count - dataRowsDelta;
    
    NSUInteger userDataRowsDelta = userDefinedData ? userDefinedData.count : 0;
    if (type == CONTENT_MODELS){
        userDefinedData = [DataManager getUserDefinedModelsOfAuto:selectedAuto._id];
    } else {
        userDefinedData = nil;
    }
    userDataRowsDelta = (userDefinedData ? userDefinedData.count : 0) - userDataRowsDelta;
    
    currentContentType = type;
    
    [self.tableAutos beginUpdates];
    [self updateRowsInTable:self.tableAutos section:0 byAddingRows:dataRowsDelta];
    [self updateRowsInTable:self.tableAutos section:1 byAddingRows:userDataRowsDelta];
    [self.tableAutos endUpdates];
    
    [self.tableAutos reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)updateRowsInTable:(UITableView*)tableView section:(NSInteger)section byAddingRows:(NSInteger)rows{
    if (rows == 0){
        return;
    }
    
    NSInteger rowsCount = ABS(rows);
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    for (int i = 0; i < rowsCount; i++)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:section];
        [paths addObject:path];
    }
    
    if (rows > 0){
        [tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
