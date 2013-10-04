//
//  DbHelper.m
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import "DbManager.h"
#import "DBDefinition.h"
#import "sqlite3.h"

@implementation DbManager{
    sqlite3 *instacarDb;
}

-(id) init{
    self = [super init];
    if (self){
        [self initDatabase];
        
        if ([Utils appVersionDiffers]){
            [self initData];
            [UserSettings setStoredAppVersion]; // TODO: uncomment in production
        }
    }
    return self;
}

-(void) open{
    [self initDatabase];
}

-(void) close{
    sqlite3_close(instacarDb);
}

#pragma mark Initialization

-(void) initDatabase{
    // Get the documents directory
    NSArray* dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    NSString* databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: DATABASE_NAME]];
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &instacarDb) == SQLITE_OK)
    {
        if ([Utils appVersionDiffers]){
            [self eraseTables];
        }
        
        [self createTables];
    } else {
        NSLog(@"Failed to open/create database");
        NSLog(@"Info:%s", sqlite3_errmsg(instacarDb));
    }
}

-(void)eraseTables{
    // TODO: change for production
    //NSString *eraseSql = [NSString stringWithFormat:@"DELETE FROM %@;DELETE FROM %@;DELETE FROM %@;DELETE FROM %@;DELETE FROM %@;DELETE FROM %@;", T_SUBMODELS, T_MODELS, T_AUTOS, T_LOGOS, T_COUNTRIES, T_ICONS]; // production query
    NSString *eraseSql = [NSString stringWithFormat:@"DELETE FROM %@;DELETE FROM %@;DELETE FROM %@;DELETE FROM %@;DELETE FROM %@;", T_SUBMODELS, T_MODELS, T_AUTOS, T_LOGOS, T_COUNTRIES]; // development query
    char *err;
    if (sqlite3_exec(instacarDb, [eraseSql UTF8String], nil, nil, &err) == SQLITE_OK){
        NSLog(@"Tables erased");
    } else {
        NSLog(@"Table erase failed: %@", [NSString stringWithUTF8String:err]);
        sqlite3_free(err);
    }
}

-(void)createTables{
    DBDefinition* dbDef = [[DBDefinition alloc] init];
    char *err;
    for (NSString *sql in [dbDef getTablesCreationQueries]) {
        if (sqlite3_exec(instacarDb, [sql UTF8String], nil, nil, &err) == SQLITE_OK){
            NSLog(@"Table created");
        } else {
            NSLog(@"Table creation failed: %@", [NSString stringWithUTF8String:err]);
            sqlite3_free(err);
        }
    }
}

