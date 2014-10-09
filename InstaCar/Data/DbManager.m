//
//  DbHelper.m
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import "DbManager.h"
#import "sqlite3.h"
#import "DataManager.h"

typedef enum { // Do not change the numbers!
    MODELS_BUILTIN = 0,
    MODELS_DEFINED = 1,
    MODELS_ALL = 2,
} UserModelsDefintion;

@implementation DbManager{
    sqlite3 *instacarDb;
    BOOL firstLaunch;
    BOOL isOpened;
}

-(id) init{
    self = [super init];
    if (self){
        firstLaunch = YES;
        isOpened = NO;
        [self open];
    }
    return self;
}

-(void) open{
    [self initDatabase];
}
-(void) close{
    sqlite3_close(instacarDb);
    isOpened = NO;
}

#pragma mark Initialization

-(void) initDatabase{
    if (isOpened)
        return;
    
    // Get the documents directory
    NSArray* dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    NSString *lastDbName = [NSString stringWithFormat:@"%@%@", [DataManager isFullVersion] ? DB_NAME_PRO : DB_NAME_FREE, DB_NAME_LAST_VER];
    NSString *currDbName = [NSString stringWithFormat:@"%@%@", [DataManager isFullVersion] ? DB_NAME_PRO : DB_NAME_FREE, DB_NAME_CURR_VER];
    
    NSString* lastDbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: lastDbName]];
    NSString* currDbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: currDbName]];
    
    NSDictionary *customAutosSnapshot = [[NSDictionary alloc] init];
    BOOL oldDbExists = [[NSFileManager defaultManager] fileExistsAtPath:lastDbPath];
    if (firstLaunch){ // tha app is opening at first launch, not being loaded from the background
        if ([Utils appVersionDiffers] && YES == oldDbExists){
            // open last db
            const char *lastDbPathUTF = [lastDbPath UTF8String];
            if (sqlite3_open(lastDbPathUTF, &instacarDb) == SQLITE_OK){
                DLog(@"Old database opened!");
            } else {
                DLog(@"Failed to open old database");
                DLog(@"Info:%s", sqlite3_errmsg(instacarDb));
            }
        
            // read custom cars
            customAutosSnapshot = [self getCustomAutosSnapshot];
            DLog(@"%lu custom cars read from the old database", (unsigned long)customAutosSnapshot.count);
            
            // close last
            if (sqlite3_close(instacarDb) == SQLITE_OK){
                DLog(@"Old database closed!");
            } else {
                DLog(@"Failed to close old database");
                DLog(@"Info:%s", sqlite3_errmsg(instacarDb));
            }
        }
    
        // copy new database from resources to user Documents
        if (NO == [[NSFileManager defaultManager] fileExistsAtPath:currDbPath]){
            [self overwriteDbAtPath:currDbPath];
        }
    }
    
    // finally open current db
    const char *dbpath = [currDbPath UTF8String];
    if (sqlite3_open(dbpath, &instacarDb) == SQLITE_OK)
    {
        DLog(@"Current database opened!");
        isOpened = YES;
    } else {
        DLog(@"Failed to open/create current database");
        DLog(@"Info:%s", sqlite3_errmsg(instacarDb));
    }
    
    if (firstLaunch){
        // insert custom cars in new
        [self restoreCustomAutosFromSnapshot:customAutosSnapshot];
    
        // update app version
        [UserSettings setStoredAppVersion];
    
        // delete the old database
        if (YES == oldDbExists){
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:lastDbPath error:&error];
            if (error){
                DLog(@"Error deleting old db file: %@", error.localizedDescription);
            } else {
                DLog(@"The old database deleted");
            }
        }
    }
    
    firstLaunch = NO;
}

-(void)overwriteDbAtPath:(NSString*)databasePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Check to see if the database file already exists
    bool databaseAlreadyExists = [fileManager fileExistsAtPath:databasePath];
    if (databaseAlreadyExists){
        DLog(@"Database found. Deleting...");
        NSError *error = nil;
        [fileManager removeItemAtPath:databasePath error:&error];
        if (error){
            DLog(@"Error deleting db file: %@", error.localizedDescription);
        } else {
            DLog(@"Database deleted");
            databaseAlreadyExists = false;
        }
    } else {
        DLog(@"Database not found. Creating...");
    }
    
    // Create the database if it doesn't exist in the file system
    if (!databaseAlreadyExists)
    {
        NSString *databasePathFromApp = [[NSBundle mainBundle] pathForResource:DB_NAME_RES ofType:@"sqlite"];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
        
        DLog(@"Database created");
    } else {
        DLog(@"Database couldn't be deleted. What now? :(");
        // TODO: what to do if there was an error deleting db from bundle?
    }
}

#pragma mark -
#pragma mark Saving data private methods

