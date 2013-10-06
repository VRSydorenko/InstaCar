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
#pragma mark === France ===
    countryId = [self addCountry:@"France"];
#pragma mark |---- Citroёn
    logoId = [self addLogo:@"citroen_256.png"];
    autoId = [self addAuto:@"CITROËN" country:countryId logo:logoId];
    modelId = [self addAutoModel:@"Pre war" ofAuto:autoId logo:logoId startYear:1919 endYear:1941 isSelectable:NO];
    {
        [self addAutoSubmodel:@"Kégresse track" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"7CV" ofModel:modelId logo:logoId startYear:1934 endYear:1935];
        [self addAutoSubmodel:@"7C" ofModel:modelId logo:logoId startYear:1935 endYear:1940];
        [self addAutoSubmodel:@"7U Rosalie" ofModel:modelId logo:logoId startYear:1935 endYear:1937];
        [self addAutoSubmodel:@"8CV Rosalie" ofModel:modelId logo:logoId startYear:1932 endYear:1935];
        [self addAutoSubmodel:@"8CV" ofModel:modelId logo:logoId startYear:1933 endYear:1934];
        [self addAutoSubmodel:@"10CV" ofModel:modelId logo:logoId startYear:1933 endYear:1934];
        [self addAutoSubmodel:@"11U Rosalie" ofModel:modelId logo:logoId startYear:1935 endYear:1937];
        [self addAutoSubmodel:@"11" ofModel:modelId logo:logoId startYear:1935 endYear:1940];
        [self addAutoSubmodel:@"15" ofModel:modelId logo:logoId startYear:1935 endYear:1936];
        [self addAutoSubmodel:@"15/6" ofModel:modelId logo:logoId startYear:1939 endYear:1955];
        [self addAutoSubmodel:@"Type A" ofModel:modelId logo:logoId startYear:1919 endYear:1921];
        [self addAutoSubmodel:@"Type AC4" ofModel:modelId logo:logoId startYear:1928 endYear:1929];
        [self addAutoSubmodel:@"Type AC6" ofModel:modelId logo:logoId startYear:1928 endYear:1929];
        [self addAutoSubmodel:@"Type B" ofModel:modelId logo:logoId startYear:1921 endYear:1928];
        [self addAutoSubmodel:@"Type C (C2-C3)" ofModel:modelId logo:logoId startYear:1922 endYear:1926];
        [self addAutoSubmodel:@"Type C (C4-C6)" ofModel:modelId logo:logoId startYear:1928 endYear:1934];
        [self addAutoSubmodel:@"Traction Avant" ofModel:modelId logo:logoId startYear:1934 endYear:1957];
        [self addAutoSubmodel:@"TUB van" ofModel:modelId logo:logoId startYear:1939 endYear:1941];
    }
    modelId = [self addAutoModel:@"Post war (45-70)" ofAuto:autoId logo:logoId startYear:1945 endYear:1970 isSelectable:NO];
    {
        [self addAutoSubmodel:@"2CV" ofModel:modelId logo:logoId startYear:1948 endYear:1990];
        [self addAutoSubmodel:@"Ami 6" ofModel:modelId logo:logoId startYear:1961 endYear:1971];
        [self addAutoSubmodel:@"Ami 8" ofModel:modelId logo:logoId startYear:1969 endYear:1979];
        [self addAutoSubmodel:@"Bijou" ofModel:modelId logo:logoId startYear:1959 endYear:1964];
        [self addAutoSubmodel:@"DS/ID" ofModel:modelId logo:logoId startYear:1955 endYear:1975];
        [self addAutoSubmodel:@"Dyane" ofModel:modelId logo:logoId startYear:1967 endYear:1984];
        [self addAutoSubmodel:@"H Van" ofModel:modelId logo:logoId startYear:1947 endYear:1981];
    }
    modelId = [self addAutoModel:@"Post war (70-80)" ofAuto:autoId logo:logoId startYear:1970 endYear:1980 isSelectable:NO];
    {
        [self addAutoSubmodel:@"Acadiane" ofModel:modelId logo:logoId startYear:1978 endYear:1987];
        [self addAutoSubmodel:@"Ami Super" ofModel:modelId logo:logoId startYear:1973 endYear:1976];
        [self addAutoSubmodel:@"Axel" ofModel:modelId logo:logoId startYear:1984 endYear:1988];
        [self addAutoSubmodel:@"C25" ofModel:modelId logo:logoId startYear:1981 endYear:1993];
        [self addAutoSubmodel:@"C35" ofModel:modelId logo:logoId startYear:1974 endYear:1989];
        [self addAutoSubmodel:@"CX" ofModel:modelId logo:logoId startYear:1974 endYear:1989];
        [self addAutoSubmodel:@"FAF" ofModel:modelId logo:logoId startYear:1973 endYear:1979];
        [self addAutoSubmodel:@"GS" ofModel:modelId logo:logoId startYear:1970 endYear:1980];
        [self addAutoSubmodel:@"GSA" ofModel:modelId logo:logoId startYear:1979 endYear:1986];
        [self addAutoSubmodel:@"LN" ofModel:modelId logo:logoId startYear:1976 endYear:1979];
        [self addAutoSubmodel:@"LNA" ofModel:modelId logo:logoId startYear:1978 endYear:1986];
        [self addAutoSubmodel:@"M35" ofModel:modelId logo:logoId startYear:1970 endYear:1971];
        [self addAutoSubmodel:@"Méhari" ofModel:modelId logo:logoId startYear:1968 endYear:1987];
        [self addAutoSubmodel:@"SM" ofModel:modelId logo:logoId startYear:1970 endYear:1975];
        [self addAutoSubmodel:@"Visa" ofModel:modelId logo:logoId startYear:1978 endYear:1988];
    }
    [self addAutoModel:@"AX" ofAuto:autoId logo:logoId startYear:1986 endYear:1998];
    [self addAutoModel:@"BX" ofAuto:autoId logo:logoId startYear:1982 endYear:1994];
    [self addAutoModel:@"C15" ofAuto:autoId logo:logoId startYear:1984 endYear:2005];
    [self addAutoModel:@"Evasion" ofAuto:autoId logo:logoId startYear:1994 endYear:2003];
    [self addAutoModel:@"Fukang 988" ofAuto:autoId logo:logoId startYear:1998 endYear:2003];
    [self addAutoModel:@"Saxo" ofAuto:autoId logo:logoId startYear:1995 endYear:2003];
    [self addAutoModel:@"XM" ofAuto:autoId logo:logoId startYear:1989 endYear:2000];
    [self addAutoModel:@"Xanita" ofAuto:autoId logo:logoId startYear:1993 endYear:2001];
    [self addAutoModel:@"ZX" ofAuto:autoId logo:logoId startYear:1991 endYear:1997];
    [self addAutoModel:@"Synergie" ofAuto:autoId logo:logoId startYear:1995 endYear:2001];
    [self addAutoModel:@"Xsara" ofAuto:autoId logo:logoId startYear:1997 endYear:2006];
    [self addAutoModel:@"Xsara Picasso" ofAuto:autoId logo:logoId startYear:1999 endYear:2008];
    [self addAutoModel:@"C-ZERO" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
    modelId = [self addAutoModel:@"C1" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
    {
        [self addAutoSubmodel:@"Ev'ie" ofModel:modelId logo:logoId startYear:2009 endYear:0];
    }
    [self addAutoModel:@"C2" ofAuto:autoId logo:logoId startYear:2003 endYear:2010];
    modelId = [self addAutoModel:@"C3" ofAuto:autoId logo:logoId startYear:2002 endYear:0];
    {
        [self addAutoSubmodel:@"Picasso" ofModel:modelId logo:logoId startYear:2009 endYear:0];
    }
    modelId = [self addAutoModel:@"C4" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
    {
        [self addAutoSubmodel:@"C-Triomphe" ofModel:modelId logo:logoId startYear:2006 endYear:0];
        [self addAutoSubmodel:@"Pallas" ofModel:modelId logo:logoId startYear:2007 endYear:0];
        [self addAutoSubmodel:@"C-Quatre" ofModel:modelId logo:logoId startYear:2009 endYear:0];
        [self addAutoSubmodel:@"Picasso" ofModel:modelId logo:logoId startYear:2007 endYear:0];
        [self addAutoSubmodel:@"Grand Picasso" ofModel:modelId logo:logoId startYear:2007 endYear:0];
        [self addAutoSubmodel:@"Nouvelle" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Aircross" ofModel:modelId logo:logoId startYear:2012 endYear:0];
    }
    modelId = [self addAutoModel:@"C5" ofAuto:autoId logo:logoId startYear:2008 endYear:0];
    {
        [self addAutoSubmodel:@"Tourer" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
    modelId = [self addAutoModel:@"Berlingo" ofAuto:autoId logo:logoId startYear:1996 endYear:0];
    {
        [self addAutoSubmodel:@"Multispace" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Électrique" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
    [self addAutoModel:@"Elysée" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    [self addAutoModel:@"Fukang" ofAuto:autoId logo:logoId startYear:1997 endYear:0];
    [self addAutoModel:@"Jumpy" ofAuto:autoId logo:logoId startYear:1995 endYear:0];
    [self addAutoModel:@"Jumper" ofAuto:autoId logo:logoId startYear:1994 endYear:0];
    modelId = [self addAutoModel:@"Nemo" ofAuto:autoId logo:logoId startYear:2008 endYear:0];
    {
        [self addAutoSubmodel:@"Multispace" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
    modelId = [self addAutoModel:@"DS" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"DS3" ofModel:modelId logo:logoId startYear:2009 endYear:0];
        [self addAutoSubmodel:@"DS4" ofModel:modelId logo:logoId startYear:2010 endYear:0];
        [self addAutoSubmodel:@"DS5" ofModel:modelId logo:logoId startYear:2011 endYear:0];
    }
    modelId = [self addAutoModel:@"Trucs" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"P45" ofModel:modelId logo:logoId startYear:1934 endYear:1953];
        [self addAutoSubmodel:@"P46" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"U23" ofModel:modelId logo:logoId startYear:1936 endYear:1964];//TODO: endYear is unclear
        [self addAutoSubmodel:@"Belphégor" ofModel:modelId logo:logoId startYear:1964 endYear:-1];//TODO: endYear is unknown
    }
    modelId = [self addAutoModel:@"Buses" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"CH14 Currus" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Heuliez C35" ofModel:modelId logo:logoId startYear:1978 endYear:-1];
        [self addAutoSubmodel:@"Jumper van bus" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Type C6 Long" ofModel:modelId logo:logoId startYear:1931 endYear:-1];
        [self addAutoSubmodel:@"Type 23 bus" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Type 46 DP UADI" ofModel:modelId logo:logoId startYear:1930 endYear:-1];
        [self addAutoSubmodel:@"Type 32B" ofModel:modelId logo:logoId startYear:1935 endYear:0];
        [self addAutoSubmodel:@"Type C6 G1" ofModel:modelId logo:logoId startYear:1932 endYear:1933];
    }
    
    modelId = [self addAutoModel:@"Concept cars" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"Traction Avant 22CV" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"G Van" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Coccinelle" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"C-60" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Project F" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Mini-Zup" ofModel:modelId logo:logoId startYear:1972 endYear:-1];
        [self addAutoSubmodel:@"GC Camargue" ofModel:modelId logo:logoId startYear:1972 endYear:-1];
        [self addAutoSubmodel:@"2CV Pop" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
        [self addAutoSubmodel:@"Prototype Y" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"C44" ofModel:modelId logo:logoId startYear:1980 endYear:-1];
        [self addAutoSubmodel:@"Karin" ofModel:modelId logo:logoId startYear:1980 endYear:-1];
        [self addAutoSubmodel:@"Xenia" ofModel:modelId logo:logoId startYear:1981 endYear:-1];
        [self addAutoSubmodel:@"Eco 2000" ofModel:modelId logo:logoId startYear:1984 endYear:-1];
        [self addAutoSubmodel:@"Eole" ofModel:modelId logo:logoId startYear:1986 endYear:-1];
        [self addAutoSubmodel:@"Zabrus Bertone" ofModel:modelId logo:logoId startYear:1986 endYear:-1];
        [self addAutoSubmodel:@"Activia" ofModel:modelId logo:logoId startYear:1988 endYear:-1];
        [self addAutoSubmodel:@"Activia II" ofModel:modelId logo:logoId startYear:1990 endYear:-1];
        [self addAutoSubmodel:@"Citella" ofModel:modelId logo:logoId startYear:1992 endYear:-1];
        [self addAutoSubmodel:@"Xanae" ofModel:modelId logo:logoId startYear:1994 endYear:-1];
        [self addAutoSubmodel:@"Osmose" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Tulip" ofModel:modelId logo:logoId startYear:1995 endYear:-1];
        [self addAutoSubmodel:@"C3 Lumière" ofModel:modelId logo:logoId startYear:1998 endYear:-1];
        [self addAutoSubmodel:@"C6 Lignage" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
        [self addAutoSubmodel:@"Osée Pinifarina" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Pluriel" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
        [self addAutoSubmodel:@"C-Crosser" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
        [self addAutoSubmodel:@"C-Airdream" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
        [self addAutoSubmodel:@"C-SportLounge" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
        [self addAutoSubmodel:@"C-Airplay" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
        [self addAutoSubmodel:@"C-Buggy" ofModel:modelId logo:logoId startYear:2006 endYear:-1];
        [self addAutoSubmodel:@"C-Métisse" ofModel:modelId logo:logoId startYear:2006 endYear:-1];
        [self addAutoSubmodel:@"C-Cactus" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
        [self addAutoSubmodel:@"GT" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
        [self addAutoSubmodel:@"Hypnos" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
        [self addAutoSubmodel:@"DS Inside" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
        [self addAutoSubmodel:@"Revolte" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
        [self addAutoSubmodel:@"Metropolis" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
        [self addAutoSubmodel:@"Survolt" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
        [self addAutoSubmodel:@"Lacoste" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
        [self addAutoSubmodel:@"DS 20 Cabriolet" ofModel:modelId logo:logoId startYear:1965 endYear:-1];
        [self addAutoSubmodel:@"SM Sport" ofModel:modelId logo:logoId startYear:1970 endYear:-1];
        [self addAutoSubmodel:@"C5 Airscape" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
        [self addAutoSubmodel:@"DS2" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
    // G
#pragma mark === Germany ===
    countryId = [self addCountry:@"Germany"];
#pragma mark |---- BMW
    logoId = [self addLogo:@"bmw_256.png"];
    autoId = [self addAuto:@"BMW" country:countryId logo:logoId];
    modelId = [self addAutoModel:@"Retro" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"Dixi DA-1" ofModel:modelId logo:logoId startYear:1927 endYear:1929];
        [self addAutoSubmodel:@"3/15 DA-2" ofModel:modelId logo:logoId startYear:1929 endYear:1931];
        [self addAutoSubmodel:@"3/15 DA-3 Wartburg" ofModel:modelId logo:logoId startYear:1930 endYear:1931];
        [self addAutoSubmodel:@"3/15 DA-4" ofModel:modelId logo:logoId startYear:1931 endYear:1932];
        [self addAutoSubmodel:@"3/20" ofModel:modelId logo:logoId startYear:1932 endYear:1934];
        [self addAutoSubmodel:@"303" ofModel:modelId logo:logoId startYear:1933 endYear:1934];
        [self addAutoSubmodel:@"315" ofModel:modelId logo:logoId startYear:1934 endYear:1937];
        [self addAutoSubmodel:@"319" ofModel:modelId logo:logoId startYear:1935 endYear:1936];
        [self addAutoSubmodel:@"328" ofModel:modelId logo:logoId startYear:1936 endYear:1940];
        [self addAutoSubmodel:@"329" ofModel:modelId logo:logoId startYear:1937 endYear:-1];
        [self addAutoSubmodel:@"320" ofModel:modelId logo:logoId startYear:1937 endYear:1938];
        [self addAutoSubmodel:@"321" ofModel:modelId logo:logoId startYear:1938 endYear:1950];
        [self addAutoSubmodel:@"326" ofModel:modelId logo:logoId startYear:1936 endYear:1941];
        [self addAutoSubmodel:@"327" ofModel:modelId logo:logoId startYear:1937 endYear:1941];
        [self addAutoSubmodel:@"328" ofModel:modelId logo:logoId startYear:1936 endYear:1940];
        [self addAutoSubmodel:@"501" ofModel:modelId logo:logoId startYear:1952 endYear:1962];
        [self addAutoSubmodel:@"503" ofModel:modelId logo:logoId startYear:1956 endYear:1959];
        [self addAutoSubmodel:@"New Six" ofModel:modelId logo:logoId startYear:1968 endYear:1977];
        [self addAutoSubmodel:@"E3" ofModel:modelId logo:logoId startYear:1968 endYear:1977];
        [self addAutoSubmodel:@"New Six Coupe" ofModel:modelId logo:logoId startYear:1968 endYear:1975];
        [self addAutoSubmodel:@"E9" ofModel:modelId logo:logoId startYear:1968 endYear:1975];
        [self addAutoSubmodel:@"Isetta" ofModel:modelId logo:logoId startYear:1955 endYear:1962];
        [self addAutoSubmodel:@"600" ofModel:modelId logo:logoId startYear:1957 endYear:1959];
        [self addAutoSubmodel:@"700" ofModel:modelId logo:logoId startYear:1959 endYear:1965];
        [self addAutoSubmodel:@"700 Saloon" ofModel:modelId logo:logoId startYear:1959 endYear:1965];
        [self addAutoSubmodel:@"700 Coupe" ofModel:modelId logo:logoId startYear:1959 endYear:1965];
        [self addAutoSubmodel:@"700 LS Coupe" ofModel:modelId logo:logoId startYear:1959 endYear:1965];
        [self addAutoSubmodel:@"700 Convertible" ofModel:modelId logo:logoId startYear:1959 endYear:1965];
        [self addAutoSubmodel:@"700 RS" ofModel:modelId logo:logoId startYear:1959 endYear:1965];
        [self addAutoSubmodel:@"700 Sport" ofModel:modelId logo:logoId startYear:1959 endYear:1965];
    }
    modelId = [self addAutoModel:@"1 Series" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
    {
        [self addAutoSubmodel:@"Coupe" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Convertible" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Hatchback" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"E81" ofModel:modelId logo:logoId startYear:2004 endYear:2012];
        [self addAutoSubmodel:@"E82" ofModel:modelId logo:logoId startYear:2007 endYear:0];
        [self addAutoSubmodel:@"E87" ofModel:modelId logo:logoId startYear:2004 endYear:2012];
        [self addAutoSubmodel:@"E88" ofModel:modelId logo:logoId startYear:2007 endYear:0];
        [self addAutoSubmodel:@"F20" ofModel:modelId logo:logoId startYear:2011 endYear:0];
        [self addAutoSubmodel:@"F21" ofModel:modelId logo:logoId startYear:2011 endYear:0];
    }
    modelId = [self addAutoModel:@"3 Series" ofAuto:autoId logo:logoId startYear:1975 endYear:0];
    {
        [self addAutoSubmodel:@"Compact" ofModel:modelId logo:logoId startYear:1993 endYear:2000];
        [self addAutoSubmodel:@"Coupe" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Cabrio" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Convertible" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Sedan" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Saloon" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Touring" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Hatchback" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"GT" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"E21" ofModel:modelId logo:logoId startYear:1975 endYear:1983];
        [self addAutoSubmodel:@"E30" ofModel:modelId logo:logoId startYear:1983 endYear:1991];
        [self addAutoSubmodel:@"E36" ofModel:modelId logo:logoId startYear:1991 endYear:2000];
        [self addAutoSubmodel:@"E46" ofModel:modelId logo:logoId startYear:1999 endYear:2006];
        [self addAutoSubmodel:@"E90" ofModel:modelId logo:logoId startYear:2005 endYear:2011];
        [self addAutoSubmodel:@"E91" ofModel:modelId logo:logoId startYear:2005 endYear:2011];
        [self addAutoSubmodel:@"E92" ofModel:modelId logo:logoId startYear:2007 endYear:2011];
        [self addAutoSubmodel:@"E93" ofModel:modelId logo:logoId startYear:2007 endYear:2011];
        [self addAutoSubmodel:@"F30" ofModel:modelId logo:logoId startYear:2012 endYear:0];
        [self addAutoSubmodel:@"F31" ofModel:modelId logo:logoId startYear:2012 endYear:0];
    }
    modelId = [self addAutoModel:@"4 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"Coupe" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
    modelId = [self addAutoModel:@"5 Series" ofAuto:autoId logo:logoId startYear:1972 endYear:0];
    {
        [self addAutoSubmodel:@"Sedan" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Saloon" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Touring" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"E12" ofModel:modelId logo:logoId startYear:1972 endYear:1981];
        [self addAutoSubmodel:@"E28" ofModel:modelId logo:logoId startYear:1981 endYear:1988];
        [self addAutoSubmodel:@"E34" ofModel:modelId logo:logoId startYear:1988 endYear:1996];
        [self addAutoSubmodel:@"E60" ofModel:modelId logo:logoId startYear:2003 endYear:2010];
        [self addAutoSubmodel:@"E61" ofModel:modelId logo:logoId startYear:2003 endYear:2010];
        [self addAutoSubmodel:@"F10" ofModel:modelId logo:logoId startYear:2009 endYear:0];
        [self addAutoSubmodel:@"F11" ofModel:modelId logo:logoId startYear:2009 endYear:0];
        [self addAutoSubmodel:@"F07" ofModel:modelId logo:logoId startYear:2009 endYear:0];
        [self addAutoSubmodel:@"Gran Turismo" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"ActiveHybrid" ofModel:modelId logo:logoId startYear:2012 endYear:0];
    }
    modelId = [self addAutoModel:@"6 Series" ofAuto:autoId logo:logoId startYear:1976 endYear:0];
    {
        [self addAutoSubmodel:@"Coupe" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Gran Coupe" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Convertible" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"E24" ofModel:modelId logo:logoId startYear:1976 endYear:1989];
        [self addAutoSubmodel:@"E63" ofModel:modelId logo:logoId startYear:2003 endYear:2010];
        [self addAutoSubmodel:@"E64" ofModel:modelId logo:logoId startYear:2003 endYear:2010];
        [self addAutoSubmodel:@"F12" ofModel:modelId logo:logoId startYear:2011 endYear:0];
        [self addAutoSubmodel:@"F13" ofModel:modelId logo:logoId startYear:2011 endYear:0];
        [self addAutoSubmodel:@"F06" ofModel:modelId logo:logoId startYear:2011 endYear:0];
    }
    modelId = [self addAutoModel:@"7 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"Sedan" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Limousine" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"E23" ofModel:modelId logo:logoId startYear:1977 endYear:1986];
        [self addAutoSubmodel:@"E32" ofModel:modelId logo:logoId startYear:1986 endYear:1994];
        [self addAutoSubmodel:@"E38" ofModel:modelId logo:logoId startYear:1994 endYear:2001];
        [self addAutoSubmodel:@"E65" ofModel:modelId logo:logoId startYear:2001 endYear:2008];
        [self addAutoSubmodel:@"E66" ofModel:modelId logo:logoId startYear:2001 endYear:2008];
        [self addAutoSubmodel:@"E67" ofModel:modelId logo:logoId startYear:2001 endYear:2008];
        [self addAutoSubmodel:@"E68" ofModel:modelId logo:logoId startYear:2001 endYear:2008];
        [self addAutoSubmodel:@"F01" ofModel:modelId logo:logoId startYear:2008 endYear:0];
        [self addAutoSubmodel:@"F02" ofModel:modelId logo:logoId startYear:2008 endYear:0];
    }
    [self addAutoModel:@"8 Series" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    modelId = [self addAutoModel:@"M" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"Motorsport" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"M Coupe" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"M3" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"M3 Coupe" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"M3 Convertible" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"M4" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"M4 Coupe" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"M5" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"M6" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"X5 M" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"X6 M" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Z4 M Coupe" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Z4 M Roadster" ofModel:modelId logo:logoId startYear:0 endYear:0];
        //[self addAutoSubmodel:@"" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
    [self addAutoModel:@"Gran Turismo" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    modelId = [self addAutoModel:@"X" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"X Series" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"X1" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"X3" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"X4" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"X5" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"X6" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
    modelId = [self addAutoModel:@"Z" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"Z Series" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Z1" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Z3" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Z4" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Z4 Coupe" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Z8" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
#pragma mark |---- Mercedes
    logoId = [self addLogo:@"mercedes_256.png"];
    autoId = [self addAuto:@"Mercedes-Benz" country:countryId logo:logoId];
    modelId = [self addAutoModel:@"1920s" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"K" ofModel:modelId logo:logoId startYear:1926 endYear:-1];
        [self addAutoSubmodel:@"Kurz-short" ofModel:modelId logo:logoId startYear:1926 endYear:-1];
        [self addAutoSubmodel:@"SSK" ofModel:modelId logo:logoId startYear:1928 endYear:-1];
        [self addAutoSubmodel:@"SS" ofModel:modelId logo:logoId startYear:1928 endYear:-1];
        [self addAutoSubmodel:@"10/50hp 'Stuttgart'" ofModel:modelId logo:logoId startYear:1929 endYear:-1];
    }
    modelId = [self addAutoModel:@"1930s" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"W10" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Mannheim" ofModel:modelId logo:logoId startYear:1929 endYear:1934];
        [self addAutoSubmodel:@"Mannheim 350" ofModel:modelId logo:logoId startYear:1929 endYear:1930];
        [self addAutoSubmodel:@"Mannheim 370" ofModel:modelId logo:logoId startYear:1929 endYear:1935];
        [self addAutoSubmodel:@"Mannheim 370 K" ofModel:modelId logo:logoId startYear:1930 endYear:1933];
        [self addAutoSubmodel:@"Mannheim 370 S" ofModel:modelId logo:logoId startYear:1930 endYear:1933];
        [self addAutoSubmodel:@"Mannheim 380 S" ofModel:modelId logo:logoId startYear:1932 endYear:1933];
        [self addAutoSubmodel:@"W19" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Typ 380 S" ofModel:modelId logo:logoId startYear:1932 endYear:1933];
        [self addAutoSubmodel:@"170 Saloon" ofModel:modelId logo:logoId startYear:1931 endYear:1932];
        [self addAutoSubmodel:@"130H" ofModel:modelId logo:logoId startYear:1934 endYear:-1];
        [self addAutoSubmodel:@"150H" ofModel:modelId logo:logoId startYear:1934 endYear:1936];
        [self addAutoSubmodel:@"W31" ofModel:modelId logo:logoId startYear:1934 endYear:1936];
        [self addAutoSubmodel:@"170V" ofModel:modelId logo:logoId startYear:1935 endYear:1953];
        [self addAutoSubmodel:@"770" ofModel:modelId logo:logoId startYear:1930 endYear:1943];
        [self addAutoSubmodel:@"770Ks" ofModel:modelId logo:logoId startYear:1930 endYear:1943];
        [self addAutoSubmodel:@"Grosser" ofModel:modelId logo:logoId startYear:1930 endYear:1943];
        [self addAutoSubmodel:@"W07" ofModel:modelId logo:logoId startYear:1930 endYear:1938];
        [self addAutoSubmodel:@"W150" ofModel:modelId logo:logoId startYear:1938 endYear:1943];
        [self addAutoSubmodel:@"500K" ofModel:modelId logo:logoId startYear:1934 endYear:1936];
        [self addAutoSubmodel:@"540K" ofModel:modelId logo:logoId startYear:1936 endYear:1943];
        [self addAutoSubmodel:@"260D" ofModel:modelId logo:logoId startYear:1936 endYear:1940];
        [self addAutoSubmodel:@"320 Saloon" ofModel:modelId logo:logoId startYear:1937 endYear:-1];
        [self addAutoSubmodel:@"W125" ofModel:modelId logo:logoId startYear:1937 endYear:-1];
        [self addAutoSubmodel:@"230" ofModel:modelId logo:logoId startYear:1938 endYear:-1];
        [self addAutoSubmodel:@"W163 GP" ofModel:modelId logo:logoId startYear:1939 endYear:-1];
    }
    modelId = [self addAutoModel:@"1950s" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"180" ofModel:modelId logo:logoId startYear:1953 endYear:1962];
        [self addAutoSubmodel:@"190" ofModel:modelId logo:logoId startYear:1956 endYear:1961];
        [self addAutoSubmodel:@"W196 GP" ofModel:modelId logo:logoId startYear:1954 endYear:-1];
        [self addAutoSubmodel:@"220" ofModel:modelId logo:logoId startYear:1954 endYear:1959];
        [self addAutoSubmodel:@"300SLR" ofModel:modelId logo:logoId startYear:1955 endYear:-1];
        [self addAutoSubmodel:@"W196 S" ofModel:modelId logo:logoId startYear:1955 endYear:-1];
        [self addAutoSubmodel:@"300S" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"300SL" ofModel:modelId logo:logoId startYear:1954 endYear:1963];
        [self addAutoSubmodel:@"Gullwing Coupe" ofModel:modelId logo:logoId startYear:1954 endYear:1957];
        [self addAutoSubmodel:@"300SL Roadster" ofModel:modelId logo:logoId startYear:1958 endYear:1963];
        [self addAutoSubmodel:@"190SL" ofModel:modelId logo:logoId startYear:1955 endYear:1963];
    }
    modelId = [self addAutoModel:@"1960s" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"190c" ofModel:modelId logo:logoId startYear:1962 endYear:1955];
        [self addAutoSubmodel:@"230" ofModel:modelId logo:logoId startYear:1965 endYear:1966];
        [self addAutoSubmodel:@"200" ofModel:modelId logo:logoId startYear:1966 endYear:1968];
        [self addAutoSubmodel:@"200D" ofModel:modelId logo:logoId startYear:1966 endYear:1967];
        [self addAutoSubmodel:@"W111" ofModel:modelId logo:logoId startYear:1959 endYear:1971];
        [self addAutoSubmodel:@"W111 Sedan" ofModel:modelId logo:logoId startYear:1959 endYear:1968];
        [self addAutoSubmodel:@"W111 Coupe" ofModel:modelId logo:logoId startYear:1961 endYear:1971];
        [self addAutoSubmodel:@"W111 Convertible" ofModel:modelId logo:logoId startYear:1961 endYear:1971];
        [self addAutoSubmodel:@"W108" ofModel:modelId logo:logoId startYear:1965 endYear:1972];
        [self addAutoSubmodel:@"W109" ofModel:modelId logo:logoId startYear:1965 endYear:1972];
        [self addAutoSubmodel:@"230" ofModel:modelId logo:logoId startYear:1968 endYear:1972];
        [self addAutoSubmodel:@"250" ofModel:modelId logo:logoId startYear:1968 endYear:1972];
    }
    modelId = [self addAutoModel:@"1970s" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"280" ofModel:modelId logo:logoId startYear:1972 endYear:1976];
        [self addAutoSubmodel:@"280C" ofModel:modelId logo:logoId startYear:1973 endYear:1976];
        [self addAutoSubmodel:@"300D" ofModel:modelId logo:logoId startYear:1975 endYear:1976];
        [self addAutoSubmodel:@"W116" ofModel:modelId logo:logoId startYear:1972 endYear:1979];
        [self addAutoSubmodel:@"W113" ofModel:modelId logo:logoId startYear:1963 endYear:1971];
        [self addAutoSubmodel:@"R107" ofModel:modelId logo:logoId startYear:1972 endYear:1989];
    }
    modelId = [self addAutoModel:@"1980s" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"190" ofModel:modelId logo:logoId startYear:1982 endYear:1993];
        [self addAutoSubmodel:@"300D" ofModel:modelId logo:logoId startYear:1977 endYear:1985];
        [self addAutoSubmodel:@"300CD" ofModel:modelId logo:logoId startYear:1978 endYear:1985];
        [self addAutoSubmodel:@"300SD" ofModel:modelId logo:logoId startYear:1981 endYear:1985];
        [self addAutoSubmodel:@"300SDL" ofModel:modelId logo:logoId startYear:1986 endYear:1987];
        [self addAutoSubmodel:@"300TD" ofModel:modelId logo:logoId startYear:1978 endYear:1985];
        [self addAutoSubmodel:@"350SDL" ofModel:modelId logo:logoId startYear:1990 endYear:1991];
        [self addAutoSubmodel:@"500SE" ofModel:modelId logo:logoId startYear:1984 endYear:1991];
        [self addAutoSubmodel:@"500SEC" ofModel:modelId logo:logoId startYear:1984 endYear:1991];
        [self addAutoSubmodel:@"560SEL" ofModel:modelId logo:logoId startYear:1986 endYear:1991];
        [self addAutoSubmodel:@"560SEC" ofModel:modelId logo:logoId startYear:1986 endYear:1991];
        [self addAutoSubmodel:@"300E" ofModel:modelId logo:logoId startYear:1986 endYear:1993];
        [self addAutoSubmodel:@"300CE" ofModel:modelId logo:logoId startYear:1986 endYear:1993];
    }
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
    modelId = [self addAutoModel:@"C class" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"W202" ofModel:modelId logo:logoId startYear:1993 endYear:2000];
        [self addAutoSubmodel:@"W203" ofModel:modelId logo:logoId startYear:2011 endYear:2007];
        [self addAutoSubmodel:@"W204" ofModel:modelId logo:logoId startYear:2008 endYear:0];
    }
    modelId = [self addAutoModel:@"CLK class" ofAuto:autoId logo:logoId startYear:1998 endYear:2003];
    {
        [self addAutoSubmodel:@"CLK Coupe" ofModel:modelId logo:logoId startYear:1998 endYear:2003];
        [self addAutoSubmodel:@"CLK Convertible" ofModel:modelId logo:logoId startYear:1998 endYear:2003];
    }
    modelId = [self addAutoModel:@"E class" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"W123" ofModel:modelId logo:logoId startYear:1976 endYear:1985];
        [self addAutoSubmodel:@"W124" ofModel:modelId logo:logoId startYear:1985 endYear:1996];
        [self addAutoSubmodel:@"W210" ofModel:modelId logo:logoId startYear:1995 endYear:2003];
        [self addAutoSubmodel:@"W211" ofModel:modelId logo:logoId startYear:2002 endYear:2009];
        [self addAutoSubmodel:@"W212" ofModel:modelId logo:logoId startYear:2010 endYear:0];
    }
    modelId = [self addAutoModel:@"G class" ofAuto:autoId logo:logoId startYear:0 endYear:0];
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
    modelId = [self addAutoModel:@"Trucks" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"L Series Truck" ofModel:modelId logo:logoId startYear:1959 endYear:1995];
        [self addAutoSubmodel:@"LP Series Truck" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"NG" ofModel:modelId logo:logoId startYear:1973 endYear:1988];
        [self addAutoSubmodel:@"SK" ofModel:modelId logo:logoId startYear:1988 endYear:1998];
        [self addAutoSubmodel:@"MB700" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"MB800" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Atego" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Axor" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Actors" ofModel:modelId logo:logoId startYear:1995 endYear:0];
        [self addAutoSubmodel:@"Econic" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Unimog" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Zetros" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"1828L (F581)" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"1517L" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Arocs" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
    modelId = [self addAutoModel:@"Vans" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"Transporter" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"N1000" ofModel:modelId logo:logoId startYear:1975 endYear:1977];
        [self addAutoSubmodel:@"N1300" ofModel:modelId logo:logoId startYear:1975 endYear:1977];
        [self addAutoSubmodel:@"MB 100" ofModel:modelId logo:logoId startYear:1981 endYear:1995];
        [self addAutoSubmodel:@"W 368" ofModel:modelId logo:logoId startYear:1996 endYear:2003];
        [self addAutoSubmodel:@"Vito" ofModel:modelId logo:logoId startYear:1996 endYear:0];
        [self addAutoSubmodel:@"W/V 639" ofModel:modelId logo:logoId startYear:2003 endYear:0];
        [self addAutoSubmodel:@"L206" ofModel:modelId logo:logoId startYear:1970 endYear:1977];
        [self addAutoSubmodel:@"T1" ofModel:modelId logo:logoId startYear:1977 endYear:1995];
        [self addAutoSubmodel:@"Sprinter" ofModel:modelId logo:logoId startYear:1995 endYear:0];
        [self addAutoSubmodel:@"Sprinter W/V 906" ofModel:modelId logo:logoId startYear:2006 endYear:0];
        [self addAutoSubmodel:@"L319" ofModel:modelId logo:logoId startYear:1956 endYear:1967];
        [self addAutoSubmodel:@"L405" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"L407" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"T2" ofModel:modelId logo:logoId startYear:1967 endYear:1996];
        [self addAutoSubmodel:@"Vario" ofModel:modelId logo:logoId startYear:1996 endYear:0];
    }
    modelId = [self addAutoModel:@"Concept" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"C111" ofModel:modelId logo:logoId startYear:1969 endYear:-1]; // also 1970, 1978, 1979
        [self addAutoSubmodel:@"Auto 2000" ofModel:modelId logo:logoId startYear:1981 endYear:-1];
        [self addAutoSubmodel:@"NAFA" ofModel:modelId logo:logoId startYear:1982 endYear:-1];
        [self addAutoSubmodel:@"C112" ofModel:modelId logo:logoId startYear:1991 endYear:-1];
        [self addAutoSubmodel:@"F 100" ofModel:modelId logo:logoId startYear:1991 endYear:-1];
        [self addAutoSubmodel:@"Coupe Concept" ofModel:modelId logo:logoId startYear:1993 endYear:-1];
        [self addAutoSubmodel:@"Vario Research Car" ofModel:modelId logo:logoId startYear:1995 endYear:-1];
        [self addAutoSubmodel:@"F 200 Imagination" ofModel:modelId logo:logoId startYear:1996 endYear:-1];
        [self addAutoSubmodel:@"F 300 Life Jet" ofModel:modelId logo:logoId startYear:1997 endYear:-1];
        [self addAutoSubmodel:@"Vision SLR" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
        [self addAutoSubmodel:@"Vision SLA" ofModel:modelId logo:logoId startYear:2000 endYear:-1];
        [self addAutoSubmodel:@"Vision GST" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
        [self addAutoSubmodel:@"F 400 Carving" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
        [self addAutoSubmodel:@"F 500 Mind" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
        [self addAutoSubmodel:@"F 600 HYGENIUS" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
        [self addAutoSubmodel:@"Bionic" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
        [self addAutoSubmodel:@"Ocean Drive" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
        [self addAutoSubmodel:@"F 700" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
        [self addAutoSubmodel:@"FASCINATION" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
        [self addAutoSubmodel:@"S 400 BlueHYBRID" ofModel:modelId logo:logoId startYear:0 endYear:-1];
        [self addAutoSubmodel:@"F-Cell Roadster" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
        [self addAutoSubmodel:@"F 800 Style" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
        [self addAutoSubmodel:@"F 125" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
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