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
#import "FMDB.h"

typedef enum { // Do not change the numbers!
    MODELS_BUILTIN = 0,
    MODELS_DEFINED = 1,
    MODELS_ALL = 2,
} UserModelsDefintion;

@implementation DbManager{
    FMDatabase *fmdb;
}

-(id) init{
    self = [super init];
    if (self){
        [self initDatabase];
    }
    return self;
}

#pragma mark Initialization

-(void) initDatabase{
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
    if ([Utils appVersionDiffers] && YES == oldDbExists){
        // open last db
        const char *lastDbPathUTF = [lastDbPath UTF8String];
        sqlite3 *instacarOldDb;
        if (sqlite3_open(lastDbPathUTF, &instacarOldDb) == SQLITE_OK){
            DLog(@"Old database opened!");
        } else {
            DLog(@"Failed to open old database");
            DLog(@"Info:%s", sqlite3_errmsg(instacarOldDb));
        }
        
        // read custom cars
        customAutosSnapshot = [self getCustomAutosSnapshot];
        DLog(@"%lu custom cars read from the old database", (unsigned long)customAutosSnapshot.count);
        
        // close last
        if (sqlite3_close(instacarOldDb) == SQLITE_OK){
            DLog(@"Old database closed!");
        } else {
            DLog(@"Failed to close old database");
            DLog(@"Info:%s", sqlite3_errmsg(instacarOldDb));
        }
    }
    
    // copy new database from resources to user Documents
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:currDbPath]){
        [self overwriteDbAtPath:currDbPath];
    }

    // finally open current db
    fmdb = [FMDatabase databaseWithPath:currDbPath];
    if ([fmdb open])
    {
        DLog(@"Current database opened!");
    } else {
        DLog(@"Failed to open/create current database");
        DLog(@"Info:%@", [fmdb lastErrorMessage]);
    }
    
    // insert custom cars in new database
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
    
    [fmdb executeUpdate:sql, name];
    
    [self dbCallCheck:[NSString stringWithFormat:@"Added model: %@", name]
               failed:[NSString stringWithFormat:@"Failed to add model %@", name]];
    
    return [self getIdForAutoModel:name ofAuto:autoId];
}

// YES: call OK, otherwise NO
-(BOOL)dbCallCheck:(NSString*)whatDone failed:(NSString*)whatFailed{
    if (![fmdb hadError] && whatDone){
        DLog(@"%@", whatDone);
    } else if (whatFailed){
        DLog(@"%@", whatFailed);
        NSString *str = [fmdb lastErrorMessage];
        DLog(@"Info: %@", str);
        return false;
    }
    return true;
}

-(void)deleteCustomAutoModel:(int)modelId{
    NSString *sql = [NSString stringWithFormat: @"DELETE FROM %@ WHERE %@=%d", T_MODELS, F_ID, modelId];
    [fmdb executeUpdate:sql];
}

-(void)deleteCustomModelsOfAuto:(int)autoId{
    NSString *sql = [NSString stringWithFormat: @"DELETE FROM %@ WHERE %@=%d AND %@=1", T_MODELS, F_AUTO_ID, autoId, F_IS_USER_DEFINED];
    [fmdb executeUpdate:sql];
    DLog(@"Custom models cleared for auto id: %d", autoId);
}

-(void)restoreCustomAutosFromSnapshot:(NSDictionary*)snapshot{
    [fmdb beginTransaction];
    for (NSString *keyStr in snapshot.allKeys) {
        NSArray *models = [snapshot valueForKey:keyStr];
        for (AutoModel *model in models) {
            [self addCustomAutoModel:model.name ofAuto:keyStr.intValue logo:model.logoName startYear:model.startYear endYear:model.endYear];
        }
    }
    [fmdb commit];
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

-(void)addIcons:(NSDictionary*)icons{ // Key: path, Value: image
    if (icons.count == 0)
        return;
    
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@) VALUES (?, ?)", T_ICONS, F_FILENAME, F_DATA];
    
    [fmdb beginTransaction];
    for (NSString *iconPath in icons.allKeys) {
        NSData *iconData = UIImagePNGRepresentation([icons objectForKey:iconPath]);
        [fmdb executeUpdate:sql, iconPath, iconData];

    }
    [fmdb commit];
    
    [self dbCallCheck: @"Icons added" failed: @"Failed to add icons"];
}

#pragma mark Getting data public methods

-(int)getIdOfAutoTheModelBelongsTo:(int)modelId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%d", F_AUTO_ID, T_MODELS, F_ID, modelId];
    
    FMResultSet *set = [fmdb executeQuery:querySQL];
    
    return [set next] ? [set intForColumnIndex:0] : -1;
}