-(int)addUserDefinedAutoModel:(NSString*)name ofAuto:(int)autoId logo:(int)logoId startYear:(int)startYear endYear:(int)endYear{
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@) VALUES (?, %d, %d, %d, %d, 1, 1)", T_MODELS, F_NAME, F_AUTO_ID, F_LOGO_ID, F_YEAR_START, F_YEAR_END, F_SELECTABLE, F_IS_USER_DEFINED, autoId, logoId, startYear, endYear]; // 1, 1 stand for selectable and user defined flags
    
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            DLog(@"Added model: %@", name);
        } else {
            DLog(@"Failed to add model %@", name);
            DLog(@"Info:%s", sqlite3_errmsg(instacarDb));
        }
    } else {
        DLog(@"Error:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return [self getIdForAutoModel:name ofAuto:autoId];
}

-(void)deleteCustomAutoModel:(int)modelId{
    NSString *sql = [NSString stringWithFormat: @"DELETE FROM %@ WHERE %@=%d", T_MODELS, F_ID, modelId];
    const char *delete_stmt = [sql UTF8String];
    sqlite3_exec(instacarDb, delete_stmt, NULL, NULL, NULL);
}

-(void)deleteCustomModelsOfAuto:(int)autoId{
    NSString *sql = [NSString stringWithFormat: @"DELETE FROM %@ WHERE %@=%d AND %@=1", T_MODELS, F_AUTO_ID, autoId, F_IS_USER_DEFINED];
    const char *delete_stmt = [sql UTF8String];
    sqlite3_exec(instacarDb, delete_stmt, NULL, NULL, NULL);
    DLog(@"Custom models cleared for auto id: %d", autoId);
}

-(void)restoreCustomAutosFromSnapshot:(NSDictionary*)snapshot{
    for (NSString *keyStr in snapshot.allKeys) {
        NSArray *models = [snapshot valueForKey:keyStr];
        for (AutoModel *model in models) {
            [self addCustomAutoModel:model.name ofAuto:keyStr.intValue logo:model.logoName startYear:model.startYear endYear:model.endYear];
        }
    }
}

#pragma mark Saving data public methods

-(int)addCustomAutoModel:(NSString*)name ofAuto:(int)autoId logo:(NSString*)logoFileName startYear:(int)startYear endYear:(int)endYear{
    int logoId = [self getIdForLogo:logoFileName];
    
    BOOL suchCustomModelExists = [self existUserModel:name ofAuto:autoId withLogoId:logoId startYear:startYear endYear:endYear];
    
    if(!suchCustomModelExists){
        return [self addUserDefinedAutoModel:name ofAuto:autoId logo:logoId startYear:startYear endYear:endYear];
    }
    
    return -1;
}

-(void)addIcon:(UIImage*)icon forPath:(NSString*)iconPath{
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@) VALUES (?, ?)", T_ICONS, F_FILENAME, F_DATA];
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [iconPath cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        NSData *iconData = UIImagePNGRepresentation(icon);
        sqlite3_bind_blob(statement, 2, iconData.bytes, (int)iconData.length, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            DLog(@"Added icon: %@", iconPath);
        } else {
            DLog(@"Failed to add icon %@", iconPath);
            DLog(@"Info:%s", sqlite3_errmsg(instacarDb));
        }
    } else {
        DLog(@"Error:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);    
}


#pragma mark Getting data public methods

-(int)getIdOfAutoTheModelBelongsTo:(int)modelId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%d", F_AUTO_ID, T_MODELS, F_ID, modelId];
    const char *query_stmt = [querySQL UTF8String];
    int _id = -1;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            _id = sqlite3_column_int(statement, 0);
        } else {
            DLog(@"Error getting auto by model id");
        }
    } else {
        DLog(@"Error getting auto for Model is:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return _id;
}

-(int)getIdOfAutoWithIndependentId:(NSUInteger)indId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%lu", F_ID, T_AUTOS, F_IND_ID, (unsigned long)indId];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = -1;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            result = sqlite3_column_int(statement, 0);
        } else{
            DLog(@"Error getting auto database id");
        }
    }
    sqlite3_finalize(statement);
    
    return result;
}

-(int)getIndependentIdOfAutoWithDbId:(NSUInteger)dbId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%lu", F_IND_ID, T_AUTOS, F_ID, (unsigned long)dbId];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = -1;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            result = sqlite3_column_int(statement, 0);
        } else{
            DLog(@"Error getting auto independent id");
        }
    }
    sqlite3_finalize(statement);
    
    return result;
}

