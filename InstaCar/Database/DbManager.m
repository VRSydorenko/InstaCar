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
        char *errMsg;
        DBDefinition* dbDef = [[DBDefinition alloc] init];
        
        if ([Utils appVersionDiffers]){
            const char *dropSql = [[dbDef getTablesCreationSQL] UTF8String];
            if (sqlite3_exec(instacarDb, dropSql, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Error dropping DB table(s)");
                NSLog(@"Info:%s", sqlite3_errmsg(instacarDb));
            }
            // [UserSettings setStoredAppVersion]; // TODO: uncomment in production
        }
        
        const char *sql = [[dbDef getTablesCreationSQL] UTF8String];
        if (sqlite3_exec(instacarDb, sql, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Error creating DB table(s)");
            NSLog(@"Info:%s", sqlite3_errmsg(instacarDb));
        }
    } else {
        NSLog(@"Failed to open/create database");
        NSLog(@"Info:%s", sqlite3_errmsg(instacarDb));
    }
}

-(void)initData{
    int countryId;
    int logoId;
    int autoId;
    
    // Countries
    // A
    // B
    // C
    // D
    // E
    // F
    // G
    countryId = [self addCountry:@"Germany"];
    logoId = [self addLogo:@"bmw_256.png"];
    autoId = [self addAuto:@"BMW" country:countryId logo:logoId];
    [self addAutoModel:@"1 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"1x Convertible" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"1x Coupe" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"1x M Coupe" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"3 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"3x GT" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"3x Convertible" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"3x Compact" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"3x Coupe" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"4 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"5 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"6 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"7 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"X1 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
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
    }
    sqlite3_finalize(statement);
    
    return [self getIdForAuto:name country:countryId];
}

-(void)addAutoModel:(NSString*)name ofAuto:(int)autoId logo:(int)logoId startYear:(int)startYear endYear:(int)endYear{
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@, %@, %@) VALUES (?, %d, %d, %d, %d)", T_AUTOS, F_NAME, F_AUTO_ID, F_LOGO_ID, F_YEAR_START, F_YEAR_END, autoId, logoId, startYear, endYear];
    
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
    }
    sqlite3_finalize(statement);
}

#pragma mark -
#pragma mark Getting data public methods

-(NSArray*)getAllAutos{
    NSMutableArray *mutableAutos = [[NSMutableArray alloc] init];
    
    //                                                        name   logo   country
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@.%@, %@.%@, %@.%@ FROM %@, %@, %@ WHERE %@.%@=%@.%@ AND %@.%@=%@.%@", T_AUTOS, F_NAME, T_LOGOS, F_NAME, T_COUNTRIES, F_NAME, T_AUTOS, T_LOGOS, T_COUNTRIES, T_AUTOS, F_LOGO_ID, T_LOGOS, F_ID, T_AUTOS, F_COUNTRY_ID, T_COUNTRIES, F_ID];
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            NSString *logoField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            NSString *countryField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            
            Auto *_auto = [[Auto alloc] initWithName:nameField logo:logoField country:countryField];
            [mutableAutos addObject:_auto];
        }
    } else {
        NSLog(@"Failed to query auto");
        NSLog(@"Info:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
        
    return [[NSArray alloc] initWithArray:mutableAutos];
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