-(void)initData{
    int countryId;
    int logoId;
    int autoId;
    int modelId;
    
    // Countries
    // A
    // B
    // C
    // D
    // E
    // F
    // G
#pragma mark === Germany ===
    countryId = [self addCountry:@"Germany"];
#pragma mark |---- BMW
    logoId = [self addLogo:@"bmw_256.png"];
    autoId = [self addAuto:@"BMW" country:countryId logo:logoId];
    modelId = [self addAutoModel:@"1 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"E81" ofModel:modelId logo:logoId startYear:2004 endYear:2012];
        [self addAutoSubmodel:@"E82" ofModel:modelId logo:logoId startYear:2007 endYear:0];
        [self addAutoSubmodel:@"E87" ofModel:modelId logo:logoId startYear:2004 endYear:2012];
        [self addAutoSubmodel:@"E88" ofModel:modelId logo:logoId startYear:2007 endYear:0];
        [self addAutoSubmodel:@"F20" ofModel:modelId logo:logoId startYear:2011 endYear:0];
        [self addAutoSubmodel:@"F21" ofModel:modelId logo:logoId startYear:2011 endYear:0];
    }
    [self addAutoModel:@"1x Convertible" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"1x Coupe" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"1x M Coupe" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    
    [self addAutoModel:@"3x GT" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    modelId = [self addAutoModel:@"3 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"E46" ofModel:modelId logo:logoId startYear:2001 endYear:2005];
    }
    [self addAutoModel:@"3x Compact" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"3x Convertible" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"3x Compact" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"3x Coupe" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"4 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    modelId = [self addAutoModel:@"5 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"E34" ofModel:modelId logo:logoId startYear:1990 endYear:1998];
    }
    [self addAutoModel:@"6 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"6x Convertible" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"7 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"8 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"Gran Turismo" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"M Coupe" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"M3" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"M3 Convertible" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"M3 Coupe" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"M5" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"M6" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    modelId = [self addAutoModel:@"X Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"X1" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"X3" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"X4" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"X5" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"X5 M" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"X6" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"X6 M" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
    modelId = [self addAutoModel:@"Z Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"Z1" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Z3" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Z4" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Z4 Coupe" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Z4 M Coupe" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Z4 M Roadster" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Z8" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
#pragma mark |---- Mercedes
    logoId = [self addLogo:@"mercedes_256.png"];
    autoId = [self addAuto:@"Mercedes-Benz" country:countryId logo:logoId];
    modelId = [self addAutoModel:@"A class" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"W168" ofModel:modelId logo:logoId startYear:1997 endYear:2004];
        [self addAutoSubmodel:@"W169" ofModel:modelId logo:logoId startYear:2004 endYear:2012];
        [self addAutoSubmodel:@"W176" ofModel:modelId logo:logoId startYear:2012 endYear:0];
    }
    modelId = [self addAutoModel:@"B class" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"W245" ofModel:modelId logo:logoId startYear:2005 endYear:2011];
        [self addAutoSubmodel:@"W246" ofModel:modelId logo:logoId startYear:2011 endYear:0];
    }
    modelId = [self addAutoModel:@"C class" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"W202" ofModel:modelId logo:logoId startYear:1993 endYear:2000];
        [self addAutoSubmodel:@"W203" ofModel:modelId logo:logoId startYear:2011 endYear:2007];
        [self addAutoSubmodel:@"W204" ofModel:modelId logo:logoId startYear:2008 endYear:0];
    }
    modelId = [self addAutoModel:@"E class" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"W123" ofModel:modelId logo:logoId startYear:1976 endYear:1985];
        [self addAutoSubmodel:@"W124" ofModel:modelId logo:logoId startYear:1985 endYear:1996];
        [self addAutoSubmodel:@"W210" ofModel:modelId logo:logoId startYear:1995 endYear:2003];
        [self addAutoSubmodel:@"W211" ofModel:modelId logo:logoId startYear:2002 endYear:2009];
        [self addAutoSubmodel:@"W212" ofModel:modelId logo:logoId startYear:2010 endYear:0];
    }
    modelId = [self addAutoModel:@"G class" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"W460" ofModel:modelId logo:logoId startYear:1979 endYear:1991];
        // TODO: add sub sub models
        [self addAutoSubmodel:@"W461" ofModel:modelId logo:logoId startYear:1979 endYear:0];
        [self addAutoSubmodel:@"W463" ofModel:modelId logo:logoId startYear:1990 endYear:0];
    }
    modelId = [self addAutoModel:@"M class" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"W163" ofModel:modelId logo:logoId startYear:1997 endYear:2005];
        [self addAutoSubmodel:@"W164" ofModel:modelId logo:logoId startYear:2005 endYear:2011];
        [self addAutoSubmodel:@"W166" ofModel:modelId logo:logoId startYear:2011 endYear:0];
    }
    modelId = [self addAutoModel:@"R class" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
    modelId = [self addAutoModel:@"S class" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"W108" ofModel:modelId logo:logoId startYear:1965 endYear:1972];
        [self addAutoSubmodel:@"W109" ofModel:modelId logo:logoId startYear:1965 endYear:1972];
        [self addAutoSubmodel:@"W110" ofModel:modelId logo:logoId startYear:1961 endYear:1968];
        [self addAutoSubmodel:@"W111" ofModel:modelId logo:logoId startYear:1959 endYear:1968];
        [self addAutoSubmodel:@"W111 Coupe" ofModel:modelId logo:logoId startYear:1959 endYear:1968];
        [self addAutoSubmodel:@"W112" ofModel:modelId logo:logoId startYear:1961 endYear:1965];
        [self addAutoSubmodel:@"W112 Coupe" ofModel:modelId logo:logoId startYear:1962 endYear:1967];
        [self addAutoSubmodel:@"W113" ofModel:modelId logo:logoId startYear:1963 endYear:1971];
        [self addAutoSubmodel:@"W114" ofModel:modelId logo:logoId startYear:1968 endYear:1976];
        [self addAutoSubmodel:@"W115" ofModel:modelId logo:logoId startYear:1968 endYear:1976];
        [self addAutoSubmodel:@"W116" ofModel:modelId logo:logoId startYear:1972 endYear:1980];
        [self addAutoSubmodel:@"W120" ofModel:modelId logo:logoId startYear:1953 endYear:1962];
        [self addAutoSubmodel:@"W121" ofModel:modelId logo:logoId startYear:1956 endYear:1961];
        [self addAutoSubmodel:@"W126" ofModel:modelId logo:logoId startYear:1979 endYear:1992];
        [self addAutoSubmodel:@"W140" ofModel:modelId logo:logoId startYear:1991 endYear:1998];
        [self addAutoSubmodel:@"W220" ofModel:modelId logo:logoId startYear:1998 endYear:2005];
        [self addAutoSubmodel:@"W221" ofModel:modelId logo:logoId startYear:2005 endYear:2013];
        [self addAutoSubmodel:@"W222" ofModel:modelId logo:logoId startYear:2014 endYear:0];
    }
}