-(NSArray*)getAllAutos{
    NSMutableArray *mutableAutos = [[NSMutableArray alloc] init];
    
    //                                                        id     name   logo   asName country
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@.%@, %@.%@, %@.%@, %@.%@, %@.%@ FROM %@, %@, %@ WHERE %@.%@=%@.%@ AND %@.%@=%@.%@ ORDER BY %@.%@", T_AUTOS, F_ID, T_AUTOS, F_NAME, T_LOGOS, F_NAME, T_AUTOS, F_LOGO_AS_NAME, T_COUNTRIES, F_NAME, T_AUTOS, T_LOGOS, T_COUNTRIES, T_AUTOS, F_LOGO_ID, T_LOGOS, F_ID, T_AUTOS, F_COUNTRY_ID, T_COUNTRIES, F_ID, T_AUTOS, F_NAME];
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            int idField = sqlite3_column_int(statement, 0);
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            NSString *logoField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            BOOL logoAsName = sqlite3_column_int(statement, 3);
            NSString *countryField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
            
            Auto *_auto = [[Auto alloc] initWithId: idField name:nameField logo:logoField logoAsName:logoAsName country:countryField];
            [mutableAutos addObject:_auto];
        }
    } else {
        DLog(@"Failed to query auto");
        DLog(@"Info:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
        
    return [[NSArray alloc] initWithArray:mutableAutos];
}

-(NSInteger)getModelsCountForAuto:(NSUInteger)autoId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT COUNT(%@) FROM %@ WHERE %@=%lu", F_ID, T_MODELS, F_AUTO_ID, (unsigned long)autoId];
    const char *query_stmt = [querySQL UTF8String];
        
    int result = 0;
        
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            result = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
        
    return result;
}

-(NSArray*)getBuiltInModelsOfAuto:(NSUInteger)autoId{
    return [self getModelsOfAuto:autoId definedByUser:MODELS_BUILTIN];
}

-(NSArray*)getUserDefinedModelsOfAuto:(NSUInteger)autoId{
    return [self getModelsOfAuto:autoId definedByUser:MODELS_DEFINED];
}

-(NSInteger)getSubmodelsCountOfModel:(NSUInteger)modelId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT COUNT(%@) FROM %@ WHERE %@=%lu", F_ID, T_SUBMODELS, F_MODEL_ID, (unsigned long)modelId];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = 0;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            result = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    
    return result;
}

