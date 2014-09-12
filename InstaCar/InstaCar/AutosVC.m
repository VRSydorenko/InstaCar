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
    AutoModel *addingModelBufferForEmail;
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
    addingModelBufferForEmail = nil;
    
    currentContentType = CONTENT_AUTOS;
    //[self.btnBack setTitle:@"Back" forState:UIControlStateNormal];
    
    self.tableAutos.delegate = self;
    self.tableAutos.dataSource = self;
    [iCloudHandler getInstance].delegate = self;
}

-(void)dealloc{
    [iCloudHandler getInstance].delegate = nil;
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
        if ([DataManager addCustomAutoModel:model.name ofAuto:autoId logo:model.logoName startYear:model.startYear endYear:model.endYear]){
            [self updateTableSourceDataWithNewContentType:currentContentType];
            [self.tableAutos reloadData];
            [self scrollTableToBottom];
        
            addingModelBufferForEmail = model;
            [self proceedWithAskingAboutAddingCarToDb];
        }
    }
}

#pragma mark Table methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1; // editing is allowed for user cars only
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AutoModel *modelToDelete = [userDefinedData objectAtIndex:indexPath.row];
        [DataManager deleteCustomModel:modelToDelete.modelId];
        
        [self updateTableSourceDataWithNewContentType:currentContentType];
        [self.tableAutos reloadData];
        [self scrollTableToBottom];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1 && currentContentType == CONTENT_MODELS ? 30.0 : 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1 && currentContentType == CONTENT_MODELS){ // user cars
        UIToolbar *header = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.tableAutos.bounds.size.width, 30.0)];
        header.barTintColor = [UIColor blackColor];
        header.tintColor = [UIColor lightTextColor];
        
        UIBarButtonItem *fixSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(addCustomCarPressed)];
        fixSpace.width = 40.0;
        NSString *barString = (userDefinedData ? userDefinedData.count : 0) == 0 ? @"Didn't find the model? Add it!" : @"Your custom cars";
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
    [cell.autoLogo.layer setMinificationFilter:kCAFilterTrilinear];
    cell.tag = indexPath.row; // for sublevel picker callback
    cell.autoYearsLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (currentContentType) {
        case CONTENT_AUTOS:{
            Auto *_auto = [data objectAtIndex:indexPath.row];
            cell.autoTitleLabel.text = _auto.name;
            cell.autoLogo.image = _auto.logo128;
            cell.sublevelPickerDelegate = self;
            
            NSInteger modelsCount = [DataManager getModelsCountForAuto:_auto._id];
            cell.autoModelsButton.hidden = modelsCount == 0;
            break;
        }
        case CONTENT_MODELS:{
            if (indexPath.section == 0){ // built-in model
                AutoModel *model = [data objectAtIndex:indexPath.row];
                cell.autoTitleLabel.text = model.name;
                cell.autoYearsLabel.text = model.selectedTextYears;
                cell.autoLogo.image = model.logo128;
                cell.sublevelPickerDelegate = self;
                
                NSInteger submodelsCount = [DataManager getSubmodelsCountOfModel:model.modelId];
                cell.autoModelsButton.hidden = !model.isSelectable || submodelsCount == 0;
                if (!model.isSelectable){
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            } else { // user defined model
                AutoModel *model = [userDefinedData objectAtIndex:indexPath.row];
                cell.autoTitleLabel.text = model.name;
                cell.autoYearsLabel.text = model.selectedTextYears;
                cell.autoLogo.image = model.logo128;
                cell.autoModelsButton.hidden = YES;
            }
            break;
        }
        case CONTENT_SUBMODELS:{
            AutoSubmodel *submodel = [data objectAtIndex:indexPath.row];
            cell.autoTitleLabel.text = submodel.name;
            cell.autoYearsLabel.text = submodel.selectedTextYears;
            cell.autoLogo.image = submodel.logo128;
            cell.autoModelsButton.hidden = YES;
            break;
        }
    }
    
    cell.constraintDetailTextHeight.constant = cell.autoYearsLabel.text.length > 0 ? 10.0 : 0.0;
    
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

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    // 0 is No
    // 1 is Yes about proposing to add auto to the database
    if (buttonIndex == 1){
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        
        picker.mailComposeDelegate = self;
        picker.Subject = @"What about new car?";
        picker.toRecipients = [NSArray arrayWithObject:@"theinstacarapp@facebook.com"];
        // format placeholders order: 1) auto title; 2) model name; 3) start year; 4) end year
        NSString *messageBodyFormat = @"Hi there,\n\nConsider adding the following car to the app cars list:\n\nAuto: %@\nModel: %@\nProduction years:\n    - start: %d\n    - end: %d\n\nThanks!";
        NSString *messageBody = [NSString stringWithFormat:messageBodyFormat, selectedAuto.name, addingModelBufferForEmail.name, addingModelBufferForEmail.startYear, addingModelBufferForEmail.endYear];
        [picker setMessageBody:messageBody isHTML:NO];
        
        [[self topMostController] presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark Mail composer delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
    addingModelBufferForEmail = nil;
}

#pragma mark iCloudHandlerDelegate

-(void)modelsChangedForAutos:(NSArray *)autoIds{
    if (!selectedAuto || currentContentType != CONTENT_MODELS){
        return;
    }
    
    for (NSNumber *autoId in autoIds) {
        if (autoId.intValue == selectedAuto._id){
            [self updateTableSourceDataWithNewContentType:currentContentType];
            [self.tableAutos reloadData];
            [self scrollTableToBottom];
        }
    }
}

#pragma mark private methods

-(void)scrollTableToBottom{
    CGPoint contentOffset = CGPointMake(0, MAX(self.tableAutos.contentSize.height -  self.tableAutos.bounds.size.height, 0)); // 44 is a cell height
    [self.tableAutos setContentOffset:contentOffset animated:YES];
}

-(UIViewController*) topMostController {
    UIViewController *topController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

-(void)proceedWithAskingAboutAddingCarToDb{
    if ([MFMailComposeViewController canSendMail] && addingModelBufferForEmail){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Question" message:@"Would you like us to add this car to the application in the next release?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}

-(void)addCustomCarPressed{
    if ([UserSettings isFullVersion]){ // full version - allow user to add a new car
        if (!customCarForm){
            customCarForm = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"customCarFormVC"];
            customCarForm.customCarDelegate = self;
        }
        customCarForm.autoId = selectedAuto._id;
        customCarForm.logoFilename = selectedAuto.logoName;
        customCarForm.autoName = selectedAuto.name;
    
        [self presentViewController:customCarForm animated:YES completion:nil];
    } else { // open info about Full version
        [self.autoSelectorDelegate userWantsProVersionInfo];
    }
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
