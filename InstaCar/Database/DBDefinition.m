//
//  DBDefinition.m
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import "DBDefinition.h"
#import "DbTable.h"

@implementation DBDefinition{
    NSMutableArray* tables;
}

-(id) init{
    self = [super init];
    if (self){
        [self initialize];
    }
    return self;
}

-(void) initialize{
    tables = [[NSMutableArray alloc] init];
    
    DbTable* tLogos = [[DbTable alloc] initWithTableName:T_LOGOS];
    [tLogos addField:F_NAME type:DBTYPE_TEXT notNull:YES];
    [tables addObject:tLogos];
    
    DbTable* tCountries = [[DbTable alloc] initWithTableName:T_COUNTRIES];
    [tCountries addField:F_NAME type:DBTYPE_TEXT notNull:YES];
    [tables addObject:tCountries];
    
    DbTable* tAutos = [[DbTable alloc] initWithTableName:T_AUTOS];
    [tAutos addField:F_NAME type:DBTYPE_TEXT notNull:YES];
    [tAutos addField:F_COUNTRY_ID type:DBTYPE_REAL notNull:NO];
    [tAutos addField:F_LOGO_ID type:DBTYPE_REAL notNull:NO];
    [tAutos addForeignKey:F_COUNTRY_ID refTable:T_COUNTRIES refField:F_ID];
    [tAutos addForeignKey:F_LOGO_ID refTable:T_LOGOS refField:F_ID];
    [tables addObject:tAutos];
    
    DbTable* tModels = [[DbTable alloc] initWithTableName:T_MODELS];
    [tModels addField:F_NAME type:DBTYPE_TEXT notNull:YES];
    [tModels addField:F_AUTO_ID type:DBTYPE_REAL notNull:YES];
    [tModels addField:F_LOGO_ID type:DBTYPE_REAL notNull:YES];
    [tModels addField:F_YEAR_START type:DBTYPE_REAL notNull:NO];
    [tModels addField:F_YEAR_END type:DBTYPE_REAL notNull:NO];
    [tModels addForeignKey:F_AUTO_ID refTable:T_AUTOS refField:F_ID];
    [tModels addForeignKey:F_LOGO_ID refTable:T_LOGOS refField:F_ID];
    [tables addObject:tModels];
}

-(NSString*) getTablesCreationSQL{
    NSString* sql = [[NSString alloc] init];
    for (DbTable* table in tables) {
        sql = [sql stringByAppendingString:[table getTableCreationSQL]];
    }
    return sql;
}

-(NSString*) getTablesDropSQL{
    NSString* sql = [[NSString alloc] init];
    for (DbTable* table in tables) {
        sql = [sql stringByAppendingString:[table getTableDropSQL]];
    }
    return sql;
}

@end