-(NSArray*)getSubmodelsOfModel:(NSUInteger)modelId{
    NSMutableArray *mutableSubmodels = [[NSMutableArray alloc] init];
    
    //                                                        name   logo   sYear  eYear
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@.%@, %@.%@, %@.%@, %@.%@ FROM %@, %@ WHERE %@.%@=%@.%@ AND %@.%@=%lu ORDER BY %@.%@", T_SUBMODELS, F_NAME, T_LOGOS, F_NAME, T_SUBMODELS, F_YEAR_START, T_SUBMODELS, F_YEAR_END, T_SUBMODELS, T_LOGOS, T_SUBMODELS, F_LOGO_ID, T_LOGOS, F_ID, T_SUBMODELS, F_MODEL_ID, (unsigned long)modelId, T_SUBMODELS, F_NAME];
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            NSString *logoField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            
            AutoSubmodel *submodel = [[AutoSubmodel alloc] initWithName:nameField];
            submodel.logoName = logoField;
            submodel.startYear = sqlite3_column_int(statement, 2);
            submodel.endYear = sqlite3_column_int(statement, 3);
            
            [mutableSubmodels addObject:submodel];
        }
    } else {
        DLog(@"Failed to query submodel");
        DLog(@"Info:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return [[NSArray alloc] initWithArray:mutableSubmodels];
}

-(UIImage*)getIconForPath:(NSString*)path{
    if (!path){
        return nil;
    }
    
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=?", F_DATA, T_ICONS, F_FILENAME];
    const char *query_stmt = [querySQL UTF8String];
    UIImage *icon = nil;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, 1, [path cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSUInteger blobLength = sqlite3_column_bytes(statement, 0);
            NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(statement, 0) length:blobLength];
            if (imageData){
                icon = [UIImage imageWithData:imageData];
            }
        } else {
            DLog(@"Icon not found");
        }
    } else {
        DLog(@"Error getting data for icon: %s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return icon;
}

#pragma mark Getting data private methods

-(BOOL)existUserModel:(NSString*)name ofAuto:(int)autoId withLogoId:(int)logoId startYear:(int)startYear endYear:(int)endYear{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT COUNT(%@) FROM %@ WHERE %@=? AND %@=%d AND %@=%d AND %@=%d AND %@=%d AND %@=1", F_ID, T_MODELS, F_NAME, F_AUTO_ID, autoId, F_LOGO_ID, logoId, F_YEAR_START, startYear, F_YEAR_END, endYear, F_IS_USER_DEFINED];
    
    const char *query_stmt = [querySQL UTF8String];
        
    int result = 0;
        
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_ROW){
            result = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    
    return result != 0;
}

-(NSArray*)getModelsOfAuto:(NSUInteger)autoId definedByUser:(UserModelsDefintion)userModelDefinition{
    NSMutableArray *mutableModels = [[NSMutableArray alloc] init];
    
    //                                                           id     name   logo   sYear  eYear  sel    usrDef
    NSString *queryAllSQL = [NSString stringWithFormat: @"SELECT %@.%@, %@.%@, %@.%@, %@.%@, %@.%@, %@.%@, %@.%@ FROM %@, %@ WHERE %@.%@=%@.%@ AND %@.%@=%lu", T_MODELS, F_ID, T_MODELS, F_NAME, T_LOGOS, F_NAME, T_MODELS, F_YEAR_START, T_MODELS, F_YEAR_END, T_MODELS, F_SELECTABLE, T_MODELS, F_IS_USER_DEFINED, T_MODELS, T_LOGOS, T_MODELS, F_LOGO_ID, T_LOGOS, F_ID, T_MODELS, F_AUTO_ID, (unsigned long)autoId];
    NSString *conditionSQL = @"";
    if (userModelDefinition != MODELS_ALL){
        conditionSQL = [NSString stringWithFormat:@"AND %@.%@=%d", T_MODELS, F_IS_USER_DEFINED, userModelDefinition/*0 or 1*/];
    }
    const char *query_stmt = [[NSString stringWithFormat:@"%@ %@ ORDER BY %@.%@", queryAllSQL, conditionSQL, T_MODELS, F_NAME] UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            int modelId = sqlite3_column_int(statement, 0);
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            NSString *logoField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            
            AutoModel *model = [[AutoModel alloc] initWithId:modelId andName:nameField];
            model.logoName = logoField;
            model.startYear = sqlite3_column_int(statement, 3);
            model.endYear = sqlite3_column_int(statement, 4);
            model.isSelectable = sqlite3_column_int(statement, 5);
            model.isUserDefined = sqlite3_column_int(statement, 6);
            
            [mutableModels addObject:model];
        }
    } else {
        DLog(@"Failed to query model");
        DLog(@"Info:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return mutableModels;
}

-(int)getIdForLogo:(NSString*)filename{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=?", F_ID, T_LOGOS, F_NAME];
    const char *query_stmt = [querySQL UTF8String];
    int _id = -1;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, 1, [filename cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            _id = sqlite3_column_int(statement, 0);
        } else {
            DLog(@"Logo not found");
        }
    } else {
        DLog(@"Error getting id for Logo:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return _id;
}

-(int)getIdForAuto:(NSString*)name country:(int)countryId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=? AND %@=%d", F_ID, T_AUTOS, F_NAME, F_COUNTRY_ID, countryId];
    const char *query_stmt = [querySQL UTF8String];
    int _id = -1;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            _id = sqlite3_column_int(statement, 0);
        } else {
            DLog(@"Auto not found");
        }
    } else {
        DLog(@"Error getting id for Auto:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return _id;
}

-(int)getIdForAutoModel:(NSString*)name ofAuto:(int)autoId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=? AND %@=%d", F_ID, T_MODELS, F_NAME, F_AUTO_ID, autoId];
    const char *query_stmt = [querySQL UTF8String];
    int _id = -1;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            _id = sqlite3_column_int(statement, 0);
        } else {
            DLog(@"Model not found");
        }
    } else {
        DLog(@"Error getting id for Model:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return _id;
}

-(NSArray*)getAutoIdsWhereCustomModelsDefined{ // type: NSNumber
    NSMutableArray *mutableIds = [[NSMutableArray alloc] init];
    
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@.%@ FROM %@, %@ WHERE %@.%@=%@.%@ AND %@.%@=1", T_AUTOS, F_ID, T_AUTOS, T_MODELS, T_MODELS, F_AUTO_ID, T_AUTOS, F_ID, T_MODELS, F_IS_USER_DEFINED];
    
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            int autoId = sqlite3_column_int(statement, 0);
            
            [mutableIds addObject:[NSNumber numberWithInt:autoId]];
        }
    } else {
        DLog(@"Failed to query auto ids");
        DLog(@"Info:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return mutableIds;
}

-(NSMutableDictionary*)getCustomAutosSnapshot{ // key: NSString auto id (uint); value: NSArray models
    NSArray *autosWithCustomModels = [self getAutoIdsWhereCustomModelsDefined];
    
    NSMutableDictionary *customModelsDict = [[NSMutableDictionary alloc] init];
    for (NSNumber *autoId in autosWithCustomModels) {
        NSArray *customModelsArray = [self getUserDefinedModelsOfAuto:autoId.unsignedIntValue];
        [customModelsDict setValue:customModelsArray forKeyPath:autoId.stringValue];
    }
    return  customModelsDict;
}

@end