#pragma mark -
#pragma mark Saving data private methods

-(int)addCountry:(NSString*)name{
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@) VALUES (?)", T_COUNTRIES, F_NAME];
    
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Added country: %@", name);
        } else {
            NSLog(@"Failed to add country %@", name);
            NSLog(@"Info:%s", sqlite3_errmsg(instacarDb));
        }
    } else {
        NSLog(@"Error:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return [self getIdForCountry:name];
}

-(int)addLogo:(NSString*)filename{
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@) VALUES (?)", T_LOGOS, F_NAME];
    
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [filename cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Added logo: %@", filename);
        } else {
            NSLog(@"Failed to add logo %@", filename);
            NSLog(@"Info:%s", sqlite3_errmsg(instacarDb));
        }
    } else {
        NSLog(@"Error:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return [self getIdForLogo:filename];
}

-(int)addAuto:(NSString*)name country:(int)countryId logo:(int)logoId{
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@) VALUES (?, %d, %d)", T_AUTOS, F_NAME, F_COUNTRY_ID, F_LOGO_ID, countryId, logoId];
    
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Added auto: %@", name);
        } else {
            NSLog(@"Failed to add auto %@", name);
            NSLog(@"Info:%s", sqlite3_errmsg(instacarDb));
        }
    } else {
        NSLog(@"Error:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return [self getIdForAuto:name country:countryId];
}

-(int)addAutoModel:(NSString*)name ofAuto:(int)autoId logo:(int)logoId startYear:(int)startYear endYear:(int)endYear{
    return [self addAutoModel:name ofAuto:autoId logo:logoId startYear:startYear endYear:endYear isSelectable:YES];
}

-(int)addAutoModel:(NSString*)name ofAuto:(int)autoId logo:(int)logoId startYear:(int)startYear endYear:(int)endYear isSelectable:(BOOL)isSelectable{
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@, %@, %@, %@) VALUES (?, %d, %d, %d, %d, %d)", T_MODELS, F_NAME, F_AUTO_ID, F_LOGO_ID, F_YEAR_START, F_YEAR_END, F_SELECTABLE, autoId, logoId, startYear, endYear, isSelectable];
    
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Added model: %@", name);
        } else {
            NSLog(@"Failed to add model %@", name);
            NSLog(@"Info:%s", sqlite3_errmsg(instacarDb));
        }
    } else {
        NSLog(@"Error:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return [self getIdForAutoModel:name ofAuto:autoId];
}

-(void)addAutoSubmodel:(NSString*)name ofModel:(int)modelId logo:(int)logoId startYear:(int)startYear endYear:(int)endYear{
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@, %@, %@) VALUES (?, %d, %d, %d, %d)", T_SUBMODELS, F_NAME, F_MODEL_ID, F_LOGO_ID, F_YEAR_START, F_YEAR_END, modelId, logoId, startYear, endYear];
    
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Added submodel: %@", name);
        } else {
            NSLog(@"Failed to add submodel %@", name);
            NSLog(@"Info:%s", sqlite3_errmsg(instacarDb));
        }
    } else {
        NSLog(@"Error:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
}

#pragma mark -

#pragma mark Saving data public methods
-(void)addIcon:(UIImage*)icon forPath:(NSString*)iconPath{
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@) VALUES (?, ?)", T_ICONS, F_FILENAME, F_DATA];
    
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [iconPath cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        NSData *iconData = UIImagePNGRepresentation(icon);
        sqlite3_bind_blob(statement, 2, iconData.bytes, iconData.length, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Added icon: %@", iconPath);
        } else {
            NSLog(@"Failed to add icon %@", iconPath);
            NSLog(@"Info:%s", sqlite3_errmsg(instacarDb));
        }
    } else {
        NSLog(@"Error:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);    
}


#pragma mark Getting data public methods

-(NSArray*)getAllAutos{
    NSMutableArray *mutableAutos = [[NSMutableArray alloc] init];
    
    //                                                        id     name   logo   country
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@.%@, %@.%@, %@.%@, %@.%@ FROM %@, %@, %@ WHERE %@.%@=%@.%@ AND %@.%@=%@.%@", T_AUTOS, F_ID, T_AUTOS, F_NAME, T_LOGOS, F_NAME, T_COUNTRIES, F_NAME, T_AUTOS, T_LOGOS, T_COUNTRIES, T_AUTOS, F_LOGO_ID, T_LOGOS, F_ID, T_AUTOS, F_COUNTRY_ID, T_COUNTRIES, F_ID];
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            int idField = sqlite3_column_int(statement, 0);
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            NSString *logoField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            NSString *countryField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
            
            Auto *_auto = [[Auto alloc] initWithId: idField name:nameField logo:logoField country:countryField];
            [mutableAutos addObject:_auto];
        }
    } else {
        NSLog(@"Failed to query auto");
        NSLog(@"Info:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
        
    return [[NSArray alloc] initWithArray:mutableAutos];
}

-(NSArray*)getModelsOfAuto:(int)autoId{
    NSMutableArray *mutableModels = [[NSMutableArray alloc] init];
    
    //                                                        id     name   logo   sYear  eYear  selectable
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@.%@, %@.%@, %@.%@, %@.%@, %@.%@, %@.%@ FROM %@, %@ WHERE %@.%@=%@.%@ AND %@.%@=%d", T_MODELS, F_ID, T_MODELS, F_NAME, T_LOGOS, F_NAME, T_MODELS, F_YEAR_START, T_MODELS, F_YEAR_END, T_MODELS, F_SELECTABLE, T_MODELS, T_LOGOS, T_MODELS, F_LOGO_ID, T_LOGOS, F_ID, T_MODELS, F_AUTO_ID, autoId];
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            int modelId = sqlite3_column_int(statement, 0);
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            NSString *logoField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            
            AutoModel *model = [[AutoModel alloc] initWithId:modelId andName:nameField];
            model.logo = logoField;
            model.startYear = sqlite3_column_int(statement, 3);
            model.endYear = sqlite3_column_int(statement, 4);
            model.isSelectable = sqlite3_column_int(statement, 5);
            
            [mutableModels addObject:model];
        }
    } else {
        NSLog(@"Failed to query model");
        NSLog(@"Info:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return [[NSArray alloc] initWithArray:mutableModels];
}

-(NSArray*)getSubmodelsOfModel:(int)modelId{
    NSMutableArray *mutableSubmodels = [[NSMutableArray alloc] init];
    
    //                                                        name   logo   sYear  eYear
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@.%@, %@.%@, %@.%@, %@.%@ FROM %@, %@ WHERE %@.%@=%@.%@ AND %@.%@=%d", T_SUBMODELS, F_NAME, T_LOGOS, F_NAME, T_SUBMODELS, F_YEAR_START, T_SUBMODELS, F_YEAR_END, T_SUBMODELS, T_LOGOS, T_SUBMODELS, F_LOGO_ID, T_LOGOS, F_ID, T_SUBMODELS, F_MODEL_ID, modelId];
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            NSString *logoField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            
            AutoSubmodel *submodel = [[AutoSubmodel alloc] initWithName:nameField];
            submodel.logo = logoField;
            submodel.startYear = sqlite3_column_int(statement, 2);
            submodel.endYear = sqlite3_column_int(statement, 3);
            
            [mutableSubmodels addObject:submodel];
        }
    } else {
        NSLog(@"Failed to query submodel");
        NSLog(@"Info:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return [[NSArray alloc] initWithArray:mutableSubmodels];
}

-(UIImage*)getIconForPath:(NSString*)path{
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
            NSLog(@"Icon not found");
        }
    } else {
        NSLog(@"Error getting data for icon: %s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return icon;
}

#pragma mark Getting data private methods

-(int)getIdForCountry:(NSString*)name{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=?", F_ID, T_COUNTRIES, F_NAME];
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
            NSLog(@"Country not found");
        }
    } else {
        NSLog(@"Error getting id for Country:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return _id;
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
            NSLog(@"Logo not found");
        }
    } else {
        NSLog(@"Error getting id for Logo:%s", sqlite3_errmsg(instacarDb));
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
            NSLog(@"Auto not found");
        }
    } else {
        NSLog(@"Error getting id for Auto:%s", sqlite3_errmsg(instacarDb));
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
            NSLog(@"Model not found");
        }
    } else {
        NSLog(@"Error getting id for Model:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return _id;
}

/*

// public methods
-(NSDictionary*) getLanguages{ // key: name, value:language
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@ FROM %@", F_NAME, F_LANG, T_LANGS];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            int language = sqlite3_column_int(statement, 1);
            
            [result setObject:[NSNumber numberWithInt:language] forKey:nameField];
        }
    }
    sqlite3_finalize(statement);
    
    return [[NSDictionary alloc] initWithDictionary:result];
}

-(NSString*) getLanguageName:(int)language{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%d", F_NAME, T_LANGS, F_LANG, language];
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            return nameField;
        } else {
            NSLog(@"Language not found");
        }
    }
    sqlite3_finalize(statement);

    return @"";
}

-(int) saveProject:(Project*)project{
    Project* exists = [self loadProject:project.projName];
    NSString* sql;
    NSString *logMsg = @"";
    
    if (exists){ // already exists so update
        sql = [NSString stringWithFormat: @"UPDATE %@ SET %@ = ?, %@ = %d, %@ = ?, %@ = ?, %@ = ? WHERE %@ =%d", T_PROJECTS, F_NAME, F_LANG, project.projLanguage, F_CODE, F_LINK, F_INPUT, F_ID, exists.projId];
        logMsg = @"Project updated";
    } else { // doesnt exist so insert
        sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@, %@, %@) VALUES (?, %d, ?, ?, ?)", T_PROJECTS, F_NAME, F_LANG, F_CODE, F_LINK, F_INPUT, project.projLanguage];
        logMsg = @"Project inserted";
    }
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [project.projName cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [project.projCode cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [project.projLink cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [project.projInput cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"%@", logMsg);
            return [self loadProject:project.projName].projId;
        } else {
            NSLog(@"Failed to save project");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    }
    sqlite3_finalize(statement);
    
    return -1;
}

-(int) saveSnippet:(Snippet*)snippet{
    Snippet* exists = [self loadSnippet:snippet.snipName language:snippet.snipLanguage];
    NSString* sql;
    NSString *logMsg = @"";
    
    if (exists){ // already exists so update
        sql = [NSString stringWithFormat: @"UPDATE %@ SET %@ = ?, %@ = %d, %@ = ? WHERE %@ =%d", T_SNIPPETS, F_NAME, F_LANG, snippet.snipLanguage, F_CODE, F_ID, snippet.snipId];
        logMsg = @"Snippet updated";
    } else { // doesnt exist so insert
        sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@) VALUES (?, %d, ?)", T_SNIPPETS, F_NAME, F_LANG, F_CODE, snippet.snipLanguage];
        logMsg = @"Snippet inserted";
    }
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [snippet.snipName cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [snippet.snipCode cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"%@", logMsg);
            return [self loadSnippet:snippet.snipName language:snippet.snipLanguage].snipId;
        } else {
            NSLog(@"Failed to save snippet");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    }
    sqlite3_finalize(statement);
    
    return -1;
}

-(Snippet*) loadSnippet:(NSString*)name language:(int)lang{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@ FROM %@ WHERE %@=? AND %@=%d", F_ID, F_CODE, T_SNIPPETS, F_NAME, F_LANG, lang];
    const char *query_stmt = [querySQL UTF8String];
    
    Snippet* snippet = nil;
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_ROW){
            int iD = sqlite3_column_int(statement, 0);
            
            NSString *codeField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            
            snippet = [[Snippet alloc] initWithLanguage:lang name:name code:codeField];
            [snippet setId:iD];
        } else {
            NSLog(@"Snippet not found in the database");
        }
    }
    sqlite3_finalize(statement);
    
    return snippet;
}

-(QuickSymbol*) loadQuickSymbol:(int)iD{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@ FROM %@ WHERE %@=%d", F_NAME, F_CODE, T_SYMBOLS, F_SYMB_ID, iD];
    const char *query_stmt = [querySQL UTF8String];
    
    QuickSymbol* symbol = nil;
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            NSString *titleField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            
            NSString *contentField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            
            symbol = [[QuickSymbol alloc] initWithId:iD title:titleField content:contentField];
        } else {
            NSLog(@"Quick symbol not found in the database");
        }
    }
    sqlite3_finalize(statement);
    
    return symbol;
}

-(Project*) loadProject:(NSString*)name{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@, %@, %@, %@ FROM %@ WHERE %@=?", F_ID, F_LANG, F_CODE, F_LINK, F_INPUT, T_PROJECTS, F_NAME];
    const char *query_stmt = [querySQL UTF8String];
    
    Project* project = nil;
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_ROW){
            int iD = sqlite3_column_int(statement, 0);
            
            int language = sqlite3_column_int(statement, 1);
            
            NSString *codeField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            
            NSString *linkField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
            
            NSString *inputField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
            
            project = [[Project alloc] initWithLanguage:language name:name];
            [project setId:iD];
            [project setCode:codeField];
            [project setLink:linkField];
            [project setInput:inputField];
        } else {
            NSLog(@"Project not found in the database");
        }
    } else {
        NSLog(@"Failed to load project");
        NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
    }
    sqlite3_finalize(statement);
    
    return project;
}

-(void) deleteProject:(NSString*)name{
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", T_PROJECTS, F_NAME];
    const char *delete_stmt = [deleteSQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, delete_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        if (sqlite3_step(statement) == SQLITE_DONE){
        } else {
            NSLog(@"Error deleting project from database");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    }
    sqlite3_finalize(statement);
}

-(void) deleteQuickSymbol:(int)iD{
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%d", T_SYMBOLS, F_SYMB_ID, iD];
    const char *delete_stmt = [deleteSQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, delete_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_DONE){
        } else {
            NSLog(@"Error deleting symbol from database");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    }
    sqlite3_finalize(statement);
}

-(void) deleteSnippet:(NSString*)name language:(int)lang{
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ? AND %@=%d", T_SNIPPETS, F_NAME, F_LANG, lang];
    const char *delete_stmt = [deleteSQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, delete_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        if (sqlite3_step(statement) == SQLITE_DONE){
        } else {
            NSLog(@"Error deleting snippet from database");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    }
    sqlite3_finalize(statement);
}

-(NSDictionary*) getProjectsBasicInfo{ // key: name, value:language
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@ FROM %@", F_NAME, F_LANG, T_PROJECTS];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            int language = sqlite3_column_int(statement, 1);
            
            [result setObject:[NSNumber numberWithInt:language] forKey:nameField];
        }
    }
    sqlite3_finalize(statement);
    
    return [[NSDictionary alloc] initWithDictionary:result];
}

-(NSArray*) getSnippetNamesForLanguage:(int)lang{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%d", F_NAME, T_SNIPPETS, F_LANG, lang];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            [result addObject:nameField];
        }
    }
    sqlite3_finalize(statement);
    
    return [[NSArray alloc] initWithArray:result];
}

-(void) putQuickSymbol:(int)symbId toLanguageUsage:(int)lang atIndex:(int)index{
    int symbolsForLang = [self getSymbolsCountForLanguage:lang];
    int indexToPutAt = MAX(0, MIN(index, symbolsForLang));
    int currentOrder = [self getOrderIndexForSymbolId:symbId forLaguageUsage:lang];
    
    if (indexToPutAt == currentOrder){
        return;
    }
    
    NSMutableArray* queries = [[NSMutableArray alloc] initWithObjects:@"begin;", nil];
    
    if (currentOrder == -1){ // inserting new symbol to order
        if (symbolsForLang > indexToPutAt){
            [queries addObject: [NSString stringWithFormat:@"UPDATE %@ SET %@=%@+1 WHERE %@=%d AND %@>=%d;", T_SYMBOLS_ORDER, F_SYMB_ORDER, F_SYMB_ORDER, F_LANG, lang, F_SYMB_ORDER, indexToPutAt]];
        }
        [queries addObject:[NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@) VALUES (%d, %d, %d);", T_SYMBOLS_ORDER, F_SYMB_ID, F_LANG, F_SYMB_ORDER, symbId, lang, indexToPutAt]];
    } else { // 'moving' symbol inside table
        if (indexToPutAt > currentOrder){ // moving symbol down
            [queries addObject: [NSString stringWithFormat:@"UPDATE %@ SET %@=%@-1 WHERE %@=%d AND %@>%d AND %@<=%d;", T_SYMBOLS_ORDER, F_SYMB_ORDER, F_SYMB_ORDER, F_LANG, lang, F_SYMB_ORDER, currentOrder, F_SYMB_ORDER, indexToPutAt]];
        } else { // moving symbol up
            [queries addObject: [NSString stringWithFormat:@"UPDATE %@ SET %@=%@+1 WHERE %@=%d AND %@>=%d AND %@<%d;", T_SYMBOLS_ORDER, F_SYMB_ORDER, F_SYMB_ORDER, F_LANG, lang, F_SYMB_ORDER, indexToPutAt, F_SYMB_ORDER, currentOrder]];
        }
        
        [queries addObject: [NSString stringWithFormat:@"UPDATE %@ SET %@=%d WHERE %@=%d AND %@=%d;", T_SYMBOLS_ORDER, F_SYMB_ORDER, indexToPutAt, F_LANG, lang, F_SYMB_ID, symbId]];
    }
    
    [queries addObject:@"commit;"];
    
    for (NSString* query in queries) {
        const char *query_stmt = [query UTF8String];
        sqlite3_exec(buildAnywhereDb, query_stmt, NULL, NULL, NULL);
    }
}

-(void)removeQuickSymbol:(int)iD fomLanguageUsage:(int)lang{
    int currentOrder = [self getOrderIndexForSymbolId:iD forLaguageUsage:lang];
    
    if (currentOrder < 0){
        return;
    }
    
    NSMutableArray* queries = [[NSMutableArray alloc] initWithObjects:@"begin;", nil];
    
    [queries addObject: [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%d AND %@=%d;", T_SYMBOLS_ORDER, F_SYMB_ID, iD, F_LANG, lang]];
    [queries addObject: [NSString stringWithFormat:@"UPDATE %@ SET %@=%@-1 WHERE %@=%d AND %@>%d;", T_SYMBOLS_ORDER, F_SYMB_ORDER, F_SYMB_ORDER, F_LANG, lang, F_SYMB_ORDER, currentOrder]];
    
    [queries addObject:@"commit;"];
    
    for (NSString* query in queries) {
        const char *query_stmt = [query UTF8String];
        sqlite3_exec(buildAnywhereDb, query_stmt, NULL, NULL, NULL);
    }
}

-(NSArray*) getQuickSymbols{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@, %@ FROM %@", F_SYMB_ID, F_NAME, F_CODE, T_SYMBOLS];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            int iD = sqlite3_column_int(statement, 0);
            
            NSString *titleField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            
            NSString *contentField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            
            [result addObject:[[QuickSymbol alloc] initWithId:iD title:titleField content:contentField]];
        }
    }
    sqlite3_finalize(statement);
    
    return [[NSArray alloc] initWithArray:result];
}

-(NSDictionary*) getQuickSymbolsDictionary{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@, %@ FROM %@", F_SYMB_ID, F_NAME, F_CODE, T_SYMBOLS];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            int iD = sqlite3_column_int(statement, 0);
            
            NSString *titleField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            
            NSString *contentField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            
            [result setObject:[[QuickSymbol alloc] initWithId:iD title:titleField content:contentField] forKey:[NSNumber numberWithInt:iD]];
        }
    }
    sqlite3_finalize(statement);
    
    return [[NSDictionary alloc] initWithDictionary:result];
}

-(NSDictionary*)getOrderedSymbolIDsForLanguage:(int)lang{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@ FROM %@ WHERE %@=%d ORDER BY %@ ASC", F_SYMB_ID, F_SYMB_ORDER, T_SYMBOLS_ORDER, F_LANG, lang, F_SYMB_ORDER];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            NSNumber *iD = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            NSNumber *order = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
            [result setObject:iD forKey:order];
        }
    }  else {
        NSLog(@"Failed to prepare query");
        NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
    }
    sqlite3_finalize(statement);
    
    return result;
}

-(int) getSymbolsCount{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT COUNT(%@) FROM %@", F_ID, T_SYMBOLS];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = 0;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            result = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    
    return result;
}

-(NSArray*) getLanguagesSymbolUsedFor:(int)iD{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%d", F_LANG, T_SYMBOLS_ORDER, F_SYMB_ID, iD];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            [result addObject:[NSNumber numberWithInt:sqlite3_column_int(statement, 0)]];
        }
    }
    sqlite3_finalize(statement);
    
    return result;
}

// private methods
-(int) getOrderIndexForSymbolId:(int)iD forLaguageUsage:(int)lang{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%d AND %@=%d", F_SYMB_ORDER, T_SYMBOLS_ORDER, F_SYMB_ID, iD, F_LANG, lang];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = -1;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            result = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    
    return result;
}

-(int) getSymbolsCountForLanguage:(int)lang{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT COUNT(%@) FROM %@ WHERE %@=%d", F_ID, T_SYMBOLS_ORDER, F_LANG, lang];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = 0;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            result = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    
    return result;
}

-(int) getMaxSymbolId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT MAX(%@) FROM %@", F_ID, T_SYMBOLS];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = 0;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            result = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    
    return result;
}
 */

@end