-(int)getIdOfAutoWithIndependentId:(NSUInteger)indId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%lu", F_ID, T_AUTOS, F_IND_ID, (unsigned long)indId];
    
    FMResultSet *set = [fmdb executeQuery:querySQL];
    
    if (![self dbCallCheck:0 failed:@"Error getting auto database id"] || ![set next])
        return -1;
    
    return [set intForColumnIndex:0];
}

-(int)getIndependentIdOfAutoWithDbId:(NSUInteger)dbId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%lu", F_IND_ID, T_AUTOS, F_ID, (unsigned long)dbId];
    
    FMResultSet *set = [fmdb executeQuery:querySQL];
    
    if (![self dbCallCheck:0 failed:@"Error getting auto independent id"] || ![set next])
        return -1;
    
    return [set intForColumnIndex:0];
}

-(NSArray*)getAllAutos{
    NSMutableArray *mutableAutos = [[NSMutableArray alloc] init];
    
    //                                                        id     name   logo   asName country
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@.%@, %@.%@, %@.%@, %@.%@, %@.%@ FROM %@, %@, %@ WHERE %@.%@=%@.%@ AND %@.%@=%@.%@ ORDER BY %@.%@", T_AUTOS, F_ID, T_AUTOS, F_NAME, T_LOGOS, F_NAME, T_AUTOS, F_LOGO_AS_NAME, T_COUNTRIES, F_NAME, T_AUTOS, T_LOGOS, T_COUNTRIES, T_AUTOS, F_LOGO_ID, T_LOGOS, F_ID, T_AUTOS, F_COUNTRY_ID, T_COUNTRIES, F_ID, T_AUTOS, F_NAME];
    
    FMResultSet *set = [fmdb executeQuery:querySQL];
    
    while ([set next]) {
        Auto *_auto = [[Auto alloc] initWithId:[set intForColumnIndex:0]
                                            name:[set stringForColumnIndex:1]
                                            logo:[set stringForColumnIndex:2]
                                    logoAsName:[set intForColumnIndex:3]
                                        country:[set stringForColumnIndex:4]];
        [mutableAutos addObject:_auto];
    }
    return [[NSArray alloc] initWithArray:mutableAutos];
}

-(NSInteger)getModelsCountForAuto:(NSUInteger)autoId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT COUNT(%@) FROM %@ WHERE %@=%lu", F_ID, T_MODELS, F_AUTO_ID, (unsigned long)autoId];
    
    FMResultSet *set = [fmdb executeQuery:querySQL];
    
    return [set next] ? [set intForColumnIndex:0] : 0;
}

-(NSArray*)getBuiltInModelsOfAuto:(NSUInteger)autoId{
    return [self getModelsOfAuto:autoId definedByUser:MODELS_BUILTIN];
}

-(NSArray*)getUserDefinedModelsOfAuto:(NSUInteger)autoId{
    return [self getModelsOfAuto:autoId definedByUser:MODELS_DEFINED];
}

-(NSInteger)getSubmodelsCountOfModel:(NSUInteger)modelId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT COUNT(%@) FROM %@ WHERE %@=%lu", F_ID, T_SUBMODELS, F_MODEL_ID, (unsigned long)modelId];
    
    FMResultSet *set = [fmdb executeQuery:querySQL];
    
    return [set next] ? [set intForColumnIndex:0] : 0;
}

-(NSArray*)getSubmodelsOfModel:(NSUInteger)modelId{
    NSMutableArray *mutableSubmodels = [[NSMutableArray alloc] init];
    
    //                                                        name   logo   sYear  eYear
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@.%@, %@.%@, %@.%@, %@.%@ FROM %@, %@ WHERE %@.%@=%@.%@ AND %@.%@=%lu ORDER BY %@.%@", T_SUBMODELS, F_NAME, T_LOGOS, F_NAME, T_SUBMODELS, F_YEAR_START, T_SUBMODELS, F_YEAR_END, T_SUBMODELS, T_LOGOS, T_SUBMODELS, F_LOGO_ID, T_LOGOS, F_ID, T_SUBMODELS, F_MODEL_ID, (unsigned long)modelId, T_SUBMODELS, F_NAME];
    
    FMResultSet *set = [fmdb executeQuery:querySQL];
    
    while ([set next]) {
        AutoSubmodel *submodel = [[AutoSubmodel alloc] initWithName:[set stringForColumnIndex:0]];
        submodel.logoName = [set stringForColumnIndex:1];
        submodel.startYear = [set intForColumnIndex:2];
        submodel.endYear = [set intForColumnIndex:3];
            
        [mutableSubmodels addObject:submodel];
    }
    
    return [[NSArray alloc] initWithArray:mutableSubmodels];
}

-(UIImage*)getIconForPath:(NSString*)path{
    if (!path){
        return nil;
    }
    
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=?", F_DATA, T_ICONS, F_FILENAME];
    
    FMResultSet *set = [fmdb executeQuery:querySQL, path];
    
    if (![set next]){
        DLog(@"Icon not found");
        return nil;
    }
    
    NSData *iconData = [set dataForColumnIndex:0];
    
    return iconData ? [UIImage imageWithData:iconData] : nil;
}

#pragma mark Getting data private methods

-(BOOL)existUserModel:(NSString*)name ofAuto:(int)autoId withLogoId:(int)logoId startYear:(int)startYear endYear:(int)endYear{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT COUNT(%@) FROM %@ WHERE %@=? AND %@=%d AND %@=%d AND %@=%d AND %@=%d AND %@=1", F_ID, T_MODELS, F_NAME, F_AUTO_ID, autoId, F_LOGO_ID, logoId, F_YEAR_START, startYear, F_YEAR_END, endYear, F_IS_USER_DEFINED];
    
    FMResultSet *set = [fmdb executeQuery:querySQL, name];
    
    return [set next] ? [set intForColumnIndex:0] != 0 : 0;
}

-(NSArray*)getModelsOfAuto:(NSUInteger)autoId definedByUser:(UserModelsDefintion)userModelDefinition{
    NSMutableArray *mutableModels = [[NSMutableArray alloc] init];
    
    //                                                           id     name   logo   sYear  eYear  sel    usrDef
    NSString *queryAllSQL = [NSString stringWithFormat: @"SELECT %@.%@, %@.%@, %@.%@, %@.%@, %@.%@, %@.%@, %@.%@ FROM %@, %@ WHERE %@.%@=%@.%@ AND %@.%@=%lu", T_MODELS, F_ID, T_MODELS, F_NAME, T_LOGOS, F_NAME, T_MODELS, F_YEAR_START, T_MODELS, F_YEAR_END, T_MODELS, F_SELECTABLE, T_MODELS, F_IS_USER_DEFINED, T_MODELS, T_LOGOS, T_MODELS, F_LOGO_ID, T_LOGOS, F_ID, T_MODELS, F_AUTO_ID, (unsigned long)autoId];
    NSString *conditionSQL = @"";
    if (userModelDefinition != MODELS_ALL){
        conditionSQL = [NSString stringWithFormat:@"AND %@.%@=%d", T_MODELS, F_IS_USER_DEFINED, userModelDefinition/*0 or 1*/];
    }
    
    NSString *sql = [NSString stringWithFormat:@"%@ %@ ORDER BY %@.%@", queryAllSQL, conditionSQL, T_MODELS, F_NAME];
    
    FMResultSet *set = [fmdb executeQuery:sql];
    
    while ([set next]) {
        AutoModel *model = [[AutoModel alloc] initWithId:[set intForColumnIndex:0] andName:[set stringForColumnIndex:1]];
        model.logoName = [set stringForColumnIndex:2];
        model.startYear = [set intForColumnIndex:3];
        model.endYear = [set intForColumnIndex:4];
        model.isSelectable = [set intForColumnIndex:5];
        model.isUserDefined = [set intForColumnIndex:6];
            
        [mutableModels addObject:model];
    }
    
    return mutableModels;
}

-(int)getIdForLogo:(NSString*)filename{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=?", F_ID, T_LOGOS, F_NAME];
    FMResultSet *set = [fmdb executeQuery:querySQL, filename];
    
    if (![set next]){
        DLog(@"Logo not found");
        return -1;
    }
    
    return [set intForColumnIndex:0];
}

-(int)getIdForAuto:(NSString*)name country:(int)countryId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=? AND %@=%d", F_ID, T_AUTOS, F_NAME, F_COUNTRY_ID, countryId];
    
    FMResultSet *set = [fmdb executeQuery:querySQL, name];
    
    if (![set next]){
        DLog(@"Auto not found");
        return -1;
    }
    
    return [set intForColumnIndex:0];
}

-(int)getIdForAutoModel:(NSString*)name ofAuto:(int)autoId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=? AND %@=%d", F_ID, T_MODELS, F_NAME, F_AUTO_ID, autoId];
    FMResultSet *set = [fmdb executeQuery:querySQL, name];
    
    if (![set next]){
        DLog(@"Model not found");
        return -1;
    }
    
    return [set intForColumnIndex:0];
}

-(NSArray*)getAutoIdsWhereCustomModelsDefined{ // type: NSNumber
    NSMutableArray *mutableIds = [[NSMutableArray alloc] init];
    
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@.%@ FROM %@, %@ WHERE %@.%@=%@.%@ AND %@.%@=1", T_AUTOS, F_ID, T_AUTOS, T_MODELS, T_MODELS, F_AUTO_ID, T_AUTOS, F_ID, T_MODELS, F_IS_USER_DEFINED];
    
    FMResultSet *set = [fmdb executeQuery:querySQL];
    
    while ([set next]){
        [mutableIds addObject:[NSNumber numberWithInt:[set intForColumnIndex:0]]];
    }
             
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