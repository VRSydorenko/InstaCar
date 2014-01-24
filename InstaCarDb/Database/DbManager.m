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

// IMPORTANT: NEVER CHANGE THESE ID's !!!
// Adding allowed but not change
typedef enum {
    first = 0,
    CITROEN,
    AUDI,
    BMW,
    MERCEDES,
    ALFA_ROMEO,
    FORD,
    TOYOTA,
    NISSAN,
    ACURA,
    OPEL,
    SUBARU,
    VOLKSWAGEN,
    BENTLEY,
    BOGDAN,
    GMC,
    DELOREAN,
    HUMMER,
    BUICK,
    MERCURY,
    JEEP,
    INFINITI,
    MAZDA,
    SCANIA,
    ROLLSROYCE,
    BUGATTI,
    ASTONMARTIN,
    CHEVROLET,
    MITSUBISHI,
} IndependentCarIds;

@implementation DbManager{
    sqlite3 *instacarDb;
}

-(id) init{
    self = [super init];
    if (self){
        [self initDatabase];
        
        NSDate *start = [NSDate date];
        
        [self initData];
        
        NSDate *elapsed = [NSDate date];
        NSTimeInterval executionTime = [elapsed timeIntervalSinceDate:start];
        NSLog(@"Execution Time: %f", executionTime);
    }
    return self;
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
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath]){
        NSLog(@"Database file found. Deleting...");
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:databasePath error:&error];
        if (error){
            NSLog(@"Error removing th edatabase file: %@", error.localizedDescription);
        } else {
            NSLog(@"Database file removed");
        }
    } else {
        NSLog(@"Database file not found. Creating new one...");
    }
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &instacarDb) == SQLITE_OK)
    {
        [self createTables];
    } else {
        DLog(@"Failed to create database");
        DLog(@"Info: %s", sqlite3_errmsg(instacarDb));
    }
}

-(void)createTables{
    DBDefinition* dbDef = [[DBDefinition alloc] init];
    char *err;
    for (NSString *sql in [dbDef getTablesCreationQueries]) {
        if (sqlite3_exec(instacarDb, [sql UTF8String], nil, nil, &err) == SQLITE_OK){
            DLog(@"Table created");
        } else {
            DLog(@"Table creation failed: %@", [NSString stringWithUTF8String:err]);
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
#pragma mark -
#pragma mark A
    // B
#pragma mark -
#pragma mark B
    // C
#pragma mark -
#pragma mark C
    // D
#pragma mark -
#pragma mark D
    // E
#pragma mark -
#pragma mark E
    // F
#pragma mark -
#pragma mark F
#pragma mark === France ===
    countryId = [self addCountry:@"France"];
#pragma mark |---- Citroёn
    logoId = [self addLogo:@"citroen_256.png"]; // TODO: add second Citroen logo
    autoId = [self addAuto:@"CITROËN" country:countryId logo:logoId independentId:CITROEN];
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
    
#pragma mark |---- Bugatti
    logoId = [self addLogo:@"bugatti_256.png"];
    autoId = [self addAuto:@"Bugatti" country:countryId logo:logoId independentId:BUGATTI];
    
    [self addAutoModel:@"16C Galibier" ofAuto:autoId logo:logoId startYear:2009 endYear:-1];
    [self addAutoModel:@"18/3 Chiron" ofAuto:autoId logo:logoId startYear:1999 endYear:-1];
    [self addAutoModel:@"Dietrich" ofAuto:autoId logo:logoId startYear:1901 endYear:-1];
    [self addAutoModel:@"EB110" ofAuto:autoId logo:logoId startYear:1991 endYear:1995];
    [self addAutoModel:@"EB118" ofAuto:autoId logo:logoId startYear:1998 endYear:-1];
    [self addAutoModel:@"EB218" ofAuto:autoId logo:logoId startYear:1999 endYear:-1];
    [self addAutoModel:@"Royale" ofAuto:autoId logo:logoId startYear:1927 endYear:1933];
    [self addAutoModel:@"Veyron" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
    
    modelId = [self addAutoModel:@"Types" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"Type 1" ofModel:modelId logo:logoId startYear:1899 endYear:-1];
        [self addAutoSubmodel:@"Type 10	" ofModel:modelId logo:logoId startYear:1908 endYear:1909];
        [self addAutoSubmodel:@"Type 101" ofModel:modelId logo:logoId startYear:1951 endYear:1956];
        [self addAutoSubmodel:@"Type 13" ofModel:modelId logo:logoId startYear:1910 endYear:1920];
        [self addAutoSubmodel:@"Type 15" ofModel:modelId logo:logoId startYear:1910 endYear:1920];
        [self addAutoSubmodel:@"Type 17" ofModel:modelId logo:logoId startYear:1910 endYear:1920];
        [self addAutoSubmodel:@"Type 18" ofModel:modelId logo:logoId startYear:1912 endYear:1914];
        [self addAutoSubmodel:@"Type 22" ofModel:modelId logo:logoId startYear:1910 endYear:1920];
        [self addAutoSubmodel:@"Type 23" ofModel:modelId logo:logoId startYear:1910 endYear:1920];
        [self addAutoSubmodel:@"Type 251" ofModel:modelId logo:logoId startYear:1955 endYear:-1];
        [self addAutoSubmodel:@"Type 252" ofModel:modelId logo:logoId startYear:1957 endYear:1962];
        [self addAutoSubmodel:@"Type 30" ofModel:modelId logo:logoId startYear:1922 endYear:1926];
        [self addAutoSubmodel:@"Type 32" ofModel:modelId logo:logoId startYear:1923 endYear:-1];
        [self addAutoSubmodel:@"Type 35" ofModel:modelId logo:logoId startYear:1924 endYear:1929];
        [self addAutoSubmodel:@"Type 36" ofModel:modelId logo:logoId startYear:1925 endYear:-1];
        [self addAutoSubmodel:@"Type 37" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"Type 37A" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"Type 38" ofModel:modelId logo:logoId startYear:1926 endYear:1927];
        [self addAutoSubmodel:@"Type 39" ofModel:modelId logo:logoId startYear:1924 endYear:1929];
        [self addAutoSubmodel:@"Type 40" ofModel:modelId logo:logoId startYear:1926 endYear:1930];
        
        [self addAutoSubmodel:@"Type 41" ofModel:modelId logo:logoId startYear:1927 endYear:1933];
        [self addAutoSubmodel:@"Type 43" ofModel:modelId logo:logoId startYear:1922 endYear:1934];
        [self addAutoSubmodel:@"Type 44" ofModel:modelId logo:logoId startYear:1927 endYear:1930];
        [self addAutoSubmodel:@"Type 45" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"Type 46" ofModel:modelId logo:logoId startYear:1929 endYear:1939];
        [self addAutoSubmodel:@"Type 47" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"Type 49" ofModel:modelId logo:logoId startYear:1922 endYear:1934];
        [self addAutoSubmodel:@"Type 50" ofModel:modelId logo:logoId startYear:1929 endYear:1939];
        [self addAutoSubmodel:@"Type 51" ofModel:modelId logo:logoId startYear:1931 endYear:1934];
        [self addAutoSubmodel:@"Type 52" ofModel:modelId logo:logoId startYear:1927 endYear:1936];
        [self addAutoSubmodel:@"Type 53" ofModel:modelId logo:logoId startYear:1931 endYear:1932];
        [self addAutoSubmodel:@"Type 54" ofModel:modelId logo:logoId startYear:1931 endYear:1934];
        [self addAutoSubmodel:@"Type 55" ofModel:modelId logo:logoId startYear:1932 endYear:1935];
        [self addAutoSubmodel:@"Type 56" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"Type 57" ofModel:modelId logo:logoId startYear:1934 endYear:1940];
        [self addAutoSubmodel:@"Type 57S Atalante" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"Type 57S" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"Type 59" ofModel:modelId logo:logoId startYear:1934 endYear:-1];
        [self addAutoSubmodel:@"Type 64" ofModel:modelId logo:logoId startYear:1939 endYear:-1];
        [self addAutoSubmodel:@"Type 73" ofModel:modelId logo:logoId startYear:1943 endYear:1947];
        
        [self addAutoSubmodel:@"Type 8" ofModel:modelId logo:logoId startYear:1907 endYear:-1];
        [self addAutoSubmodel:@"Type 9" ofModel:modelId logo:logoId startYear:1907 endYear:-1];
    }
    // G
#pragma mark -
#pragma mark G
#pragma mark === Germany ===
    countryId = [self addCountry:@"Germany"];
#pragma mark |---- Audi
    logoId = [self addLogo:@"audi_256.png"];
    autoId = [self addAuto:@"Audi" country:countryId logo:logoId independentId:AUDI];
    [self addAutoModel:@"50" ofAuto:autoId logo:logoId startYear:1974 endYear:1978];
    modelId = [self addAutoModel:@"80" ofAuto:autoId logo:logoId startYear:1966 endYear:1996];
    {
        [self addAutoSubmodel:@"90" ofModel:modelId logo:logoId startYear:1966 endYear:1996];
        [self addAutoSubmodel:@"Fox" ofModel:modelId logo:logoId startYear:1966 endYear:1996];
        [self addAutoSubmodel:@"5+5" ofModel:modelId logo:logoId startYear:1966 endYear:1996];
        [self addAutoSubmodel:@"Cabriolet" ofModel:modelId logo:logoId startYear:1966 endYear:1996];
        [self addAutoSubmodel:@"F103" ofModel:modelId logo:logoId startYear:1966 endYear:1969];
        [self addAutoSubmodel:@"B1" ofModel:modelId logo:logoId startYear:1972 endYear:1978];
        [self addAutoSubmodel:@"B2" ofModel:modelId logo:logoId startYear:1978 endYear:1986];
        [self addAutoSubmodel:@"4000" ofModel:modelId logo:logoId startYear:1980 endYear:1987];
        [self addAutoSubmodel:@"4000S" ofModel:modelId logo:logoId startYear:1980 endYear:1987];
        [self addAutoSubmodel:@"4000CS Quattro" ofModel:modelId logo:logoId startYear:1980 endYear:1987];
        [self addAutoSubmodel:@"B3" ofModel:modelId logo:logoId startYear:1986 endYear:1991];
        [self addAutoSubmodel:@"B4" ofModel:modelId logo:logoId startYear:1991 endYear:1996];
        [self addAutoSubmodel:@"S2" ofModel:modelId logo:logoId startYear:1990 endYear:1995];
        [self addAutoSubmodel:@"RS2 Avant" ofModel:modelId logo:logoId startYear:1994 endYear:1995];
    }
    modelId = [self addAutoModel:@"100" ofAuto:autoId logo:logoId startYear:1968 endYear:1994];
    {
        [self addAutoSubmodel:@"C1" ofModel:modelId logo:logoId startYear:1968 endYear:1976];
        [self addAutoSubmodel:@"C2" ofModel:modelId logo:logoId startYear:1976 endYear:1982];
        [self addAutoSubmodel:@"C3" ofModel:modelId logo:logoId startYear:1982 endYear:1991];
        [self addAutoSubmodel:@"C4" ofModel:modelId logo:logoId startYear:1991 endYear:1994];
        [self addAutoSubmodel:@"C4 Avant" ofModel:modelId logo:logoId startYear:1991 endYear:1994];
        [self addAutoSubmodel:@"Coupe S" ofModel:modelId logo:logoId startYear:1970 endYear:1989];
        [self addAutoSubmodel:@"LS" ofModel:modelId logo:logoId startYear:1970 endYear:1977];
        [self addAutoSubmodel:@"5000" ofModel:modelId logo:logoId startYear:1977 endYear:1978];
        [self addAutoSubmodel:@"5E" ofModel:modelId logo:logoId startYear:1976 endYear:1982];
        [self addAutoSubmodel:@"" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
    modelId = [self addAutoModel:@"200" ofAuto:autoId logo:logoId startYear:1982 endYear:1991];
    {
        [self addAutoSubmodel:@"C3" ofModel:modelId logo:logoId startYear:1982 endYear:1991];
        [self addAutoSubmodel:@"Quattro Trans AM" ofModel:modelId logo:logoId startYear:1988 endYear:0];
    }
    [self addAutoModel:@"920" ofAuto:autoId logo:logoId startYear:1938 endYear:1940];
    modelId = [self addAutoModel:@"A" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"A1" ofModel:modelId logo:logoId startYear:2010 endYear:0];
        [self addAutoSubmodel:@"A1 Sportback Concept" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
        [self addAutoSubmodel:@"A1 Clubsport Quattro" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
        [self addAutoSubmodel:@"A2" ofModel:modelId logo:logoId startYear:1999 endYear:2005];
        [self addAutoSubmodel:@"A2" ofModel:modelId logo:logoId startYear:2014 endYear:0];
        [self addAutoSubmodel:@"A3" ofModel:modelId logo:logoId startYear:1996 endYear:0];
        [self addAutoSubmodel:@"A4" ofModel:modelId logo:logoId startYear:1994 endYear:0];
        [self addAutoSubmodel:@"A4 B5" ofModel:modelId logo:logoId startYear:1997 endYear:2001];
        [self addAutoSubmodel:@"A4 B6" ofModel:modelId logo:logoId startYear:2000 endYear:2006];
        [self addAutoSubmodel:@"A4 B7" ofModel:modelId logo:logoId startYear:2004 endYear:2008];
        [self addAutoSubmodel:@"A4 B6" ofModel:modelId logo:logoId startYear:2008 endYear:0];
        [self addAutoSubmodel:@"A4 Allroad Quattro" ofModel:modelId logo:logoId startYear:2009 endYear:0];
        [self addAutoSubmodel:@"A5" ofModel:modelId logo:logoId startYear:2007 endYear:0];
        [self addAutoSubmodel:@"A5 Coupe" ofModel:modelId logo:logoId startYear:2007 endYear:0];
        [self addAutoSubmodel:@"A5 Cabriolet" ofModel:modelId logo:logoId startYear:2009 endYear:0];
        [self addAutoSubmodel:@"A6" ofModel:modelId logo:logoId startYear:1994 endYear:0];
        [self addAutoSubmodel:@"A6 C4" ofModel:modelId logo:logoId startYear:1994 endYear:1997];
        [self addAutoSubmodel:@"A6 C5" ofModel:modelId logo:logoId startYear:1997 endYear:2004];
        [self addAutoSubmodel:@"A6 C6" ofModel:modelId logo:logoId startYear:2004 endYear:2011];
        [self addAutoSubmodel:@"A6 C7" ofModel:modelId logo:logoId startYear:2011 endYear:0];
        [self addAutoSubmodel:@"Allroad Quattro" ofModel:modelId logo:logoId startYear:1999 endYear:0];
        [self addAutoSubmodel:@"A6 Allroad Quattro" ofModel:modelId logo:logoId startYear:1999 endYear:0];
        [self addAutoSubmodel:@"A7" ofModel:modelId logo:logoId startYear:2010 endYear:0];
        [self addAutoSubmodel:@"A7 Sportback Concept" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
        [self addAutoSubmodel:@"A8" ofModel:modelId logo:logoId startYear:1994 endYear:0];
        [self addAutoSubmodel:@"A8 D2" ofModel:modelId logo:logoId startYear:1994 endYear:2002];
        [self addAutoSubmodel:@"A8 D3" ofModel:modelId logo:logoId startYear:2003 endYear:2009];
        [self addAutoSubmodel:@"A8 D4" ofModel:modelId logo:logoId startYear:2010 endYear:0];
        [self addAutoSubmodel:@"A8 Coupe" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
        [self addAutoSubmodel:@"Avantissimo" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
        [self addAutoSubmodel:@"Avus quattro" ofModel:modelId logo:logoId startYear:1991 endYear:-1];
    }
    modelId = [self addAutoModel:@"Type (retro)" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"Type A" ofModel:modelId logo:logoId startYear:1910 endYear:1912];
        [self addAutoSubmodel:@"Type B" ofModel:modelId logo:logoId startYear:1910 endYear:1914];
        [self addAutoSubmodel:@"Type C" ofModel:modelId logo:logoId startYear:1912 endYear:1921];
        [self addAutoSubmodel:@"Type D" ofModel:modelId logo:logoId startYear:1912 endYear:1920];
        [self addAutoSubmodel:@"Type E" ofModel:modelId logo:logoId startYear:1911 endYear:1924];
        [self addAutoSubmodel:@"Type G" ofModel:modelId logo:logoId startYear:1914 endYear:1923];
        [self addAutoSubmodel:@"Type K" ofModel:modelId logo:logoId startYear:1922 endYear:1925];
        [self addAutoSubmodel:@"Type M" ofModel:modelId logo:logoId startYear:1924 endYear:1927];
        [self addAutoSubmodel:@"Type P" ofModel:modelId logo:logoId startYear:1931 endYear:1932];
        [self addAutoSubmodel:@"Type R" ofModel:modelId logo:logoId startYear:1928 endYear:1932];
        [self addAutoSubmodel:@"Type SS" ofModel:modelId logo:logoId startYear:1929 endYear:1932];
        [self addAutoSubmodel:@"Type T" ofModel:modelId logo:logoId startYear:1931 endYear:1932];
    }
    modelId = [self addAutoModel:@"Q" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"Q3" ofModel:modelId logo:logoId startYear:2011 endYear:0];
        [self addAutoSubmodel:@"Q3 Vail" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
        [self addAutoSubmodel:@"Q3 Concept" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
        [self addAutoSubmodel:@"Q3 RS" ofModel:modelId logo:logoId startYear:2013 endYear:-1];
        [self addAutoSubmodel:@"Q3 jinlong yufeng" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
        [self addAutoSubmodel:@"Q3 red track" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
        [self addAutoSubmodel:@"Q5" ofModel:modelId logo:logoId startYear:2008 endYear:0];
        [self addAutoSubmodel:@"Q5 Cross Cabriolet Quattro" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
        [self addAutoSubmodel:@"Q5 Custom Concept" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
        [self addAutoSubmodel:@"Q7" ofModel:modelId logo:logoId startYear:2006 endYear:0];
        [self addAutoSubmodel:@"Quattro" ofModel:modelId logo:logoId startYear:1980 endYear:1991];
        [self addAutoSubmodel:@"Quattro S1" ofModel:modelId logo:logoId startYear:1985 endYear:1991];
    }
    modelId = [self addAutoModel:@"R & RS" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"R8 Race" ofModel:modelId logo:logoId startYear:1999 endYear:2005];
        [self addAutoSubmodel:@"R8" ofModel:modelId logo:logoId startYear:2006 endYear:0];
        [self addAutoSubmodel:@"R8 Coupe" ofModel:modelId logo:logoId startYear:2007 endYear:2012];
        [self addAutoSubmodel:@"R8 Spyder" ofModel:modelId logo:logoId startYear:2010 endYear:2012];
        [self addAutoSubmodel:@"R8 Le Mans Concept" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
        [self addAutoSubmodel:@"R8R" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
        [self addAutoSubmodel:@"R10 TDI" ofModel:modelId logo:logoId startYear:2005 endYear:2008];
        [self addAutoSubmodel:@"R15 TDI" ofModel:modelId logo:logoId startYear:2009 endYear:2010];
        [self addAutoSubmodel:@"R18" ofModel:modelId logo:logoId startYear:2011 endYear:0];
        [self addAutoSubmodel:@"Roadjet" ofModel:modelId logo:logoId startYear:2006 endYear:-1];
        [self addAutoSubmodel:@"Rosemeyer" ofModel:modelId logo:logoId startYear:2000 endYear:-1];
        [self addAutoSubmodel:@"RS" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"RS 2 Avant" ofModel:modelId logo:logoId startYear:1994 endYear:1995];
        [self addAutoSubmodel:@"RS 4" ofModel:modelId logo:logoId startYear:2004 endYear:0];
        [self addAutoSubmodel:@"RS 6" ofModel:modelId logo:logoId startYear:2002 endYear:0];
        [self addAutoSubmodel:@"RSQ" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
    }
    modelId = [self addAutoModel:@"S" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"S2" ofModel:modelId logo:logoId startYear:1991 endYear:1996];
        [self addAutoSubmodel:@"S4" ofModel:modelId logo:logoId startYear:1991 endYear:0];
        [self addAutoSubmodel:@"S4 25quattro" ofModel:modelId logo:logoId startYear:2005 endYear:0];
        [self addAutoSubmodel:@"S5" ofModel:modelId logo:logoId startYear:2007 endYear:0];
        [self addAutoSubmodel:@"S6" ofModel:modelId logo:logoId startYear:1994 endYear:0];
        [self addAutoSubmodel:@"S6 C4" ofModel:modelId logo:logoId startYear:1994 endYear:1997];
        [self addAutoSubmodel:@"S6 C5" ofModel:modelId logo:logoId startYear:1999 endYear:2003];
        [self addAutoSubmodel:@"S6 C6" ofModel:modelId logo:logoId startYear:2006 endYear:2011];
        [self addAutoSubmodel:@"S6 C7" ofModel:modelId logo:logoId startYear:2012 endYear:0];
        [self addAutoSubmodel:@"S8" ofModel:modelId logo:logoId startYear:1994 endYear:0];
    }
    [self addAutoModel:@"Shooting Brake" ofAuto:autoId logo:logoId startYear:2005 endYear:-1];
    [self addAutoModel:@"Steppenwolf" ofAuto:autoId logo:logoId startYear:2001 endYear:-1];
    [self addAutoModel:@"TT" ofAuto:autoId logo:logoId startYear:1998 endYear:0];
    [self addAutoModel:@"TT RS" ofAuto:autoId logo:logoId startYear:2009 endYear:0];
    [self addAutoModel:@"V8" ofAuto:autoId logo:logoId startYear:1988 endYear:1993];
#pragma mark |---- BMW
    logoId = [self addLogo:@"bmw_256.png"];
    autoId = [self addAuto:@"BMW" country:countryId logo:logoId independentId:BMW];
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
    autoId = [self addAuto:@"Mercedes-Benz" country:countryId logo:logoId independentId:MERCEDES];
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
    [self addAutoModel:@"R class" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
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
#pragma mark |---- Opel
    logoId = [self addLogo:@"opel_256.png"];
    autoId = [self addAuto:@"Opel" country:countryId logo:logoId independentId:OPEL];
    
	modelId = [self addAutoModel:@"Retro Car" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	{
		[self addAutoSubmodel:@"1 litre" ofModel:modelId logo:logoId startYear:1933 endYear:1933];
		[self addAutoSubmodel:@"1.2 litre" ofModel:modelId logo:logoId startYear:1931 endYear:1935];
		[self addAutoSubmodel:@"1.3 litre" ofModel:modelId logo:logoId startYear:1934 endYear:1935];
		[self addAutoSubmodel:@"1.8 litre" ofModel:modelId logo:logoId startYear:1931 endYear:1933];
		[self addAutoSubmodel:@"10/30 PS" ofModel:modelId logo:logoId startYear:1922 endYear:1924];
		[self addAutoSubmodel:@"10/35 PS" ofModel:modelId logo:logoId startYear:1922 endYear:1924];
		[self addAutoSubmodel:@"10/40 PS" ofModel:modelId logo:logoId startYear:1925 endYear:1929];
		[self addAutoSubmodel:@"10/45 PS" ofModel:modelId logo:logoId startYear:1925 endYear:1929];
		[self addAutoSubmodel:@"10/50 PS" ofModel:modelId logo:logoId startYear:1925 endYear:1929];
		[self addAutoSubmodel:@"2.0 litre" ofModel:modelId logo:logoId startYear:1934 endYear:1937];
		[self addAutoSubmodel:@"4/8 PS" ofModel:modelId logo:logoId startYear:1909 endYear:1910];
		[self addAutoSubmodel:@"5/12 PS" ofModel:modelId logo:logoId startYear:1911 endYear:1920];
		[self addAutoSubmodel:@"8/40 PS" ofModel:modelId logo:logoId startYear:1927 endYear:1930];
		[self addAutoSubmodel:@"Admiral" ofModel:modelId logo:logoId startYear:1937 endYear:1939];
		[self addAutoSubmodel:@"P4" ofModel:modelId logo:logoId startYear:1935 endYear:1937];
		[self addAutoSubmodel:@"Patent Motor Car" ofModel:modelId logo:logoId startYear:1899 endYear:1902];
		[self addAutoSubmodel:@"RAK" ofModel:modelId logo:logoId startYear:1928 endYear:-1];
		[self addAutoSubmodel:@"RAK2" ofModel:modelId logo:logoId startYear:1928 endYear:-1];
		[self addAutoSubmodel:@"Regent" ofModel:modelId logo:logoId startYear:1928 endYear:1929];
	}
	
	[self addAutoModel:@"Adam" ofAuto:autoId logo:logoId startYear:2012 endYear:0];
	
	modelId = [self addAutoModel:@"Agila" ofAuto:autoId logo:logoId startYear:2000 endYear:0];
	{
		[self addAutoSubmodel:@"A" ofModel:modelId logo:logoId startYear:2000 endYear:2007];
		[self addAutoSubmodel:@"B" ofModel:modelId logo:logoId startYear:2007 endYear:0];
	}
	
	[self addAutoModel:@"Ampera" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
	[self addAutoModel:@"Antara" ofAuto:autoId logo:logoId startYear:2006 endYear:0];
	[self addAutoModel:@"Arena" ofAuto:autoId logo:logoId startYear:1981 endYear:0];
	
	modelId = [self addAutoModel:@"Ascona" ofAuto:autoId logo:logoId startYear:1970 endYear:1988];
	{
		[self addAutoSubmodel:@"A" ofModel:modelId logo:logoId startYear:1970 endYear:1975];
		[self addAutoSubmodel:@"B" ofModel:modelId logo:logoId startYear:1975 endYear:1981];
	}
	
	[self addAutoModel:@"Astra" ofAuto:autoId logo:logoId startYear:1991 endYear:0];
	[self addAutoModel:@"Astra 200t S" ofAuto:autoId logo:logoId startYear:1993 endYear:1996];
	[self addAutoModel:@"Bedford Blitz" ofAuto:autoId logo:logoId startYear:1969 endYear:1988];
	[self addAutoModel:@"Blazer" ofAuto:autoId logo:logoId startYear:1983 endYear:2005];
	[self addAutoModel:@"Blitz" ofAuto:autoId logo:logoId startYear:1930 endYear:1975];
	[self addAutoModel:@"Calais" ofAuto:autoId logo:logoId startYear:1995 endYear:2000];
	[self addAutoModel:@"Calibra" ofAuto:autoId logo:logoId startYear:1989 endYear:1997];
	[self addAutoModel:@"Campo" ofAuto:autoId logo:logoId startYear:1972 endYear:2002];
	[self addAutoModel:@"Cascada" ofAuto:autoId logo:logoId startYear:2013 endYear:0];
	[self addAutoModel:@"Chevette" ofAuto:autoId logo:logoId startYear:1975 endYear:1984];
	[self addAutoModel:@"Combo" ofAuto:autoId logo:logoId startYear:1994 endYear:0];
	[self addAutoModel:@"Commodore" ofAuto:autoId logo:logoId startYear:1967 endYear:1982];
	[self addAutoModel:@"Corsa" ofAuto:autoId logo:logoId startYear:1982 endYear:0];
	[self addAutoModel:@"Corsa Utility" ofAuto:autoId logo:logoId startYear:2003 endYear:0];
	[self addAutoModel:@"Diplomat" ofAuto:autoId logo:logoId startYear:1964 endYear:1977];
	[self addAutoModel:@"Frontera" ofAuto:autoId logo:logoId startYear:1989 endYear:2004];
	[self addAutoModel:@"Gemini" ofAuto:autoId logo:logoId startYear:1974 endYear:2000];
	[self addAutoModel:@"GT" ofAuto:autoId logo:logoId startYear:1968 endYear:1973];
	[self addAutoModel:@"Insignia" ofAuto:autoId logo:logoId startYear:2008 endYear:0];
	[self addAutoModel:@"Isuzu" ofAuto:autoId logo:logoId startYear:1974 endYear:2000];
	
	[self addAutoModel:@"K-180" ofAuto:autoId logo:logoId startYear:1974 endYear:1979];
	[self addAutoModel:@"Kadett" ofAuto:autoId logo:logoId startYear:1937 endYear:1991];
	[self addAutoModel:@"Kapitän" ofAuto:autoId logo:logoId startYear:1931 endYear:1970];
	[self addAutoModel:@"Laubfrosch" ofAuto:autoId logo:logoId startYear:1924 endYear:1931];
	[self addAutoModel:@"Lotus Omega" ofAuto:autoId logo:logoId startYear:1990 endYear:1992];
	[self addAutoModel:@"Manta" ofAuto:autoId logo:logoId startYear:1970 endYear:1988];
	[self addAutoModel:@"Meriva" ofAuto:autoId logo:logoId startYear:2002 endYear:0];
	[self addAutoModel:@"Mokka" ofAuto:autoId logo:logoId startYear:2012 endYear:0];
	[self addAutoModel:@"Monterey" ofAuto:autoId logo:logoId startYear:1981 endYear:2005];
	[self addAutoModel:@"Monza" ofAuto:autoId logo:logoId startYear:1978 endYear:1986];
	[self addAutoModel:@"Olympia" ofAuto:autoId logo:logoId startYear:1935 endYear:1970];
	[self addAutoModel:@"Olympia Rekord" ofAuto:autoId logo:logoId startYear:1953 endYear:1957];
	[self addAutoModel:@"Rekord P1" ofAuto:autoId logo:logoId startYear:1957 endYear:1962];
	[self addAutoModel:@"Omega" ofAuto:autoId logo:logoId startYear:1986 endYear:2003];
	
	modelId = [self addAutoModel:@"Rekord" ofAuto:autoId logo:logoId startYear:1953 endYear:1986];
	{
		[self addAutoSubmodel:@"Series A" ofModel:modelId logo:logoId startYear:1963 endYear:1965];
		[self addAutoSubmodel:@"Series B" ofModel:modelId logo:logoId startYear:1965 endYear:1966];
		[self addAutoSubmodel:@"Series C" ofModel:modelId logo:logoId startYear:1966 endYear:1971];
		[self addAutoSubmodel:@"Series D" ofModel:modelId logo:logoId startYear:1971 endYear:1977];
		[self addAutoSubmodel:@"Series E" ofModel:modelId logo:logoId startYear:1977 endYear:1986];
		[self addAutoSubmodel:@"P2" ofModel:modelId logo:logoId startYear:1960 endYear:1963];
	}
	
	[self addAutoModel:@"Senator" ofAuto:autoId logo:logoId startYear:1978 endYear:1993];
	[self addAutoModel:@"Signum" ofAuto:autoId logo:logoId startYear:2003 endYear:2008];
	[self addAutoModel:@"Sintra" ofAuto:autoId logo:logoId startYear:1996 endYear:1999];
	[self addAutoModel:@"Speedster" ofAuto:autoId logo:logoId startYear:2000 endYear:2005];
	[self addAutoModel:@"Super 6" ofAuto:autoId logo:logoId startYear:1937 endYear:1938];
	[self addAutoModel:@"Tigra" ofAuto:autoId logo:logoId startYear:1994 endYear:2009];
	[self addAutoModel:@"Vectra" ofAuto:autoId logo:logoId startYear:1988 endYear:2008];
	[self addAutoModel:@"Vivaro" ofAuto:autoId logo:logoId startYear:1981 endYear:0];
	[self addAutoModel:@"Zafira" ofAuto:autoId logo:logoId startYear:1999 endYear:0];
    
#pragma mark |---- Volkswagen
    logoId = [self addLogo:@"vw_256.png"];
    autoId = [self addAuto:@"Volkswagen" country:countryId logo:logoId independentId:VOLKSWAGEN];
	
	[self addAutoModel:@"Type 181" ofAuto:autoId logo:logoId startYear:1968 endYear:1983];
	[self addAutoModel:@"Acapulco" ofAuto:autoId logo:logoId startYear:1968 endYear:1983];
	[self addAutoModel:@"276 Schlepperfahrzeug" ofAuto:autoId logo:logoId startYear:1940 endYear:1945];
	[self addAutoModel:@"Adventurewagen" ofAuto:autoId logo:logoId startYear:0000 endYear:0000];
	[self addAutoModel:@"Amarok" ofAuto:autoId logo:logoId startYear:2009 endYear:0000];
	[self addAutoModel:@"ARVW" ofAuto:autoId logo:logoId startYear:1979 endYear:-1];
	[self addAutoModel:@"Basistransporter" ofAuto:autoId logo:logoId startYear:1975 endYear:1979];
	[self addAutoModel:@"Beduin" ofAuto:autoId logo:logoId startYear:2007 endYear:0000];
	[self addAutoModel:@"Beetle" ofAuto:autoId logo:logoId startYear:1938 endYear:2003];
	[self addAutoModel:@"New Beetle" ofAuto:autoId logo:logoId startYear:1997 endYear:2012];
	[self addAutoModel:@"Bluebird Tucana" ofAuto:autoId logo:logoId startYear:0000 endYear:0000];
	[self addAutoModel:@"Bora" ofAuto:autoId logo:logoId startYear:1999 endYear:0000];
	[self addAutoModel:@"Brasilia" ofAuto:autoId logo:logoId startYear:1973 endYear:1982];
	[self addAutoModel:@"Caddy" ofAuto:autoId logo:logoId startYear:1998 endYear:0000];
	[self addAutoModel:@"California" ofAuto:autoId logo:logoId startYear:1989 endYear:0000];
	[self addAutoModel:@"Caravelle" ofAuto:autoId logo:logoId startYear:0000 endYear:0000];
	[self addAutoModel:@"Chico" ofAuto:autoId logo:logoId startYear:0000 endYear:0000];
	[self addAutoModel:@"Citi Golf" ofAuto:autoId logo:logoId startYear:1984 endYear:0000];
	[self addAutoModel:@"Concept BlueSport" ofAuto:autoId logo:logoId startYear:2009 endYear:-1];
	[self addAutoModel:@"Constellation" ofAuto:autoId logo:logoId startYear:2005 endYear:0000];
	
	[self addAutoModel:@"Corrado" ofAuto:autoId logo:logoId startYear:1988 endYear:1995];
	[self addAutoModel:@"Country Buggy" ofAuto:autoId logo:logoId startYear:0000 endYear:0000];
	[self addAutoModel:@"Crafter" ofAuto:autoId logo:logoId startYear:2006 endYear:0000];
	[self addAutoModel:@"Delivery" ofAuto:autoId logo:logoId startYear:0000 endYear:0000];
	[self addAutoModel:@"Derby" ofAuto:autoId logo:logoId startYear:1977 endYear:1981];
	[self addAutoModel:@"Doublecab" ofAuto:autoId logo:logoId startYear:0000 endYear:0000];
	[self addAutoModel:@"EDAG Biwak" ofAuto:autoId logo:logoId startYear:2006 endYear:0000];
	[self addAutoModel:@"Eos" ofAuto:autoId logo:logoId startYear:2006 endYear:0000];
	[self addAutoModel:@"Fagbug" ofAuto:autoId logo:logoId startYear:0000 endYear:0000];
	[self addAutoModel:@"Fox" ofAuto:autoId logo:logoId startYear:2003 endYear:0000];
	[self addAutoModel:@"Gol" ofAuto:autoId logo:logoId startYear:1980 endYear:0000];
	[self addAutoModel:@"Biagini Passo" ofAuto:autoId logo:logoId startYear:1990 endYear:1993];
	
	modelId = [self addAutoModel:@"Golf" ofAuto:autoId logo:logoId startYear:1974 endYear:0];
	{
		[self addAutoSubmodel:@"Country Cabrio" ofModel:modelId logo:logoId startYear:1990 endYear:1993];
		[self addAutoSubmodel:@"Mk1" ofModel:modelId logo:logoId startYear:1974 endYear:2009];
		[self addAutoSubmodel:@"Mk2" ofModel:modelId logo:logoId startYear:1983 endYear:1992];
		[self addAutoSubmodel:@"Mk3" ofModel:modelId logo:logoId startYear:1992 endYear:2002];
		[self addAutoSubmodel:@"Mk4" ofModel:modelId logo:logoId startYear:1999 endYear:2006];
		[self addAutoSubmodel:@"Mk5" ofModel:modelId logo:logoId startYear:2003 endYear:2009];
		[self addAutoSubmodel:@"Mk6" ofModel:modelId logo:logoId startYear:2008 endYear:2013];
		[self addAutoSubmodel:@"Mk7" ofModel:modelId logo:logoId startYear:2012 endYear:0000];
		[self addAutoSubmodel:@"Plus" ofModel:modelId logo:logoId startYear:2004 endYear:0];
		[self addAutoSubmodel:@"Variant" ofModel:modelId logo:logoId startYear:1993 endYear:0];
	}
	
	[self addAutoModel:@"Herbie" ofAuto:autoId logo:logoId startYear:0000 endYear:0000];
	[self addAutoModel:@"Iltis" ofAuto:autoId logo:logoId startYear:1978 endYear:1988];
	
	modelId = [self addAutoModel:@"Jetta" ofAuto:autoId logo:logoId startYear:1979 endYear:0];
	{
		[self addAutoSubmodel:@"König" ofModel:modelId logo:logoId startYear:1997 endYear:2010];
		[self addAutoSubmodel:@"Night" ofModel:modelId logo:logoId startYear:2013 endYear:0000];
		[self addAutoSubmodel:@"Pionier" ofModel:modelId logo:logoId startYear:2010 endYear:2013];
	}
	
	[self addAutoModel:@"K70" ofAuto:autoId logo:logoId startYear:1970 endYear:1974];
	[self addAutoModel:@"Karmann Ghia" ofAuto:autoId logo:logoId startYear:1955 endYear:1974];
	[self addAutoModel:@"Kübelwagen" ofAuto:autoId logo:logoId startYear:1940 endYear:1945];
	[self addAutoModel:@"L80" ofAuto:autoId logo:logoId startYear:1994 endYear:2000];
	[self addAutoModel:@"Lavida" ofAuto:autoId logo:logoId startYear:2008 endYear:0000];
	[self addAutoModel:@"Logus" ofAuto:autoId logo:logoId startYear:1993 endYear:1996];
	[self addAutoModel:@"LT" ofAuto:autoId logo:logoId startYear:1975 endYear:2006];
	[self addAutoModel:@"Lupo" ofAuto:autoId logo:logoId startYear:1998 endYear:2005];
	[self addAutoModel:@"Milano" ofAuto:autoId logo:logoId startYear:2010 endYear:-1];
	
	modelId = [self addAutoModel:@"Passat" ofAuto:autoId logo:logoId startYear:1973 endYear:0];
	{
		[self addAutoSubmodel:@"NMS" ofModel:modelId logo:logoId startYear:2011 endYear:0000];
		[self addAutoSubmodel:@"B1" ofModel:modelId logo:logoId startYear:1973 endYear:1988];
		[self addAutoSubmodel:@"B2" ofModel:modelId logo:logoId startYear:1981 endYear:1988];
		[self addAutoSubmodel:@"B3" ofModel:modelId logo:logoId startYear:1988 endYear:1993];
		[self addAutoSubmodel:@"B4" ofModel:modelId logo:logoId startYear:1993 endYear:1997];
		[self addAutoSubmodel:@"B5" ofModel:modelId logo:logoId startYear:1996 endYear:2005];
		[self addAutoSubmodel:@"B6" ofModel:modelId logo:logoId startYear:2005 endYear:2010];
		[self addAutoSubmodel:@"B7" ofModel:modelId logo:logoId startYear:2010 endYear:0000];
		[self addAutoSubmodel:@"Lingyu" ofModel:modelId logo:logoId startYear:2005 endYear:2009];
		[self addAutoSubmodel:@"Variant" ofModel:modelId logo:logoId startYear:2009 endYear:0000];
	}
	
	[self addAutoModel:@"CC" ofAuto:autoId logo:logoId startYear:2008 endYear:0000];
	[self addAutoModel:@"Phaeton" ofAuto:autoId logo:logoId startYear:2002 endYear:0000];
	[self addAutoModel:@"Plattenwagen" ofAuto:autoId logo:logoId startYear:0000 endYear:0000];
	[self addAutoModel:@"Pointer" ofAuto:autoId logo:logoId startYear:1994 endYear:1997];
	
	modelId = [self addAutoModel:@"Polo" ofAuto:autoId logo:logoId startYear:1975 endYear:0];
	{
		[self addAutoSubmodel:@"Mk1" ofModel:modelId logo:logoId startYear:1975 endYear:1981];
		[self addAutoSubmodel:@"Mk2" ofModel:modelId logo:logoId startYear:1981 endYear:1994];
		[self addAutoSubmodel:@"Mk3" ofModel:modelId logo:logoId startYear:1994 endYear:2002];
		[self addAutoSubmodel:@"Mk4" ofModel:modelId logo:logoId startYear:2001 endYear:0000];
		[self addAutoSubmodel:@"Mk5" ofModel:modelId logo:logoId startYear:2009 endYear:0000];
		[self addAutoSubmodel:@"G40" ofModel:modelId logo:logoId startYear:1986 endYear:1994];
		[self addAutoSubmodel:@"Playa" ofModel:modelId logo:logoId startYear:1996 endYear:2002];
		[self addAutoSubmodel:@"R WRC" ofModel:modelId logo:logoId startYear:0000 endYear:0000];
	}
	
	[self addAutoModel:@"Porsche 914" ofAuto:autoId logo:logoId startYear:1969 endYear:1976];
	[self addAutoModel:@"Porsche 914-6 GT" ofAuto:autoId logo:logoId startYear:1970 endYear:1972];
	[self addAutoModel:@"Porsche 924" ofAuto:autoId logo:logoId startYear:1976 endYear:1988];
	[self addAutoModel:@"Camper-Riviera" ofAuto:autoId logo:logoId startYear:0000 endYear:0000];
	[self addAutoModel:@"Routan" ofAuto:autoId logo:logoId startYear:2008 endYear:2012];
	[self addAutoModel:@"Samba" ofAuto:autoId logo:logoId startYear:1951 endYear:2013];
	[self addAutoModel:@"Santana" ofAuto:autoId logo:logoId startYear:1981 endYear:2013];
	[self addAutoModel:@"Schwimmwagen" ofAuto:autoId logo:logoId startYear:1942 endYear:1944];
	[self addAutoModel:@"Scirocco" ofAuto:autoId logo:logoId startYear:1974 endYear:0000];
	[self addAutoModel:@"Sharan" ofAuto:autoId logo:logoId startYear:1995 endYear:0000];
	[self addAutoModel:@"SP2" ofAuto:autoId logo:logoId startYear:1972 endYear:1976];
	[self addAutoModel:@"Stanley" ofAuto:autoId logo:logoId startYear:0000 endYear:0000];
	[self addAutoModel:@"Taigun" ofAuto:autoId logo:logoId startYear:2014 endYear:0000];
	[self addAutoModel:@"Taro" ofAuto:autoId logo:logoId startYear:1989 endYear:1997];
	[self addAutoModel:@"Tiguan" ofAuto:autoId logo:logoId startYear:2007 endYear:0000];
	[self addAutoModel:@"Touareg" ofAuto:autoId logo:logoId startYear:2002 endYear:0000];
	[self addAutoModel:@"Touran" ofAuto:autoId logo:logoId startYear:2003 endYear:0000];
	
	modelId = [self addAutoModel:@"Transporter" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	{
		[self addAutoSubmodel:@"T4" ofModel:modelId logo:logoId startYear:1990 endYear:2003];
		[self addAutoSubmodel:@"T5" ofModel:modelId logo:logoId startYear:2003 endYear:0000];
	}
	
	[self addAutoModel:@"Kleinlieferwagen" ofAuto:autoId logo:logoId startYear:1964 endYear:1974];
	[self addAutoModel:@"Fridolin" ofAuto:autoId logo:logoId startYear:1964 endYear:1974];
	[self addAutoModel:@"Type 14A" ofAuto:autoId logo:logoId startYear:1949 endYear:1953];
	[self addAutoModel:@"Hebmüller Cabriolet" ofAuto:autoId logo:logoId startYear:1949 endYear:1953];
	[self addAutoModel:@"Type 2" ofAuto:autoId logo:logoId startYear:1949 endYear:2013];
	[self addAutoModel:@"Type 2 T3" ofAuto:autoId logo:logoId startYear:1979 endYear:2002];
	[self addAutoModel:@"Vanagon" ofAuto:autoId logo:logoId startYear:1979 endYear:2002];
	[self addAutoModel:@"Type 3" ofAuto:autoId logo:logoId startYear:1961 endYear:1973];
	[self addAutoModel:@"Type 4" ofAuto:autoId logo:logoId startYear:1968 endYear:1972];
	[self addAutoModel:@"Up" ofAuto:autoId logo:logoId startYear:2011 endYear:0000];
	[self addAutoModel:@"Vento" ofAuto:autoId logo:logoId startYear:2010 endYear:0000];
	[self addAutoModel:@"Volksbus" ofAuto:autoId logo:logoId startYear:1993 endYear:0000];
	[self addAutoModel:@"Beetle A5" ofAuto:autoId logo:logoId startYear:2001 endYear:0000];
	[self addAutoModel:@"Bora 2007" ofAuto:autoId logo:logoId startYear:2007 endYear:0000];
	
	modelId = [self addAutoModel:@"Westfalia" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	{
		[self addAutoSubmodel:@"Campers" ofModel:modelId logo:logoId startYear:0 endYear:0];
	}
	
	[self addAutoModel:@"Type 18A" ofAuto:autoId logo:logoId startYear:1949 endYear:1950];
	[self addAutoModel:@"W12" ofAuto:autoId logo:logoId startYear:1997 endYear:-1];
	[self addAutoModel:@"Worker" ofAuto:autoId logo:logoId startYear:0000 endYear:0];
    
    // H
#pragma mark -
#pragma mark H
    // I
#pragma mark -
#pragma mark I
#pragma mark === Italy ===
    countryId = [self addCountry:@"Italy"];
#pragma mark |---- Alfa Romeo
    logoId = [self addLogo:@"alfaromeo_256.png"];
    autoId = [self addAuto:@"Alfa Romeo" country:countryId logo:logoId independentId:ALFA_ROMEO];
    modelId = [self addAutoModel:@"1910s" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"24 HP" ofModel:modelId logo:logoId startYear:1910 endYear:1920];
        [self addAutoSubmodel:@"12 HP" ofModel:modelId logo:logoId startYear:1910 endYear:1911];
        [self addAutoSubmodel:@"15 HP" ofModel:modelId logo:logoId startYear:1911 endYear:1920];
        [self addAutoSubmodel:@"40/60 HP" ofModel:modelId logo:logoId startYear:1913 endYear:1922];
        [self addAutoSubmodel:@"15 HP Corsa" ofModel:modelId logo:logoId startYear:1911 endYear:-1];
        [self addAutoSubmodel:@"40-60 HP Corsa" ofModel:modelId logo:logoId startYear:1913 endYear:-1];
        [self addAutoSubmodel:@"Grand Prix" ofModel:modelId logo:logoId startYear:1914 endYear:-1];
    }
    modelId = [self addAutoModel:@"1920s" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"20-30 HP" ofModel:modelId logo:logoId startYear:1921 endYear:1922];
        [self addAutoSubmodel:@"G1" ofModel:modelId logo:logoId startYear:1920 endYear:1921];
        [self addAutoSubmodel:@"G2" ofModel:modelId logo:logoId startYear:1921 endYear:1921];
        [self addAutoSubmodel:@"RL" ofModel:modelId logo:logoId startYear:1922 endYear:1927];
        [self addAutoSubmodel:@"RM" ofModel:modelId logo:logoId startYear:1923 endYear:1925];
        [self addAutoSubmodel:@"6C 1500" ofModel:modelId logo:logoId startYear:1927 endYear:1929];
        [self addAutoSubmodel:@"6C 1750" ofModel:modelId logo:logoId startYear:1929 endYear:1933];
        [self addAutoSubmodel:@"RL Super Sport" ofModel:modelId logo:logoId startYear:1922 endYear:-1];
        [self addAutoSubmodel:@"RL Targa Florio" ofModel:modelId logo:logoId startYear:1923 endYear:-1];
        [self addAutoSubmodel:@"P1" ofModel:modelId logo:logoId startYear:1923 endYear:-1];
        [self addAutoSubmodel:@"P2" ofModel:modelId logo:logoId startYear:1924 endYear:-1];
        [self addAutoSubmodel:@"6C 1500 MMS" ofModel:modelId logo:logoId startYear:1928 endYear:-1];
        [self addAutoSubmodel:@"6C 1750 Super Sport" ofModel:modelId logo:logoId startYear:1929 endYear:-1];
    }
    modelId = [self addAutoModel:@"1930s" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"8C 2300" ofModel:modelId logo:logoId startYear:1931 endYear:1934];
        [self addAutoSubmodel:@"6C 1900" ofModel:modelId logo:logoId startYear:1933 endYear:1933];
        [self addAutoSubmodel:@"6C 2300" ofModel:modelId logo:logoId startYear:1934 endYear:1937];
        [self addAutoSubmodel:@"8C 2900" ofModel:modelId logo:logoId startYear:1935 endYear:1939];
        [self addAutoSubmodel:@"6C 2500" ofModel:modelId logo:logoId startYear:1939 endYear:1950];
        [self addAutoSubmodel:@"Tipo A" ofModel:modelId logo:logoId startYear:1931 endYear:-1];
        [self addAutoSubmodel:@"8C 2300 Monza" ofModel:modelId logo:logoId startYear:1931 endYear:-1];
        [self addAutoSubmodel:@"Tipo B (P3)" ofModel:modelId logo:logoId startYear:1932 endYear:-1];
        [self addAutoSubmodel:@"Bimotore" ofModel:modelId logo:logoId startYear:1935 endYear:-1];
        [self addAutoSubmodel:@"8C 35" ofModel:modelId logo:logoId startYear:1935 endYear:-1];
        [self addAutoSubmodel:@"8C 2900A" ofModel:modelId logo:logoId startYear:1935 endYear:-1];
        [self addAutoSubmodel:@"12C 36" ofModel:modelId logo:logoId startYear:1936 endYear:-1];
        [self addAutoSubmodel:@"12C 37" ofModel:modelId logo:logoId startYear:1937 endYear:-1];
        [self addAutoSubmodel:@"6C 2300B Mille Miglia" ofModel:modelId logo:logoId startYear:1937 endYear:-1];
        [self addAutoSubmodel:@"8C 2900B Mille Miglia" ofModel:modelId logo:logoId startYear:1937 endYear:-1];
        [self addAutoSubmodel:@"308" ofModel:modelId logo:logoId startYear:1938 endYear:-1];
        [self addAutoSubmodel:@"312" ofModel:modelId logo:logoId startYear:1938 endYear:-1];
        [self addAutoSubmodel:@"316" ofModel:modelId logo:logoId startYear:1938 endYear:-1];
        [self addAutoSubmodel:@"158" ofModel:modelId logo:logoId startYear:1938 endYear:-1];
        [self addAutoSubmodel:@"6C 2500 Super Sport Corsa" ofModel:modelId logo:logoId startYear:1939 endYear:-1];
    }
    modelId = [self addAutoModel:@"1940s" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"6C 2500 Competizione" ofModel:modelId logo:logoId startYear:1948 endYear:-1];
    }
    modelId = [self addAutoModel:@"1950s" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"1900" ofModel:modelId logo:logoId startYear:1950 endYear:1958];
        [self addAutoSubmodel:@"Matta" ofModel:modelId logo:logoId startYear:1951 endYear:1953];
        [self addAutoSubmodel:@"Giulietta" ofModel:modelId logo:logoId startYear:1954 endYear:1962];
        [self addAutoSubmodel:@"2000" ofModel:modelId logo:logoId startYear:1958 endYear:1962];
        [self addAutoSubmodel:@"Dauphine" ofModel:modelId logo:logoId startYear:1959 endYear:1964];
        [self addAutoSubmodel:@"159" ofModel:modelId logo:logoId startYear:1951 endYear:-1];
        [self addAutoSubmodel:@"6C 3000 CM" ofModel:modelId logo:logoId startYear:1952 endYear:-1];
    }
    modelId = [self addAutoModel:@"1960s" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"2600" ofModel:modelId logo:logoId startYear:1962 endYear:1968];
        [self addAutoSubmodel:@"Giulia Saloon" ofModel:modelId logo:logoId startYear:1962 endYear:1976];
        [self addAutoSubmodel:@"Giulia TZ" ofModel:modelId logo:logoId startYear:1963 endYear:1967];
        [self addAutoSubmodel:@"Giulia Sprint" ofModel:modelId logo:logoId startYear:1963 endYear:1977];
        [self addAutoSubmodel:@"Giulia Sprint Speciale" ofModel:modelId logo:logoId startYear:1963 endYear:1966];
        [self addAutoSubmodel:@"Gran Sport Quattroruote" ofModel:modelId logo:logoId startYear:1965 endYear:1967];
        [self addAutoSubmodel:@"GTA" ofModel:modelId logo:logoId startYear:1965 endYear:1971];
        [self addAutoSubmodel:@"Spider" ofModel:modelId logo:logoId startYear:1966 endYear:1993];
        [self addAutoSubmodel:@"33 Stradale" ofModel:modelId logo:logoId startYear:1967 endYear:1969];
        [self addAutoSubmodel:@"1750/2000 Berlina" ofModel:modelId logo:logoId startYear:1967 endYear:1977];
        [self addAutoSubmodel:@"Giulietta SZ" ofModel:modelId logo:logoId startYear:1960 endYear:-1];
        [self addAutoSubmodel:@"Giulia TZ" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
        [self addAutoSubmodel:@"GTA" ofModel:modelId logo:logoId startYear:1965 endYear:-1];
        [self addAutoSubmodel:@"Tipo 33" ofModel:modelId logo:logoId startYear:1965 endYear:-1];
        [self addAutoSubmodel:@"33/2" ofModel:modelId logo:logoId startYear:1968 endYear:-1];
        [self addAutoSubmodel:@"33/3" ofModel:modelId logo:logoId startYear:1969 endYear:-1];
    }
    modelId = [self addAutoModel:@"1970s" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"Montreal" ofModel:modelId logo:logoId startYear:1970 endYear:1977];
        [self addAutoSubmodel:@"Alfasud" ofModel:modelId logo:logoId startYear:1972 endYear:1983];
        [self addAutoSubmodel:@"Alfetta saloon" ofModel:modelId logo:logoId startYear:1972 endYear:1984];
        [self addAutoSubmodel:@"Alfetta GT/GTV" ofModel:modelId logo:logoId startYear:1974 endYear:1987];
        [self addAutoSubmodel:@"Alfasud Sprint" ofModel:modelId logo:logoId startYear:1976 endYear:1989];
        [self addAutoSubmodel:@"Nuova Giulietta" ofModel:modelId logo:logoId startYear:1977 endYear:1985];
        [self addAutoSubmodel:@"Alfa 6" ofModel:modelId logo:logoId startYear:1979 endYear:1986];
        [self addAutoSubmodel:@"33/4" ofModel:modelId logo:logoId startYear:1972 endYear:-1];
        [self addAutoSubmodel:@"33TT12" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
        [self addAutoSubmodel:@"33SC12" ofModel:modelId logo:logoId startYear:1976 endYear:-1];
        [self addAutoSubmodel:@"177" ofModel:modelId logo:logoId startYear:1979 endYear:-1];
        [self addAutoSubmodel:@"179" ofModel:modelId logo:logoId startYear:1979 endYear:-1];
    }
    modelId = [self addAutoModel:@"1980s" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"33" ofModel:modelId logo:logoId startYear:1983 endYear:1994];
        [self addAutoSubmodel:@"Arna" ofModel:modelId logo:logoId startYear:1984 endYear:1987];
        [self addAutoSubmodel:@"90" ofModel:modelId logo:logoId startYear:1984 endYear:1987];
        [self addAutoSubmodel:@"75" ofModel:modelId logo:logoId startYear:1985 endYear:1992];
        [self addAutoSubmodel:@"164" ofModel:modelId logo:logoId startYear:1987 endYear:1998];
        [self addAutoSubmodel:@"SZ/RZ" ofModel:modelId logo:logoId startYear:1989 endYear:1993];
        [self addAutoSubmodel:@"182" ofModel:modelId logo:logoId startYear:1982 endYear:-1];
        [self addAutoSubmodel:@"183" ofModel:modelId logo:logoId startYear:1983 endYear:-1];
        [self addAutoSubmodel:@"184" ofModel:modelId logo:logoId startYear:1984 endYear:-1];
        [self addAutoSubmodel:@"185" ofModel:modelId logo:logoId startYear:1985 endYear:-1];
    }
    modelId = [self addAutoModel:@"1990s" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"155" ofModel:modelId logo:logoId startYear:19920 endYear:1998];
        [self addAutoSubmodel:@"145" ofModel:modelId logo:logoId startYear:19940 endYear:2000];
        [self addAutoSubmodel:@"146" ofModel:modelId logo:logoId startYear:19940 endYear:2000];
        [self addAutoSubmodel:@"GTV/Spider" ofModel:modelId logo:logoId startYear:19950 endYear:2006];
        [self addAutoSubmodel:@"156" ofModel:modelId logo:logoId startYear:19970 endYear:2005];
        [self addAutoSubmodel:@"166" ofModel:modelId logo:logoId startYear:19980 endYear:2007];
        [self addAutoSubmodel:@"155 V6 TI" ofModel:modelId logo:logoId startYear:19930 endYear:0];
    }
    modelId = [self addAutoModel:@"2000s" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"147" ofModel:modelId logo:logoId startYear:2000 endYear:2010];
        [self addAutoSubmodel:@"8C Competizione" ofModel:modelId logo:logoId startYear:2007 endYear:2009];
        [self addAutoSubmodel:@"8C Spider" ofModel:modelId logo:logoId startYear:2008 endYear:2010];
        [self addAutoSubmodel:@"GT" ofModel:modelId logo:logoId startYear:2003 endYear:2010];
        [self addAutoSubmodel:@"Brera" ofModel:modelId logo:logoId startYear:2005 endYear:2010];
        [self addAutoSubmodel:@"159" ofModel:modelId logo:logoId startYear:2005 endYear:2011];
        [self addAutoSubmodel:@"Spider" ofModel:modelId logo:logoId startYear:2006 endYear:2010];
    }
    /*modelId = [self addAutoModel:@"" ofAuto:autoId logo:logoId startYear:0 endYear:0];
     {
     [self addAutoSubmodel:@"" ofModel:modelId logo:logoId startYear:0 endYear:0];
     }*/
#pragma mark |---- DeLorean
    logoId = [self addLogo:@"delorean_256.png"];
    autoId = [self addAuto:@"DeLorean" country:countryId logo:logoId independentId:DELOREAN];
    
    [self addAutoModel:@"DMC-12" ofAuto:autoId logo:logoId startYear:1981 endYear:1983];

    // J
#pragma mark -
#pragma mark J
#pragma mark === Japan ===
    countryId = [self addCountry:@"Japan"];
#pragma mark |---- Acura
    logoId = [self addLogo:@"acura_256.png"];
    autoId = [self addAuto:@"Acura" country:countryId logo:logoId independentId:ACURA];
    [self addAutoModel:@"NSX" ofAuto:autoId logo:logoId startYear:2015 endYear:0];
	[self addAutoModel:@"ARX-01" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
	[self addAutoModel:@"ARX-02a" ofAuto:autoId logo:logoId startYear:2009 endYear:0];
	[self addAutoModel:@"CL" ofAuto:autoId logo:logoId startYear:1997 endYear:2003];
	[self addAutoModel:@"CSX" ofAuto:autoId logo:logoId startYear:2005 endYear:2011];
	[self addAutoModel:@"EL" ofAuto:autoId logo:logoId startYear:1997 endYear:2005];
	[self addAutoModel:@"ILX" ofAuto:autoId logo:logoId startYear:2012 endYear:0];
	[self addAutoModel:@"Integra" ofAuto:autoId logo:logoId startYear:1985 endYear:2006];
	[self addAutoModel:@"Legend" ofAuto:autoId logo:logoId startYear:1986 endYear:1995];
	[self addAutoModel:@"MDX" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
	[self addAutoModel:@"RDX" ofAuto:autoId logo:logoId startYear:2006 endYear:0];
	[self addAutoModel:@"RL" ofAuto:autoId logo:logoId startYear:1995 endYear:2012];
	[self addAutoModel:@"RLX" ofAuto:autoId logo:logoId startYear:2013 endYear:0];
	[self addAutoModel:@"Integra DC5" ofAuto:autoId logo:logoId startYear:2001 endYear:2006];
	[self addAutoModel:@"SLX" ofAuto:autoId logo:logoId startYear:1996 endYear:1999];
	[self addAutoModel:@"TL" ofAuto:autoId logo:logoId startYear:1996 endYear:0];
	[self addAutoModel:@"TSX" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
	[self addAutoModel:@"Vigor" ofAuto:autoId logo:logoId startYear:1981 endYear:1995];
	[self addAutoModel:@"ZDX" ofAuto:autoId logo:logoId startYear:2009 endYear:0];
#pragma mark |---- Nissan
    logoId = [self addLogo:@"nissan_256.png"];
    autoId = [self addAuto:@"Nissan" country:countryId logo:logoId independentId:NISSAN];
    [self addAutoModel:@"100NX" ofAuto:autoId logo:logoId startYear:1991 endYear:1996];
	[self addAutoModel:@"180SX" ofAuto:autoId logo:logoId startYear:1989 endYear:1998];
	[self addAutoModel:@"200SX" ofAuto:autoId logo:logoId startYear:1977 endYear:2002];
	[self addAutoModel:@"200SX" ofAuto:autoId logo:logoId startYear:1995 endYear:1998];
	[self addAutoModel:@"240SX" ofAuto:autoId logo:logoId startYear:1989 endYear:1998];
	[self addAutoModel:@"300C" ofAuto:autoId logo:logoId startYear:1984 endYear:1987];
	[self addAutoModel:@"300ZX Z31" ofAuto:autoId logo:logoId startYear:1984 endYear:1989];
	[self addAutoModel:@"300ZX Z32" ofAuto:autoId logo:logoId startYear:1990 endYear:1999];
	[self addAutoModel:@"350Z Z33" ofAuto:autoId logo:logoId startYear:2003 endYear:2008];
	[self addAutoModel:@"370Z Z34" ofAuto:autoId logo:logoId startYear:2009 endYear:0];
	[self addAutoModel:@"Almera" ofAuto:autoId logo:logoId startYear:1995 endYear:2006];
	[self addAutoModel:@"Altima" ofAuto:autoId logo:logoId startYear:1993 endYear:0];
	[self addAutoModel:@"Armada" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
	[self addAutoModel:@"Atlas" ofAuto:autoId logo:logoId startYear:1982 endYear:0];
	[self addAutoModel:@"Auster" ofAuto:autoId logo:logoId startYear:1984 endYear:1989];
	[self addAutoModel:@"Avenir" ofAuto:autoId logo:logoId startYear:1990 endYear:2003];
	[self addAutoModel:@"Axxess" ofAuto:autoId logo:logoId startYear:1990 endYear:-1];
	[self addAutoModel:@"Be-1" ofAuto:autoId logo:logoId startYear:1989 endYear:-1];
	[self addAutoModel:@"Bassara" ofAuto:autoId logo:logoId startYear:1999 endYear:2003];
	modelId = [self addAutoModel:@"Bluebird" ofAuto:autoId logo:logoId startYear:1957 endYear:0];
    {
		[self addAutoSubmodel:@"U12" ofModel:modelId logo:logoId startYear:1987 endYear:1992];
		[self addAutoSubmodel:@"U13" ofModel:modelId logo:logoId startYear:1991 endYear:1997];
		[self addAutoSubmodel:@"U14" ofModel:modelId logo:logoId startYear:1996 endYear:2001];
		[self addAutoSubmodel:@"Sylphy" ofModel:modelId logo:logoId startYear:2000 endYear:0];
	}
	[self addAutoModel:@"C80" ofAuto:autoId logo:logoId startYear:1966 endYear:1976];
	[self addAutoModel:@"Caball" ofAuto:autoId logo:logoId startYear:1957 endYear:1981];
	[self addAutoModel:@"Cablight" ofAuto:autoId logo:logoId startYear:1958 endYear:1964];
	[self addAutoModel:@"Cabstar" ofAuto:autoId logo:logoId startYear:1968 endYear:1975];
	[self addAutoModel:@"Cedric" ofAuto:autoId logo:logoId startYear:1960 endYear:2004];
	[self addAutoModel:@"Gloria" ofAuto:autoId logo:logoId startYear:1960 endYear:2004];
	[self addAutoModel:@"Cedric Y31" ofAuto:autoId logo:logoId startYear:1987 endYear:0];
	[self addAutoModel:@"Cefiro" ofAuto:autoId logo:logoId startYear:1988 endYear:2003];
	[self addAutoModel:@"Cherry" ofAuto:autoId logo:logoId startYear:1970 endYear:1986];
	[self addAutoModel:@"Cima" ofAuto:autoId logo:logoId startYear:1988 endYear:0];
	[self addAutoModel:@"Clipper" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
	[self addAutoModel:@"Clipper Rio" ofAuto:autoId logo:logoId startYear:2007 endYear:2011];
	[self addAutoModel:@"Crew" ofAuto:autoId logo:logoId startYear:1993 endYear:2009];
	[self addAutoModel:@"Cube" ofAuto:autoId logo:logoId startYear:1998 endYear:0];
	[self addAutoModel:@"Elgrand" ofAuto:autoId logo:logoId startYear:1998 endYear:0];
	[self addAutoModel:@"Fairlady" ofAuto:autoId logo:logoId startYear:1959 endYear:1970];
	[self addAutoModel:@"Figaro" ofAuto:autoId logo:logoId startYear:1991 endYear:-1];
	[self addAutoModel:@"Fuga" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
	[self addAutoModel:@"Gazelle" ofAuto:autoId logo:logoId startYear:1979 endYear:1988];
	[self addAutoModel:@"GTP ZX-Turbo" ofAuto:autoId logo:logoId startYear:1985 endYear:-1];
	[self addAutoModel:@"GT-R" ofAuto:autoId logo:logoId startYear:2008 endYear:0];
	
	[self addAutoModel:@"Homy" ofAuto:autoId logo:logoId startYear:1965 endYear:1997];
	[self addAutoModel:@"Hypermini" ofAuto:autoId logo:logoId startYear:1999 endYear:2001];
	[self addAutoModel:@"Interstar" ofAuto:autoId logo:logoId startYear:1999 endYear:0];
	[self addAutoModel:@"Juke" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
	[self addAutoModel:@"Junior Pickup" ofAuto:autoId logo:logoId startYear:1956 endYear:1982];
	[self addAutoModel:@"Kix" ofAuto:autoId logo:logoId startYear:2008 endYear:2012];
	[self addAutoModel:@"Kubistar" ofAuto:autoId logo:logoId startYear:1997 endYear:2008];
	[self addAutoModel:@"Lafesta" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
	[self addAutoModel:@"Largo" ofAuto:autoId logo:logoId startYear:1988 endYear:1998];
	[self addAutoModel:@"Latio" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
	[self addAutoModel:@"Laurel" ofAuto:autoId logo:logoId startYear:1968 endYear:2002];
	[self addAutoModel:@"Leaf" ofAuto:autoId logo:logoId startYear:2009 endYear:0];
	[self addAutoModel:@"Leopard" ofAuto:autoId logo:logoId startYear:1980 endYear:1999];
	[self addAutoModel:@"Maxima" ofAuto:autoId logo:logoId startYear:1981 endYear:0];
	[self addAutoModel:@"Multi" ofAuto:autoId logo:logoId startYear:1984 endYear:0];
	[self addAutoModel:@"Murano" ofAuto:autoId logo:logoId startYear:2003 endYear:0];
	[self addAutoModel:@"Micra" ofAuto:autoId logo:logoId startYear:1982 endYear:0];
	[self addAutoModel:@"Moco" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
	[self addAutoModel:@"Navara" ofAuto:autoId logo:logoId startYear:1998 endYear:0];
	[self addAutoModel:@"Frontier" ofAuto:autoId logo:logoId startYear:1998 endYear:0];
	
	[self addAutoModel:@"Note" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"NPT-90" ofAuto:autoId logo:logoId startYear:1990 endYear:-1];
	[self addAutoModel:@"NV" ofAuto:autoId logo:logoId startYear:2011 endYear:0];
	[self addAutoModel:@"NV200" ofAuto:autoId logo:logoId startYear:2009 endYear:0];
	[self addAutoModel:@"NV400" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
	[self addAutoModel:@"NX" ofAuto:autoId logo:logoId startYear:1991 endYear:1996];
	[self addAutoModel:@"Otti" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"Pao" ofAuto:autoId logo:logoId startYear:1989 endYear:-1];
	[self addAutoModel:@"Patrol" ofAuto:autoId logo:logoId startYear:1950 endYear:0];
	[self addAutoModel:@"Safari" ofAuto:autoId logo:logoId startYear:1950 endYear:0];
	[self addAutoModel:@"Pathfinder" ofAuto:autoId logo:logoId startYear:1985 endYear:0];
	[self addAutoModel:@"Pino" ofAuto:autoId logo:logoId startYear:2007 endYear:2010];
	[self addAutoModel:@"Pintara" ofAuto:autoId logo:logoId startYear:1986 endYear:1992];
	[self addAutoModel:@"Pixo" ofAuto:autoId logo:logoId startYear:2009 endYear:0];
	[self addAutoModel:@"Platina" ofAuto:autoId logo:logoId startYear:2000 endYear:0];
	[self addAutoModel:@"Prairie" ofAuto:autoId logo:logoId startYear:1981 endYear:0];
	[self addAutoModel:@"Presea R10" ofAuto:autoId logo:logoId startYear:1990 endYear:1992];
	[self addAutoModel:@"Presea R11" ofAuto:autoId logo:logoId startYear:1994 endYear:1996];
	[self addAutoModel:@"President" ofAuto:autoId logo:logoId startYear:1965 endYear:2010];
	[self addAutoModel:@"Primera" ofAuto:autoId logo:logoId startYear:1990 endYear:2008];
	
	[self addAutoModel:@"Prince Royal" ofAuto:autoId logo:logoId startYear:1966 endYear:1967];
	[self addAutoModel:@"Pulsar" ofAuto:autoId logo:logoId startYear:1978 endYear:0];
	[self addAutoModel:@"Qashqai" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
	[self addAutoModel:@"Quest" ofAuto:autoId logo:logoId startYear:1993 endYear:0];
	[self addAutoModel:@"R380" ofAuto:autoId logo:logoId startYear:1968 endYear:-1];
	[self addAutoModel:@"R381" ofAuto:autoId logo:logoId startYear:1969 endYear:-1];
	[self addAutoModel:@"R382" ofAuto:autoId logo:logoId startYear:1970 endYear:-1];
	[self addAutoModel:@"R383" ofAuto:autoId logo:logoId startYear:1970 endYear:-1];
	[self addAutoModel:@"R88C" ofAuto:autoId logo:logoId startYear:1988 endYear:-1];
	[self addAutoModel:@"R89C" ofAuto:autoId logo:logoId startYear:1989 endYear:-1];
	[self addAutoModel:@"R90C" ofAuto:autoId logo:logoId startYear:1990 endYear:-1];
	[self addAutoModel:@"R91CP" ofAuto:autoId logo:logoId startYear:1991 endYear:-1];
	[self addAutoModel:@"R92CP" ofAuto:autoId logo:logoId startYear:1992 endYear:-1];
	[self addAutoModel:@"R390 GT1" ofAuto:autoId logo:logoId startYear:1997 endYear:1998];
	[self addAutoModel:@"R391" ofAuto:autoId logo:logoId startYear:1999 endYear:-1];
	[self addAutoModel:@"Rasheen" ofAuto:autoId logo:logoId startYear:1994 endYear:2000];
	[self addAutoModel:@"R'nessa" ofAuto:autoId logo:logoId startYear:1997 endYear:2001];
	[self addAutoModel:@"Rogue" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
	[self addAutoModel:@"Roox" ofAuto:autoId logo:logoId startYear:2009 endYear:0];
	[self addAutoModel:@"Saurus Jr." ofAuto:autoId logo:logoId startYear:1991 endYear:-1];
	
	[self addAutoModel:@"S-Cargo" ofAuto:autoId logo:logoId startYear:1989 endYear:1992];
	[self addAutoModel:@"Sentra" ofAuto:autoId logo:logoId startYear:1982 endYear:0];
	[self addAutoModel:@"Serena" ofAuto:autoId logo:logoId startYear:1991 endYear:0];
	[self addAutoModel:@"Silvia" ofAuto:autoId logo:logoId startYear:1965 endYear:2002];
	[self addAutoModel:@"180SX" ofAuto:autoId logo:logoId startYear:1965 endYear:2002];
	[self addAutoModel:@"200SX" ofAuto:autoId logo:logoId startYear:1965 endYear:2002];
	[self addAutoModel:@"240SX" ofAuto:autoId logo:logoId startYear:1965 endYear:2002];
	[self addAutoModel:@"Skyline" ofAuto:autoId logo:logoId startYear:1957 endYear:0];
	[self addAutoModel:@"Skyline GT-R" ofAuto:autoId logo:logoId startYear:1969 endYear:2002];
	[self addAutoModel:@"Stanza" ofAuto:autoId logo:logoId startYear:1977 endYear:1992];
	[self addAutoModel:@"Stanza Wagon" ofAuto:autoId logo:logoId startYear:1986 endYear:1988];
	[self addAutoModel:@"Violet" ofAuto:autoId logo:logoId startYear:1982 endYear:1986];
	[self addAutoModel:@"Stagea" ofAuto:autoId logo:logoId startYear:1996 endYear:2007];
	[self addAutoModel:@"Sunny" ofAuto:autoId logo:logoId startYear:1965 endYear:0];
	[self addAutoModel:@"Sunny B12" ofAuto:autoId logo:logoId startYear:1986 endYear:1991];
	[self addAutoModel:@"T12/T72" ofAuto:autoId logo:logoId startYear:1986 endYear:1990];
	[self addAutoModel:@"Teana" ofAuto:autoId logo:logoId startYear:2003 endYear:0];
	[self addAutoModel:@"Terrano" ofAuto:autoId logo:logoId startYear:1986 endYear:0];
	[self addAutoModel:@"Terrano II" ofAuto:autoId logo:logoId startYear:1993 endYear:2006];
	[self addAutoModel:@"Titan" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
	modelId = [self addAutoModel:@"Type" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
		[self addAutoSubmodel:@"Type 30" ofModel:modelId logo:logoId startYear:1941 endYear:-1];
		[self addAutoSubmodel:@"Type 50" ofModel:modelId logo:logoId startYear:1939 endYear:1941];
		[self addAutoSubmodel:@"Type 53" ofModel:modelId logo:logoId startYear:1941 endYear:-1];
		[self addAutoSubmodel:@"Type 70" ofModel:modelId logo:logoId startYear:1937 endYear:1943];
	}
	[self addAutoModel:@"Urvan" ofAuto:autoId logo:logoId startYear:1986 endYear:0];
	[self addAutoModel:@"Van C22" ofAuto:autoId logo:logoId startYear:1981 endYear:0];
	[self addAutoModel:@"Wingroad" ofAuto:autoId logo:logoId startYear:1994 endYear:2005];
	[self addAutoModel:@"Xterra" ofAuto:autoId logo:logoId startYear:2000 endYear:0];
	[self addAutoModel:@"X-Trail" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
	[self addAutoModel:@"Terranaut" ofAuto:autoId logo:logoId startYear:2006 endYear:0];
	[self addAutoModel:@"Versa" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
	[self addAutoModel:@"Winner" ofAuto:autoId logo:logoId startYear:1995 endYear:2007];
    
	modelId = [self addAutoModel:@"Trucks" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
		[self addAutoSubmodel:@"80 Truck" ofModel:modelId logo:logoId startYear:1937 endYear:1941];
		[self addAutoSubmodel:@"180 Truck" ofModel:modelId logo:logoId startYear:1941 endYear:1952];
		[self addAutoSubmodel:@"380 Truck" ofModel:modelId logo:logoId startYear:1952 endYear:1953];
		[self addAutoSubmodel:@"480 Truck" ofModel:modelId logo:logoId startYear:1953 endYear:1955];
		[self addAutoSubmodel:@"482 Truck" ofModel:modelId logo:logoId startYear:1955 endYear:-1];
		[self addAutoSubmodel:@"580 Truck" ofModel:modelId logo:logoId startYear:1955 endYear:1958];
		[self addAutoSubmodel:@"582 Truck" ofModel:modelId logo:logoId startYear:1958 endYear:1959];
		[self addAutoSubmodel:@"680 Truck" ofModel:modelId logo:logoId startYear:1959 endYear:1968];
		[self addAutoSubmodel:@"681 Truck" ofModel:modelId logo:logoId startYear:1968 endYear:1969];
		[self addAutoSubmodel:@"Hardbody Truck" ofModel:modelId logo:logoId startYear:1986 endYear:1997];
	}
	
	modelId = [self addAutoModel:@"Buses" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
		[self addAutoSubmodel:@"190 Bus" ofModel:modelId logo:logoId startYear:1941 endYear:1949];
		[self addAutoSubmodel:@"490 Bus" ofModel:modelId logo:logoId startYear:1953 endYear:1955];
		[self addAutoSubmodel:@"492 Bus" ofModel:modelId logo:logoId startYear:1955 endYear:-1];
		[self addAutoSubmodel:@"590 Bus" ofModel:modelId logo:logoId startYear:1955 endYear:1958];
		[self addAutoSubmodel:@"592 Bus" ofModel:modelId logo:logoId startYear:1958 endYear:1959];
	}
#pragma mark |---- Toyota
    logoId = [self addLogo:@"toyota_256.png"];
    autoId = [self addAuto:@"TOYOTA" country:countryId logo:logoId independentId:TOYOTA];
    modelId = [self addAutoModel:@"Old cars" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
		[self addAutoSubmodel:@"1000" ofModel:modelId logo:logoId startYear:1969 endYear:1981];
		[self addAutoSubmodel:@"2000GT" ofModel:modelId logo:logoId startYear:1967 endYear:1970];
		[self addAutoSubmodel:@"AA" ofModel:modelId logo:logoId startYear:1936 endYear:1943];
		[self addAutoSubmodel:@"AB" ofModel:modelId logo:logoId startYear:1936 endYear:1943];
		[self addAutoSubmodel:@"AC" ofModel:modelId logo:logoId startYear:1943 endYear:1947];
		[self addAutoSubmodel:@"AE" ofModel:modelId logo:logoId startYear:1941 endYear:1943];
		[self addAutoSubmodel:@"BA" ofModel:modelId logo:logoId startYear:1940 endYear:-1];
		[self addAutoSubmodel:@"Briska" ofModel:modelId logo:logoId startYear:1967 endYear:1968];
		[self addAutoSubmodel:@"BX" ofModel:modelId logo:logoId startYear:1951 endYear:-1];
		[self addAutoSubmodel:@"BJ" ofModel:modelId logo:logoId startYear:1951 endYear:-1];
		[self addAutoSubmodel:@"Altezza" ofModel:modelId logo:logoId startYear:1998 endYear:2005];
		[self addAutoSubmodel:@"Aristo" ofModel:modelId logo:logoId startYear:1991 endYear:2005];
		[self addAutoSubmodel:@"G1" ofModel:modelId logo:logoId startYear:1935 endYear:1936];
		[self addAutoSubmodel:@"GA" ofModel:modelId logo:logoId startYear:1936 endYear:1938];
		[self addAutoSubmodel:@"GB" ofModel:modelId logo:logoId startYear:1938 endYear:1942];
		[self addAutoSubmodel:@"KB" ofModel:modelId logo:logoId startYear:1942 endYear:1944];
		[self addAutoSubmodel:@"KC" ofModel:modelId logo:logoId startYear:1943 endYear:-1];
		[self addAutoSubmodel:@"KCY" ofModel:modelId logo:logoId startYear:1943 endYear:1944];
		[self addAutoSubmodel:@"Patrol" ofModel:modelId logo:logoId startYear:1955 endYear:-1];
		
		[self addAutoSubmodel:@"Publica" ofModel:modelId logo:logoId startYear:1961 endYear:1978];
		[self addAutoSubmodel:@"RH" ofModel:modelId logo:logoId startYear:1953 endYear:1955];
		[self addAutoSubmodel:@"RK" ofModel:modelId logo:logoId startYear:1953 endYear:-1];
		[self addAutoSubmodel:@"RR" ofModel:modelId logo:logoId startYear:1955 endYear:1956];
		[self addAutoSubmodel:@"RS" ofModel:modelId logo:logoId startYear:1955 endYear:1962];
		[self addAutoSubmodel:@"SA" ofModel:modelId logo:logoId startYear:1947 endYear:1952];
		[self addAutoSubmodel:@"SB" ofModel:modelId logo:logoId startYear:1947 endYear:1952];
		[self addAutoSubmodel:@"SD" ofModel:modelId logo:logoId startYear:1949 endYear:1951];
		[self addAutoSubmodel:@"SF" ofModel:modelId logo:logoId startYear:1951 endYear:1953];
		[self addAutoSubmodel:@"SG" ofModel:modelId logo:logoId startYear:1952 endYear:-1];
		[self addAutoSubmodel:@"SKB" ofModel:modelId logo:logoId startYear:1954 endYear:-1];
		[self addAutoSubmodel:@"Massy Dyna" ofModel:modelId logo:logoId startYear:1969 endYear:1977];
		[self addAutoSubmodel:@"Master" ofModel:modelId logo:logoId startYear:1955 endYear:1956];
		[self addAutoSubmodel:@"Masterline" ofModel:modelId logo:logoId startYear:1962 endYear:1967];
		[self addAutoSubmodel:@"Sports 800" ofModel:modelId logo:logoId startYear:1965 endYear:1969];
		[self addAutoSubmodel:@"Trailer T10" ofModel:modelId logo:logoId startYear:1960 endYear:-1];
		[self addAutoSubmodel:@"Super" ofModel:modelId logo:logoId startYear:1953 endYear:1955];
    }
	[self addAutoModel:@"86" ofAuto:autoId logo:logoId startYear:2012 endYear:0];
	[self addAutoModel:@"4Runner" ofAuto:autoId logo:logoId startYear:1984 endYear:0];
	[self addAutoModel:@"Allion" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
	[self addAutoModel:@"Alphard" ofAuto:autoId logo:logoId startYear:2002 endYear:0];
	[self addAutoModel:@"Aurion" ofAuto:autoId logo:logoId startYear:2006 endYear:0];
	[self addAutoModel:@"Auris" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
	[self addAutoModel:@"Avanza" ofAuto:autoId logo:logoId startYear:2003 endYear:0];
	[self addAutoModel:@"Avensis" ofAuto:autoId logo:logoId startYear:1998 endYear:0];
	[self addAutoModel:@"Aygo" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"bB" ofAuto:autoId logo:logoId startYear:2000 endYear:0];
	[self addAutoModel:@"Belta" ofAuto:autoId logo:logoId startYear:2006 endYear:0];
	[self addAutoModel:@"Cami" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Camry" ofAuto:autoId logo:logoId startYear:1983 endYear:0];
	[self addAutoModel:@"Carri" ofAuto:autoId logo:logoId startYear:1996 endYear:0];
	[self addAutoModel:@"Century" ofAuto:autoId logo:logoId startYear:1967 endYear:0];
	[self addAutoModel:@"Coaster" ofAuto:autoId logo:logoId startYear:1969 endYear:0];
	[self addAutoModel:@"Condor" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Comfort" ofAuto:autoId logo:logoId startYear:1988 endYear:0];
	modelId = [self addAutoModel:@"Corolla" ofAuto:autoId logo:logoId startYear:1966 endYear:0];
    {
		[self addAutoSubmodel:@"Axio" ofModel:modelId logo:logoId startYear:2006 endYear:0];
		[self addAutoSubmodel:@"Fielder" ofModel:modelId logo:logoId startYear:2000 endYear:0];
		[self addAutoSubmodel:@"Rumion" ofModel:modelId logo:logoId startYear:2007 endYear:0];
    }
	[self addAutoModel:@"Sprinter" ofAuto:autoId logo:logoId startYear:1966 endYear:0];
	[self addAutoModel:@"Crown" ofAuto:autoId logo:logoId startYear:1955 endYear:0];
	[self addAutoModel:@"Crown Majesta" ofAuto:autoId logo:logoId startYear:1991 endYear:0];
	[self addAutoModel:@"Dyna" ofAuto:autoId logo:logoId startYear:1959 endYear:0];
	[self addAutoModel:@"Estima" ofAuto:autoId logo:logoId startYear:1990 endYear:0];
	[self addAutoModel:@"Etios" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
	[self addAutoModel:@"FJ Cruiser" ofAuto:autoId logo:logoId startYear:2006 endYear:0];
	[self addAutoModel:@"Fortuner" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"Granvia" ofAuto:autoId logo:logoId startYear:1995 endYear:0];
	[self addAutoModel:@"Heavy Duty Truck" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Highlander" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
	[self addAutoModel:@"Hilux" ofAuto:autoId logo:logoId startYear:1968 endYear:0];
	[self addAutoModel:@"Hilux Surf" ofAuto:autoId logo:logoId startYear:1984 endYear:0];
	[self addAutoModel:@"HiClass" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Hiace" ofAuto:autoId logo:logoId startYear:1967 endYear:0];
	[self addAutoModel:@"Innova" ofAuto:autoId logo:logoId startYear:2003 endYear:0];
	[self addAutoModel:@"iQ" ofAuto:autoId logo:logoId startYear:2008 endYear:0];
	
	[self addAutoModel:@"Isis" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
	[self addAutoModel:@"ist" ofAuto:autoId logo:logoId startYear:2002 endYear:0];
	[self addAutoModel:@"Kijang" ofAuto:autoId logo:logoId startYear:1977 endYear:0];
	[self addAutoModel:@"Kingdom" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Kluger" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
	modelId = [self addAutoModel:@"Land Cruiser" ofAuto:autoId logo:logoId startYear:1954 endYear:0];
    {
		[self addAutoSubmodel:@"Prado" ofModel:modelId logo:logoId startYear:1984 endYear:0];
	}
	[self addAutoModel:@"LiteAce" ofAuto:autoId logo:logoId startYear:1970 endYear:0];
	[self addAutoModel:@"Mark X" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
	[self addAutoModel:@"Mark X ZiO" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
	[self addAutoModel:@"Matrix" ofAuto:autoId logo:logoId startYear:2003 endYear:0];
	[self addAutoModel:@"MiniAce" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Nadia" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Noah" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
	[self addAutoModel:@"Passo" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
	[self addAutoModel:@"Picnic" ofAuto:autoId logo:logoId startYear:1997 endYear:0];
	[self addAutoModel:@"Porte" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
	[self addAutoModel:@"Premio" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
	[self addAutoModel:@"Prius" ofAuto:autoId logo:logoId startYear:1997 endYear:0];
	[self addAutoModel:@"Probox" ofAuto:autoId logo:logoId startYear:2002 endYear:0];
	
	[self addAutoModel:@"Qualis" ofAuto:autoId logo:logoId startYear:1977 endYear:0];
	[self addAutoModel:@"Ractis" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"Raum" ofAuto:autoId logo:logoId startYear:1997 endYear:0];
	[self addAutoModel:@"RAV4" ofAuto:autoId logo:logoId startYear:1994 endYear:0];
	[self addAutoModel:@"Reiz" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
	[self addAutoModel:@"Rush" ofAuto:autoId logo:logoId startYear:2006 endYear:0];
	[self addAutoModel:@"Scepter" ofAuto:autoId logo:logoId startYear:1983 endYear:0];
	[self addAutoModel:@"Sequoia" ofAuto:autoId logo:logoId startYear:2000 endYear:0];
	[self addAutoModel:@"Sienna" ofAuto:autoId logo:logoId startYear:1998 endYear:0];
	[self addAutoModel:@"Sienta" ofAuto:autoId logo:logoId startYear:2003 endYear:0];
	[self addAutoModel:@"Sofia" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Stallion" ofAuto:autoId logo:logoId startYear:1977 endYear:0];
	[self addAutoModel:@"Succeed" ofAuto:autoId logo:logoId startYear:2002 endYear:0];
	[self addAutoModel:@"Tacoma" ofAuto:autoId logo:logoId startYear:1995 endYear:0];
	[self addAutoModel:@"Tamaraw FX" ofAuto:autoId logo:logoId startYear:1977 endYear:0];
	[self addAutoModel:@"Tarago" ofAuto:autoId logo:logoId startYear:1983 endYear:0];
	[self addAutoModel:@"Tiara" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"TownAce" ofAuto:autoId logo:logoId startYear:1983 endYear:0];
	[self addAutoModel:@"ToyoAce" ofAuto:autoId logo:logoId startYear:1959 endYear:0];
	[self addAutoModel:@"Tundra" ofAuto:autoId logo:logoId startYear:1999 endYear:0];
	
	[self addAutoModel:@"Urban Cruiser" ofAuto:autoId logo:logoId startYear:2009 endYear:0];
	[self addAutoModel:@"Vanguard" ofAuto:autoId logo:logoId startYear:2008 endYear:0];
	[self addAutoModel:@"Venture" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Venza" ofAuto:autoId logo:logoId startYear:2008 endYear:0];
	[self addAutoModel:@"Verso" ofAuto:autoId logo:logoId startYear:2009 endYear:0];
	[self addAutoModel:@"Vienta" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Vios" ofAuto:autoId logo:logoId startYear:2003 endYear:0];
	[self addAutoModel:@"Vitz" ofAuto:autoId logo:logoId startYear:1999 endYear:0];
	[self addAutoModel:@"Platz" ofAuto:autoId logo:logoId startYear:1999 endYear:0];
	[self addAutoModel:@"Yaris" ofAuto:autoId logo:logoId startYear:1999 endYear:0];
	[self addAutoModel:@"Echo" ofAuto:autoId logo:logoId startYear:1999 endYear:0];
	[self addAutoModel:@"Voxy" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
	[self addAutoModel:@"WISH" ofAuto:autoId logo:logoId startYear:2003 endYear:0];
	[self addAutoModel:@"Yaris" ofAuto:autoId logo:logoId startYear:1999 endYear:0];
	[self addAutoModel:@"Zelas" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
	
	modelId = [self addAutoModel:@"Past production" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
		[self addAutoSubmodel:@"Brevis" ofModel:modelId logo:logoId startYear:2001 endYear:2007];
		[self addAutoSubmodel:@"Caldina" ofModel:modelId logo:logoId startYear:1992 endYear:2007];
		[self addAutoSubmodel:@"Camry Solara" ofModel:modelId logo:logoId startYear:1999 endYear:2008];
		[self addAutoSubmodel:@"Carina" ofModel:modelId logo:logoId startYear:1970 endYear:2000];
		[self addAutoSubmodel:@"Carina II" ofModel:modelId logo:logoId startYear:1987 endYear:1992];
		[self addAutoSubmodel:@"Carina E" ofModel:modelId logo:logoId startYear:1992 endYear:1998];
		[self addAutoSubmodel:@"Carina ED" ofModel:modelId logo:logoId startYear:1985 endYear:1998];
		[self addAutoSubmodel:@"Cavalier" ofModel:modelId logo:logoId startYear:1995 endYear:2000];
		[self addAutoSubmodel:@"Celica" ofModel:modelId logo:logoId startYear:1970 endYear:2006];
		[self addAutoSubmodel:@"Celsior" ofModel:modelId logo:logoId startYear:1989 endYear:2005];
		[self addAutoSubmodel:@"Chaser" ofModel:modelId logo:logoId startYear:1977 endYear:2000];
		[self addAutoSubmodel:@"Classic" ofModel:modelId logo:logoId startYear:1996 endYear:-1];
		[self addAutoSubmodel:@"Corsa" ofModel:modelId logo:logoId startYear:1978 endYear:1999];
		[self addAutoSubmodel:@"Corolla Spacio" ofModel:modelId logo:logoId startYear:1997 endYear:2005];
		[self addAutoSubmodel:@"Corolla Verso" ofModel:modelId logo:logoId startYear:1997 endYear:2009];
		[self addAutoSubmodel:@"Corona" ofModel:modelId logo:logoId startYear:1957 endYear:2000];
		[self addAutoSubmodel:@"Corona EXiV" ofModel:modelId logo:logoId startYear:1989 endYear:1998];
		[self addAutoSubmodel:@"Corona Mark II" ofModel:modelId logo:logoId startYear:1968 endYear:2004];
		[self addAutoSubmodel:@"Cressida" ofModel:modelId logo:logoId startYear:1973 endYear:1992];
		[self addAutoSubmodel:@"Cresta" ofModel:modelId logo:logoId startYear:1980 endYear:2001];
		
		[self addAutoSubmodel:@"Curren" ofModel:modelId logo:logoId startYear:1994 endYear:1998];
		[self addAutoSubmodel:@"Cynos" ofModel:modelId logo:logoId startYear:1991 endYear:1999];
		[self addAutoSubmodel:@"Duet" ofModel:modelId logo:logoId startYear:1997 endYear:2004];
		[self addAutoSubmodel:@"Echo" ofModel:modelId logo:logoId startYear:2000 endYear:2005];
		[self addAutoSubmodel:@"eCom" ofModel:modelId logo:logoId startYear:1998 endYear:-1];
		[self addAutoSubmodel:@"Fun Cargo" ofModel:modelId logo:logoId startYear:2000 endYear:2004];
		[self addAutoSubmodel:@"Gaia" ofModel:modelId logo:logoId startYear:1998 endYear:2004];
		[self addAutoSubmodel:@"Grand Hiace" ofModel:modelId logo:logoId startYear:1999 endYear:2002];
		[self addAutoSubmodel:@"Harrier" ofModel:modelId logo:logoId startYear:1998 endYear:2005];
		[self addAutoSubmodel:@"Ipsum" ofModel:modelId logo:logoId startYear:1996 endYear:2001];
		[self addAutoSubmodel:@"Lexcen" ofModel:modelId logo:logoId startYear:1989 endYear:1992];
		[self addAutoSubmodel:@"Mark II Blit" ofModel:modelId logo:logoId startYear:2002 endYear:2007];
		[self addAutoSubmodel:@"Mark II" ofModel:modelId logo:logoId startYear:1968 endYear:2004];
		[self addAutoSubmodel:@"Mega Cruiser" ofModel:modelId logo:logoId startYear:1996 endYear:2002];
		[self addAutoSubmodel:@"Model F" ofModel:modelId logo:logoId startYear:1984 endYear:1989];
		[self addAutoSubmodel:@"MR2/MR-S" ofModel:modelId logo:logoId startYear:1984 endYear:2005];
		[self addAutoSubmodel:@"Opa" ofModel:modelId logo:logoId startYear:2000 endYear:2005];
		[self addAutoSubmodel:@"Origin" ofModel:modelId logo:logoId startYear:2000 endYear:-1];
		[self addAutoSubmodel:@"Paseo" ofModel:modelId logo:logoId startYear:1991 endYear:1999];
		[self addAutoSubmodel:@"Pickup" ofModel:modelId logo:logoId startYear:1968 endYear:1995];
		
		[self addAutoSubmodel:@"Platz" ofModel:modelId logo:logoId startYear:1999 endYear:2005];
		[self addAutoSubmodel:@"Previa" ofModel:modelId logo:logoId startYear:1991 endYear:1997];
		[self addAutoSubmodel:@"Progres" ofModel:modelId logo:logoId startYear:1998 endYear:2007];
		[self addAutoSubmodel:@"Pronard" ofModel:modelId logo:logoId startYear:2002 endYear:2004];
		[self addAutoSubmodel:@"Avalon" ofModel:modelId logo:logoId startYear:2002 endYear:2004];
		[self addAutoSubmodel:@"RAV4 EV" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
		[self addAutoSubmodel:@"Regius" ofModel:modelId logo:logoId startYear:1997 endYear:2002];
		[self addAutoSubmodel:@"Revo" ofModel:modelId logo:logoId startYear:1998 endYear:2004];
		[self addAutoSubmodel:@"Sera" ofModel:modelId logo:logoId startYear:1990 endYear:1995];
		[self addAutoSubmodel:@"Soarer" ofModel:modelId logo:logoId startYear:1981 endYear:2005];
		[self addAutoSubmodel:@"Space Cruiser" ofModel:modelId logo:logoId startYear:1984 endYear:1989];
		[self addAutoSubmodel:@"Sprinter Trueno" ofModel:modelId logo:logoId startYear:1983 endYear:1987];
		[self addAutoSubmodel:@"Sprinter Marino" ofModel:modelId logo:logoId startYear:1991 endYear:1998];
		[self addAutoSubmodel:@"Starlet" ofModel:modelId logo:logoId startYear:1973 endYear:1999];
		[self addAutoSubmodel:@"Stout" ofModel:modelId logo:logoId startYear:1962 endYear:1985];
		[self addAutoSubmodel:@"Supra" ofModel:modelId logo:logoId startYear:1978 endYear:2002];
		[self addAutoSubmodel:@"T-18" ofModel:modelId logo:logoId startYear:1979 endYear:1983];
		[self addAutoSubmodel:@"T100" ofModel:modelId logo:logoId startYear:1993 endYear:1998];
		[self addAutoSubmodel:@"Tazz" ofModel:modelId logo:logoId startYear:1996 endYear:2006];
		[self addAutoSubmodel:@"Tercel" ofModel:modelId logo:logoId startYear:1978 endYear:1999];
        
		[self addAutoSubmodel:@"Van" ofModel:modelId logo:logoId startYear:1984 endYear:1989];
		[self addAutoSubmodel:@"Verossa" ofModel:modelId logo:logoId startYear:2001 endYear:2003];
		[self addAutoSubmodel:@"Vista" ofModel:modelId logo:logoId startYear:1982 endYear:2003];
		[self addAutoSubmodel:@"VM180 Zagato" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"Voltz" ofModel:modelId logo:logoId startYear:2002 endYear:2004];
		[self addAutoSubmodel:@"WiLL" ofModel:modelId logo:logoId startYear:2001 endYear:2005];
		[self addAutoSubmodel:@"Windom" ofModel:modelId logo:logoId startYear:1989 endYear:2007];
		[self addAutoSubmodel:@"Yaris Verso" ofModel:modelId logo:logoId startYear:2000 endYear:2004];
    }
	
	modelId = [self addAutoModel:@"Concepts" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
		[self addAutoSubmodel:@"1/X" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"4500GT" ofModel:modelId logo:logoId startYear:1989 endYear:-1];
		[self addAutoSubmodel:@"A-BAT" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"A1" ofModel:modelId logo:logoId startYear:1935 endYear:-1];
		[self addAutoSubmodel:@"Airport Limousine" ofModel:modelId logo:logoId startYear:1961 endYear:-1];
		[self addAutoSubmodel:@"Airport Limousine" ofModel:modelId logo:logoId startYear:1977 endYear:-1];
		[self addAutoSubmodel:@"Alessandro Volta" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
		[self addAutoSubmodel:@"ASV" ofModel:modelId logo:logoId startYear:1995 endYear:-1];
		[self addAutoSubmodel:@"ASV-2" ofModel:modelId logo:logoId startYear:2000 endYear:-1];
		[self addAutoSubmodel:@"ASV-3" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
		[self addAutoSubmodel:@"Aurion Sports Concept" ofModel:modelId logo:logoId startYear:2006 endYear:-1];
		[self addAutoSubmodel:@"Avalon (Concept)" ofModel:modelId logo:logoId startYear:1991 endYear:-1];
		[self addAutoSubmodel:@"AXV" ofModel:modelId logo:logoId startYear:1985 endYear:-1];
		[self addAutoSubmodel:@"AXV-II" ofModel:modelId logo:logoId startYear:1987 endYear:-1];
		[self addAutoSubmodel:@"AXV-III" ofModel:modelId logo:logoId startYear:1991 endYear:-1];
		[self addAutoSubmodel:@"AXV-IV" ofModel:modelId logo:logoId startYear:1991 endYear:-1];
		[self addAutoSubmodel:@"AXV-V" ofModel:modelId logo:logoId startYear:1993 endYear:-1];
		[self addAutoSubmodel:@"Aygo Crazy" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"CAL-1" ofModel:modelId logo:logoId startYear:1977 endYear:-1];
		[self addAutoSubmodel:@"Camatte" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
		
		[self addAutoSubmodel:@"Camry CNG Hybrid" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"Camry TS-01" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"ccX" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
		[self addAutoSubmodel:@"Celica Cruising Deck" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"Celica Ultimate" ofModel:modelId logo:logoId startYear:2000 endYear:-1];
		[self addAutoSubmodel:@"Celica XYR" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"Century GT45" ofModel:modelId logo:logoId startYear:1971 endYear:1975];
		[self addAutoSubmodel:@"Commuter" ofModel:modelId logo:logoId startYear:1970 endYear:-1];
		[self addAutoSubmodel:@"Corona 1500S Convertible" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		[self addAutoSubmodel:@"Corona 1900S Sporty Sedan" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		[self addAutoSubmodel:@"Corona Sports Coupe" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		[self addAutoSubmodel:@"Crown Convertible" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		[self addAutoSubmodel:@"Crown Majesta EV" ofModel:modelId logo:logoId startYear:1993 endYear:-1];
		[self addAutoSubmodel:@"CQ-1" ofModel:modelId logo:logoId startYear:1983 endYear:-1];
		[self addAutoSubmodel:@"CS&S" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"CX-80" ofModel:modelId logo:logoId startYear:1979 endYear:-1];
		[self addAutoSubmodel:@"D-4D 180 Clean Power" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
		[self addAutoSubmodel:@"Dear Qin" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
		[self addAutoSubmodel:@"diji" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
		[self addAutoSubmodel:@"DMT" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		
		[self addAutoSubmodel:@"Dream Car" ofModel:modelId logo:logoId startYear:1964 endYear:-1];
		[self addAutoSubmodel:@"Dream Car Model" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		[self addAutoSubmodel:@"DV-1" ofModel:modelId logo:logoId startYear:1981 endYear:-1];
		[self addAutoSubmodel:@"EA" ofModel:modelId logo:logoId startYear:1938 endYear:-1];
		[self addAutoSubmodel:@"EB" ofModel:modelId logo:logoId startYear:1938 endYear:-1];
		[self addAutoSubmodel:@"Electronics Car" ofModel:modelId logo:logoId startYear:1970 endYear:-1];
		[self addAutoSubmodel:@"Endo" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"ES3" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"ESV-2" ofModel:modelId logo:logoId startYear:1972 endYear:-1];
		[self addAutoSubmodel:@"ESV" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
		[self addAutoSubmodel:@"EV-30" ofModel:modelId logo:logoId startYear:1987 endYear:-1];
		[self addAutoSubmodel:@"EV Prototype" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"EX-I" ofModel:modelId logo:logoId startYear:1969 endYear:-1];
		[self addAutoSubmodel:@"EX-II" ofModel:modelId logo:logoId startYear:1969 endYear:-1];
		[self addAutoSubmodel:@"EX-III" ofModel:modelId logo:logoId startYear:1969 endYear:-1];
		[self addAutoSubmodel:@"EX-7" ofModel:modelId logo:logoId startYear:1970 endYear:-1];
		[self addAutoSubmodel:@"EX-11" ofModel:modelId logo:logoId startYear:1981 endYear:-1];
		[self addAutoSubmodel:@"F101" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
		[self addAutoSubmodel:@"F110" ofModel:modelId logo:logoId startYear:1977 endYear:-1];
		[self addAutoSubmodel:@"F120" ofModel:modelId logo:logoId startYear:1981 endYear:-1];
		
		[self addAutoSubmodel:@"F3R" ofModel:modelId logo:logoId startYear:2006 endYear:-1];
		[self addAutoSubmodel:@"Family Wagon" ofModel:modelId logo:logoId startYear:1979 endYear:-1];
		[self addAutoSubmodel:@"FCHV" ofModel:modelId logo:logoId startYear:1997 endYear:-1];
		[self addAutoSubmodel:@"FCHV-1" ofModel:modelId logo:logoId startYear:1997 endYear:-1];
		[self addAutoSubmodel:@"FCHV-2" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"FCHV-3" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"FCHV-4" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
		[self addAutoSubmodel:@"FCHV-adv" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"FCV-R" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"FCX-80" ofModel:modelId logo:logoId startYear:1979 endYear:-1];
		[self addAutoSubmodel:@"Fine-N" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Fine-S" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Fine-T" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"Fine-X" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"FLV" ofModel:modelId logo:logoId startYear:1995 endYear:-1];
		[self addAutoSubmodel:@"FSC" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"FT-Bh" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
		[self addAutoSubmodel:@"FT-CH" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"FT-EV" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
		[self addAutoSubmodel:@"FT-EV II" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
		
		[self addAutoSubmodel:@"FT-EV III" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"FT-HS" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"FT-MV" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"FT-SX" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"FT-86" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
		[self addAutoSubmodel:@"FT-86 G Sports" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"FT-86 II" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"FTX" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
		[self addAutoSubmodel:@"Fun Runner" ofModel:modelId logo:logoId startYear:1991 endYear:-1];
		[self addAutoSubmodel:@"Fun Runner II" ofModel:modelId logo:logoId startYear:1995 endYear:-1];
		[self addAutoSubmodel:@"Funcargo" ofModel:modelId logo:logoId startYear:1997 endYear:-1];
		[self addAutoSubmodel:@"Funcoupe" ofModel:modelId logo:logoId startYear:1997 endYear:-1];
		[self addAutoSubmodel:@"Funtime" ofModel:modelId logo:logoId startYear:1997 endYear:-1];
		[self addAutoSubmodel:@"Fun-vii" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"Furia" ofModel:modelId logo:logoId startYear:2013 endYear:-1];
		[self addAutoSubmodel:@"FX-1" ofModel:modelId logo:logoId startYear:1983 endYear:-1];
		[self addAutoSubmodel:@"FXS" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"FXV" ofModel:modelId logo:logoId startYear:1985 endYear:-1];
		[self addAutoSubmodel:@"FXV-II" ofModel:modelId logo:logoId startYear:1987 endYear:-1];
		[self addAutoSubmodel:@"GRMN Sports Hybrid" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		
		[self addAutoSubmodel:@"GRMN Sports Hybrid II" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"GTV" ofModel:modelId logo:logoId startYear:1987 endYear:-1];
		[self addAutoSubmodel:@"HC-CV" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
		[self addAutoSubmodel:@"Hi-CT" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"HV-M4" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"Hybrid Electric Bus" ofModel:modelId logo:logoId startYear:1995 endYear:-1];
		[self addAutoSubmodel:@"Hybrid X" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"i-foot" ofModel:modelId logo:logoId startYear:0 endYear:-1];
		[self addAutoSubmodel:@"i-real" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"i-Road" ofModel:modelId logo:logoId startYear:2013 endYear:-1];
		[self addAutoSubmodel:@"i-swing" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"i-unit" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"iiMo" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
		[self addAutoSubmodel:@"Scion iQ Concept" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
		[self addAutoSubmodel:@"iQ Sport" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
		[self addAutoSubmodel:@"Land Cruiser FJ45Concept" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Marinetta" ofModel:modelId logo:logoId startYear:1971 endYear:-1];
		[self addAutoSubmodel:@"Marinetta 10" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
		[self addAutoSubmodel:@"Marine Cruiser" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
		[self addAutoSubmodel:@"Matrix Sport" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
		[self addAutoSubmodel:@"ME.WE" ofModel:modelId logo:logoId startYear:2013 endYear:-1];
		
		[self addAutoSubmodel:@"Moguls" ofModel:modelId logo:logoId startYear:1995 endYear:-1];
		[self addAutoSubmodel:@"Motor Triathlon Race Car" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
		[self addAutoSubmodel:@"MP-1" ofModel:modelId logo:logoId startYear:1975 endYear:-1];
		[self addAutoSubmodel:@"MR2 Group B" ofModel:modelId logo:logoId startYear:1987 endYear:-1];
		[self addAutoSubmodel:@"MR2 Street Affair" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
		[self addAutoSubmodel:@"MRJ" ofModel:modelId logo:logoId startYear:1995 endYear:-1];
		[self addAutoSubmodel:@"MR-S" ofModel:modelId logo:logoId startYear:1997 endYear:-1];
		[self addAutoSubmodel:@"NCSV" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"NLSV" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"NS4" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
		[self addAutoSubmodel:@"Open Deck" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"PM" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Pod" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"Prius" ofModel:modelId logo:logoId startYear:1995 endYear:-1];
		[self addAutoSubmodel:@"Prius c" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"Prius Custom Plus" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"Prius Plug-in Hybrid" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
		[self addAutoSubmodel:@"Prius PHV" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"Prius+" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"Project Go" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
		
		[self addAutoSubmodel:@"Publica Sports" ofModel:modelId logo:logoId startYear:1962 endYear:-1];
		[self addAutoSubmodel:@"Retro Cruiser" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"RiN" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"RSC" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"Rugged Youth Utility" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"RV-1" ofModel:modelId logo:logoId startYear:1971 endYear:-1];
		[self addAutoSubmodel:@"RV-2" ofModel:modelId logo:logoId startYear:1972 endYear:-1];
		[self addAutoSubmodel:@"RV-5" ofModel:modelId logo:logoId startYear:1981 endYear:-1];
		[self addAutoSubmodel:@"Soarer Aero Cabin" ofModel:modelId logo:logoId startYear:1987 endYear:-1];
		[self addAutoSubmodel:@"Solara Concept" ofModel:modelId logo:logoId startYear:1998 endYear:-1];
		[self addAutoSubmodel:@"Sportivo Coupe" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
		[self addAutoSubmodel:@"Sports" ofModel:modelId logo:logoId startYear:1957 endYear:-1];
		[self addAutoSubmodel:@"Sports 800 Gas Turbine Hybrid" ofModel:modelId logo:logoId startYear:1979 endYear:-1];
		[self addAutoSubmodel:@"Sports X" ofModel:modelId logo:logoId startYear:1961 endYear:-1];
		[self addAutoSubmodel:@"Sports EV" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"Sports EV Twin" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"SC" ofModel:modelId logo:logoId startYear:1948 endYear:-1];
		[self addAutoSubmodel:@"SU-HV1" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"SV-1" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
		[self addAutoSubmodel:@"SV-2" ofModel:modelId logo:logoId startYear:1981 endYear:-1];
		
		[self addAutoSubmodel:@"SV-3" ofModel:modelId logo:logoId startYear:1983 endYear:-1];
		[self addAutoSubmodel:@"TAC3" ofModel:modelId logo:logoId startYear:1983 endYear:-1];
		[self addAutoSubmodel:@"TES ERA EV" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
		[self addAutoSubmodel:@"Town Spider System" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
		[self addAutoSubmodel:@"TownAce Van EV" ofModel:modelId logo:logoId startYear:1991 endYear:-1];
		[self addAutoSubmodel:@"T Sports" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"UUV" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
		[self addAutoSubmodel:@"VM180" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"Winglet" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@" X" ofModel:modelId logo:logoId startYear:1961 endYear:-1];
		[self addAutoSubmodel:@"X-Runner" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Yaris Cabrio" ofModel:modelId logo:logoId startYear:2000 endYear:-1];
		[self addAutoSubmodel:@"Yun Dong Shuang Qing" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
    }
    
#pragma mark |---- Subaru
    logoId = [self addLogo:@"subaru_256.png"];
    autoId = [self addAuto:@"Subaru" country:countryId logo:logoId independentId:SUBARU];
    [self addAutoModel:@"1000" ofAuto:autoId logo:logoId startYear:1966 endYear:1969];
	[self addAutoModel:@"1500" ofAuto:autoId logo:logoId startYear:1954 endYear:-1];
	[self addAutoModel:@"360" ofAuto:autoId logo:logoId startYear:1958 endYear:1971];
	[self addAutoModel:@"450" ofAuto:autoId logo:logoId startYear:1960 endYear:1965];
	
	modelId = [self addAutoModel:@"Alcyone" ofAuto:autoId logo:logoId startYear:1985 endYear:1991];
	{
		[self addAutoSubmodel:@"SVX" ofModel:modelId logo:logoId startYear:1991 endYear:1996];
	}
	
	[self addAutoModel:@"B9 Scrambler" ofAuto:autoId logo:logoId startYear:2003 endYear:-1];
	[self addAutoModel:@"B9sc" ofAuto:autoId logo:logoId startYear:2003 endYear:-1];
	[self addAutoModel:@"Baja" ofAuto:autoId logo:logoId startYear:2002 endYear:2006];
	[self addAutoModel:@"BRAT" ofAuto:autoId logo:logoId startYear:1978 endYear:1993];
	[self addAutoModel:@"Brumby" ofAuto:autoId logo:logoId startYear:1978 endYear:1993];
	
	modelId = [self addAutoModel:@"BRZ" ofAuto:autoId logo:logoId startYear:2012 endYear:0];
	{
		[self addAutoSubmodel:@"Concept STI" ofModel:modelId logo:logoId startYear:2012 endYear:0];
	}
	
	[self addAutoModel:@"Dex" ofAuto:autoId logo:logoId startYear:2008 endYear:2010];
	[self addAutoModel:@"Elaion" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
	[self addAutoModel:@"Exiga" ofAuto:autoId logo:logoId startYear:2008 endYear:0];
	[self addAutoModel:@"FF-1 Star" ofAuto:autoId logo:logoId startYear:1970 endYear:1973];
	[self addAutoModel:@"Fiori" ofAuto:autoId logo:logoId startYear:1972 endYear:1992];
	[self addAutoModel:@"Forester" ofAuto:autoId logo:logoId startYear:1997 endYear:0];
	[self addAutoModel:@"G" ofAuto:autoId logo:logoId startYear:1971 endYear:1972];
	[self addAutoModel:@"G3X Justy" ofAuto:autoId logo:logoId startYear:2001 endYear:2008];
	[self addAutoModel:@"G4e" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
	
	modelId = [self addAutoModel:@"Impreza" ofAuto:autoId logo:logoId startYear:1992 endYear:0];
	{
		[self addAutoSubmodel:@"Gen 2" ofModel:modelId logo:logoId startYear:2002 endYear:2007];
	}
	
	[self addAutoModel:@"Justy" ofAuto:autoId logo:logoId startYear:1984 endYear:2010];
	
	modelId = [self addAutoModel:@"Legacy" ofAuto:autoId logo:logoId startYear:1989 endYear:0];
	{
		[self addAutoSubmodel:@"G1" ofModel:modelId logo:logoId startYear:1989 endYear:1994];
		[self addAutoSubmodel:@"G2" ofModel:modelId logo:logoId startYear:1993 endYear:1998];
		[self addAutoSubmodel:@"G3" ofModel:modelId logo:logoId startYear:1998 endYear:2004];
		[self addAutoSubmodel:@"G4" ofModel:modelId logo:logoId startYear:2003 endYear:2009];
		[self addAutoSubmodel:@"G5" ofModel:modelId logo:logoId startYear:2009 endYear:0000];
	}
	
	[self addAutoModel:@"Leone" ofAuto:autoId logo:logoId startYear:1974 endYear:1994];
	
	modelId = [self addAutoModel:@"Liberty" ofAuto:autoId logo:logoId startYear:1989 endYear:0];
	{
		[self addAutoSubmodel:@"Exiga" ofModel:modelId logo:logoId startYear:2008 endYear:0];
	}
	
	[self addAutoModel:@"Tanto Exe" ofAuto:autoId logo:logoId startYear:2009 endYear:0000];
	[self addAutoModel:@"Lucra" ofAuto:autoId logo:logoId startYear:2009 endYear:0000];
	[self addAutoModel:@"Mini Jumbo" ofAuto:autoId logo:logoId startYear:1979 endYear:1992];
	[self addAutoModel:@"Outback" ofAuto:autoId logo:logoId startYear:1994 endYear:0000];
	[self addAutoModel:@"Pleo" ofAuto:autoId logo:logoId startYear:1998 endYear:0000];
	[self addAutoModel:@"Prodrive P2" ofAuto:autoId logo:logoId startYear:2006 endYear:-1];
	[self addAutoModel:@"R1" ofAuto:autoId logo:logoId startYear:2005 endYear:2010];
	[self addAutoModel:@"R1e" ofAuto:autoId logo:logoId startYear:2008 endYear:-1];
	[self addAutoModel:@"R2" ofAuto:autoId logo:logoId startYear:2003 endYear:2010];
	[self addAutoModel:@"Rex" ofAuto:autoId logo:logoId startYear:1981 endYear:1992];
	[self addAutoModel:@"Sambar" ofAuto:autoId logo:logoId startYear:1961 endYear:2009];
	[self addAutoModel:@"SRD-1" ofAuto:autoId logo:logoId startYear:0000 endYear:0000];
	[self addAutoModel:@"Stella" ofAuto:autoId logo:logoId startYear:2006 endYear:2011];
	[self addAutoModel:@"Bighorn" ofAuto:autoId logo:logoId startYear:1981 endYear:2005];
	[self addAutoModel:@"R-2" ofAuto:autoId logo:logoId startYear:1969 endYear:1972];
	[self addAutoModel:@"Sumo" ofAuto:autoId logo:logoId startYear:1983 endYear:1998];
	[self addAutoModel:@"TransCare" ofAuto:autoId logo:logoId startYear:2004 endYear:-1];
	[self addAutoModel:@"Traviq" ofAuto:autoId logo:logoId startYear:1999 endYear:0000];
	[self addAutoModel:@"Trezia" ofAuto:autoId logo:logoId startYear:2005 endYear:2010];
	[self addAutoModel:@"Tribeca" ofAuto:autoId logo:logoId startYear:2005 endYear:2014];
	
	[self addAutoModel:@"Vivio" ofAuto:autoId logo:logoId startYear:1992 endYear:1998];
	[self addAutoModel:@"Vortex" ofAuto:autoId logo:logoId startYear:1985 endYear:1991];
	[self addAutoModel:@"XT" ofAuto:autoId logo:logoId startYear:1985 endYear:1991];
#pragma mark |---- Infiniti
    logoId = [self addLogo:@"infiniti_256.png"];
    autoId = [self addAuto:@"Infiniti" country:countryId logo:logoId independentId:INFINITI];
    
    modelId = [self addAutoModel:@"G" ofAuto:autoId logo:logoId startYear:1990 endYear:0];
    {
        [self addAutoSubmodel:@"P10" ofModel:modelId logo:logoId startYear:1990 endYear:1996];
        [self addAutoSubmodel:@"P20" ofModel:modelId logo:logoId startYear:1999 endYear:2002];
        [self addAutoSubmodel:@"G35" ofModel:modelId logo:logoId startYear:2003 endYear:2007];
        [self addAutoSubmodel:@"G35x" ofModel:modelId logo:logoId startYear:2003 endYear:2007];
        [self addAutoSubmodel:@"G37" ofModel:modelId logo:logoId startYear:2006 endYear:0];
        [self addAutoSubmodel:@"G37x" ofModel:modelId logo:logoId startYear:2006 endYear:0];
        [self addAutoSubmodel:@"Sedan" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"Coupe" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"Convertible" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"IPL" ofModel:modelId logo:logoId startYear:2010 endYear:0];
        [self addAutoSubmodel:@"G25" ofModel:modelId logo:logoId startYear:2006 endYear:0];
    }
    
    modelId = [self addAutoModel:@"M" ofAuto:autoId logo:logoId startYear:1990 endYear:0];
    {
        [self addAutoSubmodel:@"M25" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"M30d" ofModel:modelId logo:logoId startYear:1989 endYear:1992];
        [self addAutoSubmodel:@"M35h" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"M37" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"M37x" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"M56" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"M56x" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"M30" ofModel:modelId logo:logoId startYear:1989 endYear:1992];
        [self addAutoSubmodel:@"Coupe" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"Convertible" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"M35" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"M45" ofModel:modelId logo:logoId startYear:2002 endYear:2004];
    }
    
    [self addAutoModel:@"EX" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
    
    modelId = [self addAutoModel:@"FX" ofAuto:autoId logo:logoId startYear:2002 endYear:0];
    {
        [self addAutoSubmodel:@"FX30d" ofModel:modelId logo:logoId startYear:2010 endYear:0];
        [self addAutoSubmodel:@"FX35" ofModel:modelId logo:logoId startYear:2003 endYear:0];
        [self addAutoSubmodel:@"FX45" ofModel:modelId logo:logoId startYear:2003 endYear:0];
        [self addAutoSubmodel:@"FX37" ofModel:modelId logo:logoId startYear:2008 endYear:0];
        [self addAutoSubmodel:@"FX50" ofModel:modelId logo:logoId startYear:0000 endYear:0];
    }
    
    [self addAutoModel:@"QX56" ofAuto:autoId logo:logoId startYear:1996 endYear:0];
    [self addAutoModel:@"JX" ofAuto:autoId logo:logoId startYear:2012 endYear:0];
    [self addAutoModel:@"QX4" ofAuto:autoId logo:logoId startYear:1996 endYear:2003];
    [self addAutoModel:@"J30" ofAuto:autoId logo:logoId startYear:1992 endYear:1997];
    [self addAutoModel:@"I30" ofAuto:autoId logo:logoId startYear:1988 endYear:2003];
    [self addAutoModel:@"I35" ofAuto:autoId logo:logoId startYear:1988 endYear:2003];
    [self addAutoModel:@"Q45" ofAuto:autoId logo:logoId startYear:1989 endYear:2006];
    
    modelId = [self addAutoModel:@"Concept" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"Essence" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
        [self addAutoSubmodel:@"Triant" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
        [self addAutoSubmodel:@"Kuraza" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
        [self addAutoSubmodel:@"Essence" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
        [self addAutoSubmodel:@"Etherea" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
        [self addAutoSubmodel:@"Emerg-e" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
        [self addAutoSubmodel:@"LE" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
        [self addAutoSubmodel:@"Q30" ofModel:modelId logo:logoId startYear:2013 endYear:-1];
    }
    
#pragma mark |---- Mazda
    logoId = [self addLogo:@"mazda_256.png"];
    autoId = [self addAuto:@"Mazda" country:countryId logo:logoId independentId:MAZDA];
    
    modelId = [self addAutoModel:@"Concepts" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"717C" ofModel:modelId logo:logoId startYear:1983 endYear:-1];
        [self addAutoSubmodel:@"727C" ofModel:modelId logo:logoId startYear:1984 endYear:-1];
        [self addAutoSubmodel:@"737C" ofModel:modelId logo:logoId startYear:1985 endYear:-1];
        [self addAutoSubmodel:@"757" ofModel:modelId logo:logoId startYear:1986 endYear:-1];
        [self addAutoSubmodel:@"767" ofModel:modelId logo:logoId startYear:1988 endYear:-1];
        [self addAutoSubmodel:@"RX-792P" ofModel:modelId logo:logoId startYear:1992 endYear:-1];
        [self addAutoSubmodel:@"Furai" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
    }
    
    modelId = [self addAutoModel:@"CX" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"CX-5" ofModel:modelId logo:logoId startYear:2012 endYear:0];
        [self addAutoSubmodel:@"CX-7" ofModel:modelId logo:logoId startYear:2007 endYear:2012];
        [self addAutoSubmodel:@"CX-9" ofModel:modelId logo:logoId startYear:2007 endYear:0];
    }
    
    modelId = [self addAutoModel:@"MX" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"MX-3" ofModel:modelId logo:logoId startYear:1992 endYear:1998];
        [self addAutoSubmodel:@"MX-5" ofModel:modelId logo:logoId startYear:1992 endYear:1998];
        [self addAutoSubmodel:@"MX-6" ofModel:modelId logo:logoId startYear:1989 endYear:0];
    }
    
    modelId = [self addAutoModel:@"Proceed" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"Proceed" ofModel:modelId logo:logoId startYear:1961 endYear:2006];
        [self addAutoSubmodel:@"Proceed Levante" ofModel:modelId logo:logoId startYear:1988 endYear:0];
        [self addAutoSubmodel:@"Proceed Marvie" ofModel:modelId logo:logoId startYear:1961 endYear:2006];
    }
    
    modelId = [self addAutoModel:@"RX" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"RX-3" ofModel:modelId logo:logoId startYear:1971 endYear:1978];
        [self addAutoSubmodel:@"RX-5" ofModel:modelId logo:logoId startYear:1967 endYear:1995];
        [self addAutoSubmodel:@"RX-7" ofModel:modelId logo:logoId startYear:1978 endYear:2002];
        [self addAutoSubmodel:@"RX-792P" ofModel:modelId logo:logoId startYear:1992 endYear:-1];
        [self addAutoSubmodel:@"RX-8" ofModel:modelId logo:logoId startYear:2003 endYear:2012];
    }
    
    modelId = [self addAutoModel:@"Xedos" ofAuto:autoId logo:logoId startYear:1992 endYear:2002];
    {
        [self addAutoSubmodel:@"6" ofModel:modelId logo:logoId startYear:1992 endYear:1999];
        [self addAutoSubmodel:@"9" ofModel:modelId logo:logoId startYear:1993 endYear:2002];
    }
    
    [self addAutoModel:@"121" ofAuto:autoId logo:logoId startYear:1975 endYear:2002];
    [self addAutoModel:@"2" ofAuto:autoId logo:logoId startYear:1996 endYear:0];
    [self addAutoModel:@"323" ofAuto:autoId logo:logoId startYear:1963 endYear:2003];
    [self addAutoModel:@"3" ofAuto:autoId logo:logoId startYear:2003 endYear:0];
    [self addAutoModel:@"5" ofAuto:autoId logo:logoId startYear:1999 endYear:0];
    [self addAutoModel:@"616" ofAuto:autoId logo:logoId startYear:1970 endYear:2002];
    [self addAutoModel:@"6" ofAuto:autoId logo:logoId startYear:2002 endYear:0];
    [self addAutoModel:@"787B" ofAuto:autoId logo:logoId startYear:1990 endYear:1991];
    [self addAutoModel:@"808" ofAuto:autoId logo:logoId startYear:1971 endYear:1978];
    [self addAutoModel:@"818" ofAuto:autoId logo:logoId startYear:1971 endYear:1978];
    [self addAutoModel:@"8" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
    [self addAutoModel:@"929" ofAuto:autoId logo:logoId startYear:1973 endYear:1995];
    [self addAutoModel:@"929 Coupe" ofAuto:autoId logo:logoId startYear:1986 endYear:1987];
    [self addAutoModel:@"Allegro" ofAuto:autoId logo:logoId startYear:1963 endYear:2003];
    [self addAutoModel:@"AZ-3" ofAuto:autoId logo:logoId startYear:1992 endYear:1998];
    [self addAutoModel:@"AZ-Wagon" ofAuto:autoId logo:logoId startYear:1993 endYear:0];
    [self addAutoModel:@"B-Series" ofAuto:autoId logo:logoId startYear:1961 endYear:2006];
    [self addAutoModel:@"B360" ofAuto:autoId logo:logoId startYear:1961 endYear:1968];
    [self addAutoModel:@"B600" ofAuto:autoId logo:logoId startYear:1960 endYear:1966];
    [self addAutoModel:@"Biante" ofAuto:autoId logo:logoId startYear:2008 endYear:0];
    
    [self addAutoModel:@"Bongo" ofAuto:autoId logo:logoId startYear:1966 endYear:0];
    [self addAutoModel:@"BT-50" ofAuto:autoId logo:logoId startYear:2006 endYear:0];
    [self addAutoModel:@"Capella" ofAuto:autoId logo:logoId startYear:1970 endYear:2002];
    [self addAutoModel:@"Carol" ofAuto:autoId logo:logoId startYear:1962 endYear:0];
    [self addAutoModel:@"Chantez" ofAuto:autoId logo:logoId startYear:1972 endYear:1976];
    [self addAutoModel:@"Cosmo" ofAuto:autoId logo:logoId startYear:1967 endYear:1995];
    [self addAutoModel:@"Cronos" ofAuto:autoId logo:logoId startYear:1991 endYear:1995];
    [self addAutoModel:@"Demio" ofAuto:autoId logo:logoId startYear:1996 endYear:0];
    [self addAutoModel:@"Étude" ofAuto:autoId logo:logoId startYear:1987 endYear:1989];
    [self addAutoModel:@"Familia" ofAuto:autoId logo:logoId startYear:1963 endYear:2003];
    [self addAutoModel:@"Grand Familia" ofAuto:autoId logo:logoId startYear:1971 endYear:1978];
    [self addAutoModel:@"Lantis" ofAuto:autoId logo:logoId startYear:1994 endYear:1998];
    [self addAutoModel:@"Laputa" ofAuto:autoId logo:logoId startYear:1999 endYear:2006];
    [self addAutoModel:@"Luce" ofAuto:autoId logo:logoId startYear:1966 endYear:1990];
    [self addAutoModel:@"GTP" ofAuto:autoId logo:logoId startYear:1981 endYear:1985];
    [self addAutoModel:@"K360" ofAuto:autoId logo:logoId startYear:1959 endYear:1969];
    [self addAutoModel:@"Mazdago" ofAuto:autoId logo:logoId startYear:1930 endYear:1945];
    [self addAutoModel:@"Metro" ofAuto:autoId logo:logoId startYear:1996 endYear:0];
    [self addAutoModel:@"Millenia" ofAuto:autoId logo:logoId startYear:1992 endYear:2003];
    [self addAutoModel:@"Mizer" ofAuto:autoId logo:logoId startYear:1971 endYear:1978];
    
    [self addAutoModel:@"MPV" ofAuto:autoId logo:logoId startYear:1989 endYear:0];
    [self addAutoModel:@"MXR-01" ofAuto:autoId logo:logoId startYear:1987 endYear:1993];
    [self addAutoModel:@"Navajo" ofAuto:autoId logo:logoId startYear:1991 endYear:1994];
    [self addAutoModel:@"P360" ofAuto:autoId logo:logoId startYear:1962 endYear:0];
    [self addAutoModel:@"Persona" ofAuto:autoId logo:logoId startYear:1988 endYear:1993];
    [self addAutoModel:@"Porter" ofAuto:autoId logo:logoId startYear:1961 endYear:1968];
    [self addAutoModel:@"Precedia" ofAuto:autoId logo:logoId startYear:1992 endYear:1998];
    [self addAutoModel:@"Premacy" ofAuto:autoId logo:logoId startYear:1999 endYear:0];
    [self addAutoModel:@"R100" ofAuto:autoId logo:logoId startYear:1968 endYear:1973];
    [self addAutoModel:@"R130" ofAuto:autoId logo:logoId startYear:1966 endYear:1990];
    [self addAutoModel:@"R360" ofAuto:autoId logo:logoId startYear:1960 endYear:1966];
    [self addAutoModel:@"Revue" ofAuto:autoId logo:logoId startYear:1990 endYear:1998];
    [self addAutoModel:@"Roadpacer AP" ofAuto:autoId logo:logoId startYear:1975 endYear:1977];
    [self addAutoModel:@"Roadster" ofAuto:autoId logo:logoId startYear:1989 endYear:0];
    [self addAutoModel:@"Savanna" ofAuto:autoId logo:logoId startYear:1971 endYear:1992];
    [self addAutoModel:@"Scrum" ofAuto:autoId logo:logoId startYear:1989 endYear:0];
    [self addAutoModel:@"Sentia" ofAuto:autoId logo:logoId startYear:1991 endYear:1999];
    [self addAutoModel:@"Spiano" ofAuto:autoId logo:logoId startYear:2002 endYear:2008];
    [self addAutoModel:@"Titan" ofAuto:autoId logo:logoId startYear:1971 endYear:2000];
    [self addAutoModel:@"Tribute" ofAuto:autoId logo:logoId startYear:2001 endYear:2011];
    
    [self addAutoModel:@"Verisa" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
    
#pragma mark |---- Mitsubishi
    logoId = [self addLogo:@"mitsubishi_256.png"];
    autoId = [self addAuto:@"Mitsubishi" country:countryId logo:logoId independentId:MITSUBISHI];
    
    [self addAutoModel:@"3000GT" ofAuto:autoId logo:logoId startYear:1990 endYear:2001];
	[self addAutoModel:@"360" ofAuto:autoId logo:logoId startYear:1961 endYear:1969];
	[self addAutoModel:@"380" ofAuto:autoId logo:logoId startYear:2005 endYear:2008];
	[self addAutoModel:@"500" ofAuto:autoId logo:logoId startYear:1960 endYear:1962];
	[self addAutoModel:@"Adventure" ofAuto:autoId logo:logoId startYear:1997 endYear:0];
	[self addAutoModel:@"Airtrek" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
	[self addAutoModel:@"Aspire" ofAuto:autoId logo:logoId startYear:0000 endYear:0];
	[self addAutoModel:@"Attrage" ofAuto:autoId logo:logoId startYear:2013 endYear:0];
	[self addAutoModel:@"Carisma" ofAuto:autoId logo:logoId startYear:1995 endYear:2004];
	[self addAutoModel:@"Celeste" ofAuto:autoId logo:logoId startYear:0000 endYear:0];
	[self addAutoModel:@"Challenger" ofAuto:autoId logo:logoId startYear:1996 endYear:2012];
	[self addAutoModel:@"Champ" ofAuto:autoId logo:logoId startYear:1973 endYear:0];
	[self addAutoModel:@"Chariot" ofAuto:autoId logo:logoId startYear:1983 endYear:2003];
	[self addAutoModel:@"Cordia" ofAuto:autoId logo:logoId startYear:1982 endYear:1990];
	[self addAutoModel:@"Debonair" ofAuto:autoId logo:logoId startYear:1964 endYear:1998];
	[self addAutoModel:@"Delica" ofAuto:autoId logo:logoId startYear:1968 endYear:0];
	[self addAutoModel:@"Diamante" ofAuto:autoId logo:logoId startYear:1995 endYear:2005];
	[self addAutoModel:@"Dignity" ofAuto:autoId logo:logoId startYear:1999 endYear:2001];
	[self addAutoModel:@"Dignity" ofAuto:autoId logo:logoId startYear:2012 endYear:0];
	[self addAutoModel:@"Dingo" ofAuto:autoId logo:logoId startYear:1998 endYear:2003];
	
	[self addAutoModel:@"Dion" ofAuto:autoId logo:logoId startYear:2000 endYear:2005];
	[self addAutoModel:@"Eclipse" ofAuto:autoId logo:logoId startYear:1989 endYear:2011];
	[self addAutoModel:@"eK" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
	[self addAutoModel:@"Emeraude" ofAuto:autoId logo:logoId startYear:1969 endYear:2012];
	[self addAutoModel:@"Endeavor" ofAuto:autoId logo:logoId startYear:2002 endYear:2011];
	[self addAutoModel:@"Eterna" ofAuto:autoId logo:logoId startYear:1969 endYear:2012];
	[self addAutoModel:@"Forte" ofAuto:autoId logo:logoId startYear:1978 endYear:0];
	[self addAutoModel:@"Freeca" ofAuto:autoId logo:logoId startYear:1997 endYear:0];
	[self addAutoModel:@"FTO" ofAuto:autoId logo:logoId startYear:1994 endYear:2000];
	[self addAutoModel:@"Fuzion" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"G-Wagon" ofAuto:autoId logo:logoId startYear:1996 endYear:2012];
	[self addAutoModel:@"Go" ofAuto:autoId logo:logoId startYear:1946 endYear:1962];
	[self addAutoModel:@"Grandis" ofAuto:autoId logo:logoId startYear:2003 endYear:2011];
	[self addAutoModel:@"Grunder" ofAuto:autoId logo:logoId startYear:2003 endYear:2012];
	[self addAutoModel:@"GTO" ofAuto:autoId logo:logoId startYear:1990 endYear:2001];
	[self addAutoModel:@"Henry J" ofAuto:autoId logo:logoId startYear:1950 endYear:1954];
	[self addAutoModel:@"i" ofAuto:autoId logo:logoId startYear:2006 endYear:2013];
	[self addAutoModel:@"i-MiEV" ofAuto:autoId logo:logoId startYear:2009 endYear:0];
	[self addAutoModel:@"Jeep" ofAuto:autoId logo:logoId startYear:1953 endYear:1998];
	[self addAutoModel:@"Jolie" ofAuto:autoId logo:logoId startYear:1997 endYear:0];
	
	[self addAutoModel:@"Kuda" ofAuto:autoId logo:logoId startYear:1997 endYear:0];
	[self addAutoModel:@"L100" ofAuto:autoId logo:logoId startYear:1966 endYear:0];
	[self addAutoModel:@"L200" ofAuto:autoId logo:logoId startYear:1978 endYear:0];
	[self addAutoModel:@"L300" ofAuto:autoId logo:logoId startYear:1968 endYear:0];
	[self addAutoModel:@"Legnum" ofAuto:autoId logo:logoId startYear:1969 endYear:2012];
	[self addAutoModel:@"Leo" ofAuto:autoId logo:logoId startYear:1946 endYear:1962];
	[self addAutoModel:@"Lettuce" ofAuto:autoId logo:logoId startYear:1984 endYear:1989];
	[self addAutoModel:@"Libero" ofAuto:autoId logo:logoId startYear:1973 endYear:0];
	[self addAutoModel:@"Magna" ofAuto:autoId logo:logoId startYear:1985 endYear:2005];
	[self addAutoModel:@"Magnum" ofAuto:autoId logo:logoId startYear:1978 endYear:0];
	[self addAutoModel:@"Maven" ofAuto:autoId logo:logoId startYear:2005 endYear:2009];
	[self addAutoModel:@"Mighty Max" ofAuto:autoId logo:logoId startYear:1978 endYear:0];
	[self addAutoModel:@"Minica" ofAuto:autoId logo:logoId startYear:1962 endYear:2011];
	[self addAutoModel:@"Minicab" ofAuto:autoId logo:logoId startYear:1966 endYear:0];
	[self addAutoModel:@"Mirage" ofAuto:autoId logo:logoId startYear:1978 endYear:2003];
	[self addAutoModel:@"Mirage" ofAuto:autoId logo:logoId startYear:2012 endYear:0];
	[self addAutoModel:@"Mizushima" ofAuto:autoId logo:logoId startYear:1946 endYear:1962];
	[self addAutoModel:@"Model A" ofAuto:autoId logo:logoId startYear:1917 endYear:1921];
	[self addAutoModel:@"Pinin" ofAuto:autoId logo:logoId startYear:1998 endYear:2007];
	
	[self addAutoModel:@"Pistachio" ofAuto:autoId logo:logoId startYear:1999 endYear:1999];
	[self addAutoModel:@"Precis" ofAuto:autoId logo:logoId startYear:1985 endYear:1994];
	[self addAutoModel:@"Proudia" ofAuto:autoId logo:logoId startYear:1999 endYear:2001];
	[self addAutoModel:@"Proudia" ofAuto:autoId logo:logoId startYear:2012 endYear:0];
	[self addAutoModel:@"Racing Lancer" ofAuto:autoId logo:logoId startYear:2008 endYear:0];
	[self addAutoModel:@"Raider" ofAuto:autoId logo:logoId startYear:2005 endYear:2009];
	[self addAutoModel:@"Rodeo" ofAuto:autoId logo:logoId startYear:1978 endYear:0];
	[self addAutoModel:@"RVR" ofAuto:autoId logo:logoId startYear:1991 endYear:2002];
	[self addAutoModel:@"RVR" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
	[self addAutoModel:@"Sapporo" ofAuto:autoId logo:logoId startYear:1978 endYear:1984];
	[self addAutoModel:@"Savrin" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
	[self addAutoModel:@"Scorpion" ofAuto:autoId logo:logoId startYear:1976 endYear:1984];
	[self addAutoModel:@"Shogun" ofAuto:autoId logo:logoId startYear:1982 endYear:0];
	[self addAutoModel:@"Shogun Pinin" ofAuto:autoId logo:logoId startYear:1998 endYear:2007];
	[self addAutoModel:@"Shogun Sport" ofAuto:autoId logo:logoId startYear:1996 endYear:2012];
	[self addAutoModel:@"Sigma" ofAuto:autoId logo:logoId startYear:1976 endYear:1996];
	[self addAutoModel:@"Sportero" ofAuto:autoId logo:logoId startYear:1978 endYear:0];
	[self addAutoModel:@"Starion" ofAuto:autoId logo:logoId startYear:1982 endYear:1989];
	[self addAutoModel:@"Storm" ofAuto:autoId logo:logoId startYear:1978 endYear:0];
	[self addAutoModel:@"Strada" ofAuto:autoId logo:logoId startYear:1978 endYear:0];
	
	[self addAutoModel:@"Toppo" ofAuto:autoId logo:logoId startYear:1990 endYear:0];
	[self addAutoModel:@"Town Bee" ofAuto:autoId logo:logoId startYear:1990 endYear:0];
	[self addAutoModel:@"Town Box" ofAuto:autoId logo:logoId startYear:1999 endYear:2011];
	[self addAutoModel:@"Towny" ofAuto:autoId logo:logoId startYear:1962 endYear:2011];
	[self addAutoModel:@"Tredia" ofAuto:autoId logo:logoId startYear:1982 endYear:1990];
	[self addAutoModel:@"Triton" ofAuto:autoId logo:logoId startYear:1978 endYear:0];
	[self addAutoModel:@"Type 73" ofAuto:autoId logo:logoId startYear:1978 endYear:0];
	[self addAutoModel:@"V3000" ofAuto:autoId logo:logoId startYear:1973 endYear:0];
	[self addAutoModel:@"Verada" ofAuto:autoId logo:logoId startYear:1985 endYear:2005];
	[self addAutoModel:@"Warrior" ofAuto:autoId logo:logoId startYear:1978 endYear:0];
	[self addAutoModel:@"Zinger" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"Nativa" ofAuto:autoId logo:logoId startYear:1996 endYear:2012];
	[self addAutoModel:@"Nimbus" ofAuto:autoId logo:logoId startYear:1983 endYear:2003];
    
	modelId = [self addAutoModel:@"Colt" ofAuto:autoId logo:logoId startYear:1962 endYear:2012];
	{
		[self addAutoSubmodel:@"1000" ofModel:modelId logo:logoId startYear:1963 endYear:1966];
		[self addAutoSubmodel:@"11-F" ofModel:modelId logo:logoId startYear:0000 endYear:0];
		[self addAutoSubmodel:@"1100" ofModel:modelId logo:logoId startYear:1966 endYear:1968];
		[self addAutoSubmodel:@"1100F" ofModel:modelId logo:logoId startYear:0000 endYear:00];
		[self addAutoSubmodel:@"1200" ofModel:modelId logo:logoId startYear:1968 endYear:1970];
		[self addAutoSubmodel:@"1500" ofModel:modelId logo:logoId startYear:1965 endYear:1969];
		[self addAutoSubmodel:@"600" ofModel:modelId logo:logoId startYear:1962 endYear:1965];
		[self addAutoSubmodel:@"800" ofModel:modelId logo:logoId startYear:1965 endYear:1971];
		[self addAutoSubmodel:@"Bakkie" ofModel:modelId logo:logoId startYear:1978 endYear:0];
		[self addAutoSubmodel:@"Galant" ofModel:modelId logo:logoId startYear:1969 endYear:2012];
		[self addAutoSubmodel:@"Rodeo" ofModel:modelId logo:logoId startYear:1978 endYear:0];
		[self addAutoSubmodel:@"T120SS" ofModel:modelId logo:logoId startYear:0000 endYear:0];
	}
	
	modelId = [self addAutoModel:@"Expo" ofAuto:autoId logo:logoId startYear:1983 endYear:2003];
	{
		[self addAutoSubmodel:@"LRV" ofModel:modelId logo:logoId startYear:1991 endYear:2002];
		[self addAutoSubmodel:@"LRV" ofModel:modelId logo:logoId startYear:2010 endYear:0];
	}
	
	modelId = [self addAutoModel:@"Galant" ofAuto:autoId logo:logoId startYear:1969 endYear:2012];
	{
		[self addAutoSubmodel:@"Fortis" ofModel:modelId logo:logoId startYear:1973 endYear:0];
		[self addAutoSubmodel:@"FTO" ofModel:modelId logo:logoId startYear:1971 endYear:1975];
		[self addAutoSubmodel:@"GTO" ofModel:modelId logo:logoId startYear:1970 endYear:1976];
		[self addAutoSubmodel:@"Lambda" ofModel:modelId logo:logoId startYear:1976 endYear:1984];
		[self addAutoSubmodel:@"VR-4" ofModel:modelId logo:logoId startYear:1988 endYear:1992];
		[self addAutoSubmodel:@"VR-4" ofModel:modelId logo:logoId startYear:1992 endYear:1996];
		[self addAutoSubmodel:@"VR-4" ofModel:modelId logo:logoId startYear:1996 endYear:2002];
	}
	
	modelId = [self addAutoModel:@"Lancer" ofAuto:autoId logo:logoId startYear:1973 endYear:0];
	{
		[self addAutoSubmodel:@"Celeste" ofModel:modelId logo:logoId startYear:0000 endYear:0];
		[self addAutoSubmodel:@"Evolution" ofModel:modelId logo:logoId startYear:1992 endYear:0];
		[self addAutoSubmodel:@"WRC" ofModel:modelId logo:logoId startYear:2001 endYear:2005];
		[self addAutoSubmodel:@"A70" ofModel:modelId logo:logoId startYear:1973 endYear:1985];
	}
	
	modelId = [self addAutoModel:@"Montero" ofAuto:autoId logo:logoId startYear:1982 endYear:0];
	{
		[self addAutoSubmodel:@"iO" ofModel:modelId logo:logoId startYear:1998 endYear:2007];
		[self addAutoSubmodel:@"Sport" ofModel:modelId logo:logoId startYear:1996 endYear:2012];
	}
	
	modelId = [self addAutoModel:@"Outlander" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
	{
		[self addAutoSubmodel:@"Sport" ofModel:modelId logo:logoId startYear:1991 endYear:2002];
		[self addAutoSubmodel:@"Sport" ofModel:modelId logo:logoId startYear:2010 endYear:0];
	}
	
	modelId = [self addAutoModel:@"Pajero" ofAuto:autoId logo:logoId startYear:1982 endYear:0];
	{
		[self addAutoSubmodel:@"iO" ofModel:modelId logo:logoId startYear:1998 endYear:2007];
		[self addAutoSubmodel:@"Junior" ofModel:modelId logo:logoId startYear:1995 endYear:1998];
		[self addAutoSubmodel:@"Mini" ofModel:modelId logo:logoId startYear:1994 endYear:2012];
		[self addAutoSubmodel:@"Pinin" ofModel:modelId logo:logoId startYear:1998 endYear:2007];
		[self addAutoSubmodel:@"Sport" ofModel:modelId logo:logoId startYear:1996 endYear:2012];
		[self addAutoSubmodel:@"TR4" ofModel:modelId logo:logoId startYear:1998 endYear:2007];
	}
	
	[self addAutoModel:@"Space Gear" ofAuto:autoId logo:logoId startYear:1968 endYear:0];
	[self addAutoModel:@"Space Runner" ofAuto:autoId logo:logoId startYear:1991 endYear:2002];
	[self addAutoModel:@"Space Runner" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
	[self addAutoModel:@"Space Star" ofAuto:autoId logo:logoId startYear:1998 endYear:2005];
	
	modelId = [self addAutoModel:@"Concept cars" ofAuto:autoId logo:logoId startYear:1982 endYear:0 isSelectable:NO];
	{
		[self addAutoSubmodel:@"ASX" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"Concept-CT MIEV" ofModel:modelId logo:logoId startYear:2006 endYear:-1];
		[self addAutoSubmodel:@"Concept-cX" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"CZ2" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"Concept D-5" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"ESR" ofModel:modelId logo:logoId startYear:1993 endYear:-1];
		[self addAutoSubmodel:@"Evolander" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"Concept-EZ MIEV" ofModel:modelId logo:logoId startYear:2006 endYear:-1];
		[self addAutoSubmodel:@"FCV" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Field Guard" ofModel:modelId logo:logoId startYear:1993 endYear:-1];
		[self addAutoSubmodel:@"FTO EV" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"Gaus" ofModel:modelId logo:logoId startYear:1995 endYear:-1];
		[self addAutoSubmodel:@"HSR" ofModel:modelId logo:logoId startYear:1987 endYear:1997];
		[self addAutoSubmodel:@"HSX" ofModel:modelId logo:logoId startYear:1989 endYear:-1];
		[self addAutoSubmodel:@"i Concept" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"i-MiEV" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"Lynx" ofModel:modelId logo:logoId startYear:1993 endYear:-1];
		[self addAutoSubmodel:@"MAIA" ofModel:modelId logo:logoId startYear:1997 endYear:-1];
		[self addAutoSubmodel:@"Maus" ofModel:modelId logo:logoId startYear:1995 endYear:-1];
		[self addAutoSubmodel:@"MP-90X" ofModel:modelId logo:logoId startYear:1985 endYear:-1];
		
		[self addAutoSubmodel:@"mR. 1000" ofModel:modelId logo:logoId startYear:1991 endYear:-1];
		[self addAutoSubmodel:@"mS. 1000" ofModel:modelId logo:logoId startYear:1991 endYear:-1];
		[self addAutoSubmodel:@"MUM500" ofModel:modelId logo:logoId startYear:1993 endYear:-1];
		[self addAutoSubmodel:@"Nessie" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"Pajero Evo 2+2" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"PX33" ofModel:modelId logo:logoId startYear:1934 endYear:1937];
		[self addAutoSubmodel:@"Concept-RA" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"RPM 7000" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"Se-Ro" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Space Liner" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"Sport Truck Concept" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
		[self addAutoSubmodel:@"Concept-Sportback" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"SSS" ofModel:modelId logo:logoId startYear:2000 endYear:-1];
		[self addAutoSubmodel:@"SST" ofModel:modelId logo:logoId startYear:1998 endYear:-1];
		[self addAutoSubmodel:@"SSU" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"SSW" ofModel:modelId logo:logoId startYear:1979 endYear:-1];
		[self addAutoSubmodel:@"SUP" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"SUW" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"Tarmac Spyder" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Technas" ofModel:modelId logo:logoId startYear:1997 endYear:-1];
		
		[self addAutoSubmodel:@"TETRA" ofModel:modelId logo:logoId startYear:1997 endYear:-1];
		[self addAutoSubmodel:@"Concept-X" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"Concept-ZT" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
	}

    // K
#pragma mark -
#pragma mark K
    // L
#pragma mark -
#pragma mark L
    // M
#pragma mark -
#pragma mark M
    // N
#pragma mark -
#pragma mark N
    // O
#pragma mark -
#pragma mark O
    // P
#pragma mark -
#pragma mark P
    // Q
#pragma mark -
#pragma mark Q
    // R
#pragma mark -
#pragma mark R
    // S
#pragma mark -
#pragma mark S
#pragma mark === Sweden ===
    countryId = [self addCountry:@"Sweden"];
#pragma mark |---- Scania
    logoId = [self addLogo:@"scania_256.png"];
    autoId = [self addAuto:@"Scania" country:countryId logo:logoId independentId:SCANIA];
    
    modelId = [self addAutoModel:@"Bus" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"4-series" ofModel:modelId logo:logoId startYear:1997 endYear:0];
        [self addAutoSubmodel:@"F-series" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"K-series" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"L113" ofModel:modelId logo:logoId startYear:1989 endYear:1998];
        [self addAutoSubmodel:@"Metropolitan" ofModel:modelId logo:logoId startYear:1973 endYear:1978];
        [self addAutoSubmodel:@"N-series" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"N112" ofModel:modelId logo:logoId startYear:1978 endYear:1987];
        [self addAutoSubmodel:@"N113" ofModel:modelId logo:logoId startYear:1988 endYear:2000];
        [self addAutoSubmodel:@"N94" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"OmniCity" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"OmniDekka" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"OmniLink" ofModel:modelId logo:logoId startYear:1998 endYear:0];
        [self addAutoSubmodel:@"OmniTown" ofModel:modelId logo:logoId startYear:0000 endYear:0];
        [self addAutoSubmodel:@"3-series" ofModel:modelId logo:logoId startYear:0000 endYear:0];
    }
    
    modelId = [self addAutoModel:@"Truck" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
        [self addAutoSubmodel:@"4-series" ofModel:modelId logo:logoId startYear:1995 endYear:0];
        [self addAutoSubmodel:@"5-series" ofModel:modelId logo:logoId startYear:2004 endYear:2009];
        [self addAutoSubmodel:@"6-series" ofModel:modelId logo:logoId startYear:2009 endYear:0];
        [self addAutoSubmodel:@"SBA111" ofModel:modelId logo:logoId startYear:1975 endYear:1981];
        [self addAutoSubmodel:@"3-series" ofModel:modelId logo:logoId startYear:1987 endYear:1997];
    }
    // T
#pragma mark -
#pragma mark T
    // U
#pragma mark -
#pragma mark U
#pragma mark === USA ===
    countryId = [self addCountry:@"USA"];
#pragma mark |---- Ford
    logoId = [self addLogo:@"ford_256.png"];
    autoId = [self addAuto:@"Ford" country:countryId logo:logoId independentId:FORD];
    modelId = [self addAutoModel:@"Old cars" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
		[self addAutoSubmodel:@"2GA" ofModel:modelId logo:logoId startYear:1942 endYear:-1];
		[self addAutoSubmodel:@"300" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		[self addAutoSubmodel:@"7W" ofModel:modelId logo:logoId startYear:1937 endYear:1938];
		[self addAutoSubmodel:@"7Y" ofModel:modelId logo:logoId startYear:1938 endYear:1939];
        [self addAutoSubmodel:@"Anglia" ofModel:modelId logo:logoId startYear:1940 endYear:1967];
		[self addAutoSubmodel:@"Classic" ofModel:modelId logo:logoId startYear:1961 endYear:1963];
		[self addAutoSubmodel:@"Comète" ofModel:modelId logo:logoId startYear:1951 endYear:1954];
		[self addAutoSubmodel:@"Consul" ofModel:modelId logo:logoId startYear:1951 endYear:1962];
		[self addAutoSubmodel:@"Consul" ofModel:modelId logo:logoId startYear:1972 endYear:1975];
		[self addAutoSubmodel:@"Corcel" ofModel:modelId logo:logoId startYear:1968 endYear:1986];
		[self addAutoSubmodel:@"Corsair" ofModel:modelId logo:logoId startYear:1964 endYear:1970];
		[self addAutoSubmodel:@"Cortina" ofModel:modelId logo:logoId startYear:1962 endYear:1982];
		[self addAutoSubmodel:@"Carousel" ofModel:modelId logo:logoId startYear:1962 endYear:1982];
		[self addAutoSubmodel:@"Crusader" ofModel:modelId logo:logoId startYear:1962 endYear:1982];
		[self addAutoSubmodel:@"Country Sedan" ofModel:modelId logo:logoId startYear:1952 endYear:1974];
		[self addAutoSubmodel:@"Country Squire" ofModel:modelId logo:logoId startYear:1950 endYear:1991];
		[self addAutoSubmodel:@"Crestline" ofModel:modelId logo:logoId startYear:1952 endYear:1954];
		[self addAutoSubmodel:@"Crestliner" ofModel:modelId logo:logoId startYear:1950 endYear:1951];
		[self addAutoSubmodel:@"Custom Deluxe" ofModel:modelId logo:logoId startYear:1950 endYear:1951];
		[self addAutoSubmodel:@"Crown Victoria" ofModel:modelId logo:logoId startYear:1955 endYear:1957];
		[self addAutoSubmodel:@"Custom" ofModel:modelId logo:logoId startYear:1929 endYear:1981];
		[self addAutoSubmodel:@"Customline" ofModel:modelId logo:logoId startYear:1952 endYear:1956];
		[self addAutoSubmodel:@"CX" ofModel:modelId logo:logoId startYear:1935 endYear:1937];
		[self addAutoSubmodel:@"Del Rio	" ofModel:modelId logo:logoId startYear:1957 endYear:1958];
		[self addAutoSubmodel:@"Deluxe" ofModel:modelId logo:logoId startYear:1950 endYear:1951];
		[self addAutoSubmodel:@"Eifel" ofModel:modelId logo:logoId startYear:1935 endYear:1939];
		[self addAutoSubmodel:@"Eight" ofModel:modelId logo:logoId startYear:1938 endYear:1939];
		[self addAutoSubmodel:@"Elite" ofModel:modelId logo:logoId startYear:1974 endYear:1976];
		[self addAutoSubmodel:@"Escort" ofModel:modelId logo:logoId startYear:1955 endYear:1961];
		[self addAutoSubmodel:@"Escort" ofModel:modelId logo:logoId startYear:1968 endYear:2000];
		[self addAutoSubmodel:@"Executive" ofModel:modelId logo:logoId startYear:1966 endYear:1972];
		[self addAutoSubmodel:@"Fairlane" ofModel:modelId logo:logoId startYear:1955 endYear:1970];
		[self addAutoSubmodel:@"Fairmont" ofModel:modelId logo:logoId startYear:1978 endYear:1983];
		[self addAutoSubmodel:@"Falcon" ofModel:modelId logo:logoId startYear:1960 endYear:0];
		[self addAutoSubmodel:@"Galaxie" ofModel:modelId logo:logoId startYear:1959 endYear:1974];
		[self addAutoSubmodel:@"Granada" ofModel:modelId logo:logoId startYear:1972 endYear:1994];
		[self addAutoSubmodel:@"GT40" ofModel:modelId logo:logoId startYear:1964 endYear:1969];
		[self addAutoSubmodel:@"Köln" ofModel:modelId logo:logoId startYear:1932 endYear:1935];
		[self addAutoSubmodel:@"LTD" ofModel:modelId logo:logoId startYear:1965 endYear:1986];
		[self addAutoSubmodel:@"LTD II" ofModel:modelId logo:logoId startYear:1977 endYear:1979];
		[self addAutoSubmodel:@"Mainline" ofModel:modelId logo:logoId startYear:1952 endYear:1959];
		[self addAutoSubmodel:@"Maverick" ofModel:modelId logo:logoId startYear:1970 endYear:1979];
		[self addAutoSubmodel:@"Model 4-46" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Model 8-46" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Model 01" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Model 2" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Model 18" ofModel:modelId logo:logoId startYear:1932 endYear:1934];
		[self addAutoSubmodel:@"Model 40" ofModel:modelId logo:logoId startYear:1933 endYear:1934];
		[self addAutoSubmodel:@"Model 48" ofModel:modelId logo:logoId startYear:1935 endYear:1936];
		[self addAutoSubmodel:@"Model 50" ofModel:modelId logo:logoId startYear:1935 endYear:-1];
		[self addAutoSubmodel:@"Model 67" ofModel:modelId logo:logoId startYear:1936 endYear:-1];
		[self addAutoSubmodel:@"Model 68" ofModel:modelId logo:logoId startYear:1936 endYear:-1];
		[self addAutoSubmodel:@"Model 73" ofModel:modelId logo:logoId startYear:1939 endYear:-1];
		[self addAutoSubmodel:@"Model 74" ofModel:modelId logo:logoId startYear:1937 endYear:1940];
		[self addAutoSubmodel:@"Model 77" ofModel:modelId logo:logoId startYear:1937 endYear:1940];
		[self addAutoSubmodel:@"Model 78" ofModel:modelId logo:logoId startYear:1937 endYear:1940];
		[self addAutoSubmodel:@"Model 81A" ofModel:modelId logo:logoId startYear:1938 endYear:1940];
		[self addAutoSubmodel:@"Model 82A" ofModel:modelId logo:logoId startYear:1938 endYear:1940];
		[self addAutoSubmodel:@"Model 91" ofModel:modelId logo:logoId startYear:1939 endYear:1940];
		[self addAutoSubmodel:@"Model 922A" ofModel:modelId logo:logoId startYear:1938 endYear:1940];
		[self addAutoSubmodel:@"Model A" ofModel:modelId logo:logoId startYear:1903 endYear:1904];
		[self addAutoSubmodel:@"Model A" ofModel:modelId logo:logoId startYear:1927 endYear:1931];
		[self addAutoSubmodel:@"Model AC" ofModel:modelId logo:logoId startYear:1904 endYear:-1];
		[self addAutoSubmodel:@"Model B 1904" ofModel:modelId logo:logoId startYear:1904 endYear:1906];
		[self addAutoSubmodel:@"Model B 1932" ofModel:modelId logo:logoId startYear:1932 endYear:1934];
		[self addAutoSubmodel:@"Model C" ofModel:modelId logo:logoId startYear:1904 endYear:1905];
		[self addAutoSubmodel:@"Model C Ten" ofModel:modelId logo:logoId startYear:1935 endYear:1937];
		[self addAutoSubmodel:@"Model F" ofModel:modelId logo:logoId startYear:1905 endYear:1906];
		[self addAutoSubmodel:@"Model K" ofModel:modelId logo:logoId startYear:1906 endYear:1908];
		[self addAutoSubmodel:@"Model N" ofModel:modelId logo:logoId startYear:1906 endYear:1908];
		[self addAutoSubmodel:@"Model R" ofModel:modelId logo:logoId startYear:1907 endYear:1908];
		[self addAutoSubmodel:@"Model S" ofModel:modelId logo:logoId startYear:1907 endYear:1909];
		[self addAutoSubmodel:@"Model T" ofModel:modelId logo:logoId startYear:1908 endYear:1927];
		[self addAutoSubmodel:@"Model Y" ofModel:modelId logo:logoId startYear:1932 endYear:1937];
		[self addAutoSubmodel:@"Mondeo" ofModel:modelId logo:logoId startYear:1993 endYear:-1];
		[self addAutoSubmodel:@"Parklane" ofModel:modelId logo:logoId startYear:1956 endYear:-1];
		[self addAutoSubmodel:@"Pilot" ofModel:modelId logo:logoId startYear:1947 endYear:1951];
		[self addAutoSubmodel:@"Pinto" ofModel:modelId logo:logoId startYear:1971 endYear:1980];
		[self addAutoSubmodel:@"Popular" ofModel:modelId logo:logoId startYear:1953 endYear:1959];
		[self addAutoSubmodel:@"Prefect" ofModel:modelId logo:logoId startYear:1938 endYear:1961];
		[self addAutoSubmodel:@"Ranchero" ofModel:modelId logo:logoId startYear:1957 endYear:1979];
		[self addAutoSubmodel:@"Ranch Wagon" ofModel:modelId logo:logoId startYear:1952 endYear:1977];
		[self addAutoSubmodel:@"Rheinland" ofModel:modelId logo:logoId startYear:1933 endYear:1936];
		[self addAutoSubmodel:@"Roadster" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"RS200" ofModel:modelId logo:logoId startYear:1984 endYear:1986];
		[self addAutoSubmodel:@"Sedan Delivery" ofModel:modelId logo:logoId startYear:0000 endYear:0000];
		[self addAutoSubmodel:@"Skyliner" ofModel:modelId logo:logoId startYear:1957 endYear:1959];
		[self addAutoSubmodel:@"Squire" ofModel:modelId logo:logoId startYear:1955 endYear:1959];
		[self addAutoSubmodel:@"Sunliner" ofModel:modelId logo:logoId startYear:1952 endYear:1964];
		[self addAutoSubmodel:@"Starliner" ofModel:modelId logo:logoId startYear:1960 endYear:1961];
		[self addAutoSubmodel:@"Super Deluxe" ofModel:modelId logo:logoId startYear:1941 endYear:1948];
		[self addAutoSubmodel:@"Squire" ofModel:modelId logo:logoId startYear:1955 endYear:1959];
		[self addAutoSubmodel:@"Taunus" ofModel:modelId logo:logoId startYear:1939 endYear:1982];
		[self addAutoSubmodel:@"Ten" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Ten-Ten" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Thunderbird" ofModel:modelId logo:logoId startYear:1955 endYear:1997];
		[self addAutoSubmodel:@"Torino" ofModel:modelId logo:logoId startYear:1968 endYear:1976];
		[self addAutoSubmodel:@"Vedette" ofModel:modelId logo:logoId startYear:1948 endYear:1954];
		[self addAutoSubmodel:@"Victoria" ofModel:modelId logo:logoId startYear:1952 endYear:1954];
		[self addAutoSubmodel:@"XL" ofModel:modelId logo:logoId startYear:1968 endYear:-1];
		[self addAutoSubmodel:@"Zephyr Six" ofModel:modelId logo:logoId startYear:1950 endYear:1971];
		[self addAutoSubmodel:@"Zephyr" ofModel:modelId logo:logoId startYear:1950 endYear:1971];
		[self addAutoSubmodel:@"Zodiac" ofModel:modelId logo:logoId startYear:1950 endYear:1971];
		[self addAutoSubmodel:@"Zephyr-Zodiac" ofModel:modelId logo:logoId startYear:1966 endYear:1971];
    }
	[self addAutoModel:@"Aspire" ofAuto:autoId logo:logoId startYear:1994 endYear:1997];
	[self addAutoModel:@"Bantam" ofAuto:autoId logo:logoId startYear:1983 endYear:2011];
	modelId = [self addAutoModel:@"Capri" ofAuto:autoId logo:logoId startYear:1995 endYear:2000];
    {
		[self addAutoSubmodel:@"Capri" ofModel:modelId logo:logoId startYear:1961 endYear:1964];
		[self addAutoSubmodel:@"Capri" ofModel:modelId logo:logoId startYear:1969 endYear:1986];
		[self addAutoSubmodel:@"Capri" ofModel:modelId logo:logoId startYear:1989 endYear:1994];
    }
	[self addAutoModel:@"Contour" ofAuto:autoId logo:logoId startYear:1991 endYear:-1];
	[self addAutoModel:@"Corsair" ofAuto:autoId logo:logoId startYear:1989 endYear:1992];
	[self addAutoModel:@"Cougar" ofAuto:autoId logo:logoId startYear:1999 endYear:2002];
	[self addAutoModel:@"Coupe" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Crown Victoria" ofAuto:autoId logo:logoId startYear:1992 endYear:2011];
	[self addAutoModel:@"Delivery Car" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Del Rey" ofAuto:autoId logo:logoId startYear:1982 endYear:1985];
	[self addAutoModel:@"Durango" ofAuto:autoId logo:logoId startYear:1980 endYear:1981];
	[self addAutoModel:@"Escort" ofAuto:autoId logo:logoId startYear:1981 endYear:2002];
	[self addAutoModel:@"EXP" ofAuto:autoId logo:logoId startYear:1982 endYear:1988];
	[self addAutoModel:@"Fairlane" ofAuto:autoId logo:logoId startYear:1967 endYear:2007];
	[self addAutoModel:@"Fairmont" ofAuto:autoId logo:logoId startYear:1965 endYear:2008];
	[self addAutoModel:@"Falcon" ofAuto:autoId logo:logoId startYear:1960 endYear:0];
	[self addAutoModel:@"Festiva" ofAuto:autoId logo:logoId startYear:1988 endYear:1992];
	[self addAutoModel:@"Fiesta" ofAuto:autoId logo:logoId startYear:1976 endYear:0];
	[self addAutoModel:@"Futura" ofAuto:autoId logo:logoId startYear:1962 endYear:2008];
	[self addAutoModel:@"Figo" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
	[self addAutoModel:@"Five Hundred" ofAuto:autoId logo:logoId startYear:2005 endYear:2007];
	[self addAutoModel:@"Flexible Fuel" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Focus" ofAuto:autoId logo:logoId startYear:1998 endYear:0];
	[self addAutoModel:@"Focus C-MAX" ofAuto:autoId logo:logoId startYear:2003 endYear:2007];
	[self addAutoModel:@"Fusion" ofAuto:autoId logo:logoId startYear:2002 endYear:0];
	[self addAutoModel:@"GT" ofAuto:autoId logo:logoId startYear:2003 endYear:2006];
	[self addAutoModel:@"GTX1" ofAuto:autoId logo:logoId startYear:2005 endYear:2006];
	[self addAutoModel:@"Ikon" ofAuto:autoId logo:logoId startYear:2000 endYear:0];
	[self addAutoModel:@"Ka" ofAuto:autoId logo:logoId startYear:1996 endYear:0];
	[self addAutoModel:@"Landau" ofAuto:autoId logo:logoId startYear:1973 endYear:1983];
	[self addAutoModel:@"Laser" ofAuto:autoId logo:logoId startYear:1980 endYear:2003];
	[self addAutoModel:@"Linha" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"LTD" ofAuto:autoId logo:logoId startYear:1973 endYear:2007];
	[self addAutoModel:@"LTD Crown Victoria" ofAuto:autoId logo:logoId startYear:1983 endYear:1991];
	[self addAutoModel:@"Marauder" ofAuto:autoId logo:logoId startYear:2003 endYear:2004];
	[self addAutoModel:@"Maverick" ofAuto:autoId logo:logoId startYear:1988 endYear:2004];
	[self addAutoModel:@"Meteor" ofAuto:autoId logo:logoId startYear:1981 endYear:1995];
	[self addAutoModel:@"Mondeo Metrostar" ofAuto:autoId logo:logoId startYear:2000 endYear:2006];
	[self addAutoModel:@"Mustang" ofAuto:autoId logo:logoId startYear:1964 endYear:0];
	[self addAutoModel:@"Orion" ofAuto:autoId logo:logoId startYear:1983 endYear:1993];
	[self addAutoModel:@"Pampa" ofAuto:autoId logo:logoId startYear:1982 endYear:1997];
	[self addAutoModel:@"Probe" ofAuto:autoId logo:logoId startYear:1989 endYear:1997];
	[self addAutoModel:@"Pronto" ofAuto:autoId logo:logoId startYear:1961 endYear:0];
	[self addAutoModel:@"Pulsar" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Puma" ofAuto:autoId logo:logoId startYear:1997 endYear:2001];
	[self addAutoModel:@"Scorpio" ofAuto:autoId logo:logoId startYear:1985 endYear:1999];
	[self addAutoModel:@"Sierra" ofAuto:autoId logo:logoId startYear:1983 endYear:1992];
	[self addAutoModel:@"Special" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"SportKa" ofAuto:autoId logo:logoId startYear:2003 endYear:2006];
	[self addAutoModel:@"Standard" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"StreetKa" ofAuto:autoId logo:logoId startYear:2003 endYear:2006];
	[self addAutoModel:@"Taurus" ofAuto:autoId logo:logoId startYear:1986 endYear:-1];
	[self addAutoModel:@"Telstar" ofAuto:autoId logo:logoId startYear:1983 endYear:1999];
	[self addAutoModel:@"Tempo" ofAuto:autoId logo:logoId startYear:1984 endYear:1994];
	[self addAutoModel:@"Thunderbird" ofAuto:autoId logo:logoId startYear:2002 endYear:2005];
	[self addAutoModel:@"Verona" ofAuto:autoId logo:logoId startYear:1989 endYear:2000];
	[self addAutoModel:@"Versailles" ofAuto:autoId logo:logoId startYear:1992 endYear:1994];
	[self addAutoModel:@"ZX2" ofAuto:autoId logo:logoId startYear:1998 endYear:2003];
	
	modelId = [self addAutoModel:@"Race and rally" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
		[self addAutoSubmodel:@"C100" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"GT40" ofModel:modelId logo:logoId startYear:1964 endYear:1969];
		[self addAutoSubmodel:@"GT70" ofModel:modelId logo:logoId startYear:1970 endYear:-1];
		[self addAutoSubmodel:@"Escort RS 1700T" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Escort RS Cosworth" ofModel:modelId logo:logoId startYear:1992 endYear:1996];
		[self addAutoSubmodel:@"Fiesta R5" ofModel:modelId logo:logoId startYear:2013 endYear:0];
		[self addAutoSubmodel:@"Fiesta RS WRC" ofModel:modelId logo:logoId startYear:2011 endYear:0];
		[self addAutoSubmodel:@"Focus RS WRC" ofModel:modelId logo:logoId startYear:1999 endYear:0];
		[self addAutoSubmodel:@"Mustang GTP" ofModel:modelId logo:logoId startYear:1983 endYear:0];
		[self addAutoSubmodel:@"Mustang Maxum GTP" ofModel:modelId logo:logoId startYear:1987 endYear:0];
        [self addAutoSubmodel:@"Mustang Probe" ofModel:modelId logo:logoId startYear:1968 endYear:1969];
		[self addAutoSubmodel:@"P68" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"P69" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"RS200" ofModel:modelId logo:logoId startYear:1984 endYear:1986];
		[self addAutoSubmodel:@"Sierra RS Cosworth" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
	modelId = [self addAutoModel:@"Vans" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
		[self addAutoSubmodel:@"E-Series" ofModel:modelId logo:logoId startYear:1961 endYear:2013];
		[self addAutoSubmodel:@"Econoline" ofModel:modelId logo:logoId startYear:1978 endYear:2013];
		[self addAutoSubmodel:@"Supervan" ofModel:modelId logo:logoId startYear:1971 endYear:2007];
		[self addAutoSubmodel:@"Thames 300E" ofModel:modelId logo:logoId startYear:1954 endYear:1961];
		[self addAutoSubmodel:@"Thames 400E" ofModel:modelId logo:logoId startYear:1957 endYear:1965];
        [self addAutoSubmodel:@"Tourneo" ofModel:modelId logo:logoId startYear:1995 endYear:0];
		[self addAutoSubmodel:@"Transit" ofModel:modelId logo:logoId startYear:1965 endYear:0];
    }
	modelId = [self addAutoModel:@"MPVs" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
		[self addAutoSubmodel:@"C-MAX" ofModel:modelId logo:logoId startYear:2007 endYear:0];
		[self addAutoSubmodel:@"S-Max" ofModel:modelId logo:logoId startYear:2008 endYear:0];
		[self addAutoSubmodel:@"Galaxy" ofModel:modelId logo:logoId startYear:1995 endYear:0];
		[self addAutoSubmodel:@"Windstar" ofModel:modelId logo:logoId startYear:1995 endYear:2004];
        [self addAutoSubmodel:@"Aerostar" ofModel:modelId logo:logoId startYear:1986 endYear:1997];
		[self addAutoSubmodel:@"Freestar" ofModel:modelId logo:logoId startYear:2004 endYear:2007];
    }
	modelId = [self addAutoModel:@"SUVs" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
		[self addAutoSubmodel:@"Bronco" ofModel:modelId logo:logoId startYear:1966 endYear:1996];
		[self addAutoSubmodel:@"Bronco II" ofModel:modelId logo:logoId startYear:1984 endYear:1990];
		[self addAutoSubmodel:@"Ecosport" ofModel:modelId logo:logoId startYear:2004 endYear:0];
		[self addAutoSubmodel:@"Edge" ofModel:modelId logo:logoId startYear:2007 endYear:0];
        [self addAutoSubmodel:@"Escape" ofModel:modelId logo:logoId startYear:2001 endYear:0];
		[self addAutoSubmodel:@"Everest" ofModel:modelId logo:logoId startYear:2003 endYear:0];
		[self addAutoSubmodel:@"Excursion" ofModel:modelId logo:logoId startYear:2000 endYear:2005];
		[self addAutoSubmodel:@"Endeavour" ofModel:modelId logo:logoId startYear:2002 endYear:0];
		[self addAutoSubmodel:@"Expedition" ofModel:modelId logo:logoId startYear:1997 endYear:0];
		[self addAutoSubmodel:@"Expedition EL/Max" ofModel:modelId logo:logoId startYear:2007 endYear:0];
        [self addAutoSubmodel:@"Explorer" ofModel:modelId logo:logoId startYear:1991 endYear:0];
		[self addAutoSubmodel:@"Fiera" ofModel:modelId logo:logoId startYear:1972 endYear:1984];
		[self addAutoSubmodel:@"Flex" ofModel:modelId logo:logoId startYear:2009 endYear:0];
		[self addAutoSubmodel:@"Freestyle" ofModel:modelId logo:logoId startYear:2005 endYear:2007];
		[self addAutoSubmodel:@"Fusion" ofModel:modelId logo:logoId startYear:2002 endYear:2012];
		[self addAutoSubmodel:@"Kuga" ofModel:modelId logo:logoId startYear:2008 endYear:0];
        [self addAutoSubmodel:@"Raider" ofModel:modelId logo:logoId startYear:1985 endYear:1998];
		[self addAutoSubmodel:@"Taurus X" ofModel:modelId logo:logoId startYear:2008 endYear:2009];
		[self addAutoSubmodel:@"Territory" ofModel:modelId logo:logoId startYear:2004 endYear:0];
    }
	modelId = [self addAutoModel:@"Trucks" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
		[self addAutoSubmodel:@"A-Series" ofModel:modelId logo:logoId startYear:0000 endYear:0000];
		[self addAutoSubmodel:@"B-Series" ofModel:modelId logo:logoId startYear:1948 endYear:1998];
		[self addAutoSubmodel:@"Bronco" ofModel:modelId logo:logoId startYear:1966 endYear:1996];
		[self addAutoSubmodel:@"C-Series" ofModel:modelId logo:logoId startYear:1957 endYear:1990];
        [self addAutoSubmodel:@"CL-Series" ofModel:modelId logo:logoId startYear:1978 endYear:1991];
		[self addAutoSubmodel:@"Cargo" ofModel:modelId logo:logoId startYear:1981 endYear:0];
		[self addAutoSubmodel:@"Courier" ofModel:modelId logo:logoId startYear:1952 endYear:1960];
		[self addAutoSubmodel:@"Courier" ofModel:modelId logo:logoId startYear:1972 endYear:1982];
		[self addAutoSubmodel:@"Courier" ofModel:modelId logo:logoId startYear:1991 endYear:2002];
		[self addAutoSubmodel:@"Courier" ofModel:modelId logo:logoId startYear:1979 endYear:0];
        [self addAutoSubmodel:@"Courier" ofModel:modelId logo:logoId startYear:1998 endYear:0];
		[self addAutoSubmodel:@"D-series" ofModel:modelId logo:logoId startYear:1965 endYear:1981];
		[self addAutoSubmodel:@"Explorer Sport" ofModel:modelId logo:logoId startYear:2001 endYear:0];
		[self addAutoSubmodel:@"F-Series" ofModel:modelId logo:logoId startYear:1948 endYear:0];
		[self addAutoSubmodel:@"Freighter" ofModel:modelId logo:logoId startYear:0000 endYear:0000];
		[self addAutoSubmodel:@"H-Series" ofModel:modelId logo:logoId startYear:1961 endYear:1965];
        [self addAutoSubmodel:@"Jeep" ofModel:modelId logo:logoId startYear:1941 endYear:1945];
		[self addAutoSubmodel:@"L-Series" ofModel:modelId logo:logoId startYear:1970 endYear:1998];
		[self addAutoSubmodel:@"LCF" ofModel:modelId logo:logoId startYear:2006 endYear:0];
		[self addAutoSubmodel:@"Lobo" ofModel:modelId logo:logoId startYear:1948 endYear:-1];
		[self addAutoSubmodel:@"Mainline" ofModel:modelId logo:logoId startYear:1952 endYear:1958];
		[self addAutoSubmodel:@"Model 51" ofModel:modelId logo:logoId startYear:1935 endYear:1936];
        [self addAutoSubmodel:@"Model 59" ofModel:modelId logo:logoId startYear:1945 endYear:-1];
		[self addAutoSubmodel:@"Model 69" ofModel:modelId logo:logoId startYear:1946 endYear:-1];
		[self addAutoSubmodel:@"Model 75" ofModel:modelId logo:logoId startYear:1937 endYear:-1];
		[self addAutoSubmodel:@"Model 79" ofModel:modelId logo:logoId startYear:1947 endYear:-1];
		[self addAutoSubmodel:@"Model 81" ofModel:modelId logo:logoId startYear:1938 endYear:-1];
		[self addAutoSubmodel:@"Model 91" ofModel:modelId logo:logoId startYear:1939 endYear:-1];
        [self addAutoSubmodel:@"Model 99" ofModel:modelId logo:logoId startYear:1939 endYear:-1];
		[self addAutoSubmodel:@"Model AA" ofModel:modelId logo:logoId startYear:1927 endYear:1931];
		[self addAutoSubmodel:@"Model BB" ofModel:modelId logo:logoId startYear:1932 endYear:1934];
		[self addAutoSubmodel:@"Model TT" ofModel:modelId logo:logoId startYear:1925 endYear:1927];
		[self addAutoSubmodel:@"N-Series" ofModel:modelId logo:logoId startYear:1962 endYear:1969];
		[self addAutoSubmodel:@"P-Series" ofModel:modelId logo:logoId startYear:0000 endYear:0000];
        [self addAutoSubmodel:@"Panel truck" ofModel:modelId logo:logoId startYear:0000 endYear:0000];
		[self addAutoSubmodel:@"R-Series" ofModel:modelId logo:logoId startYear:0000 endYear:0000];
		[self addAutoSubmodel:@"Ranchero" ofModel:modelId logo:logoId startYear:1957 endYear:1979];
		[self addAutoSubmodel:@"Ranchero Rio Grande" ofModel:modelId logo:logoId startYear:1969 endYear:-1];
		[self addAutoSubmodel:@"Ranger" ofModel:modelId logo:logoId startYear:1983 endYear:2012];
		[self addAutoSubmodel:@"Ranger" ofModel:modelId logo:logoId startYear:2006 endYear:0];
        [self addAutoSubmodel:@"Ranger EV" ofModel:modelId logo:logoId startYear:1998 endYear:2004];
		[self addAutoSubmodel:@"Ranger (T6)" ofModel:modelId logo:logoId startYear:2011 endYear:0];
		[self addAutoSubmodel:@"SVT F-150 Raptor" ofModel:modelId logo:logoId startYear:0000 endYear:0000];
		[self addAutoSubmodel:@"Super Duty" ofModel:modelId logo:logoId startYear:1999 endYear:0];
		[self addAutoSubmodel:@"T-Series" ofModel:modelId logo:logoId startYear:2012 endYear:0];
		[self addAutoSubmodel:@"Transcontinental" ofModel:modelId logo:logoId startYear:1975 endYear:1983];
        [self addAutoSubmodel:@"Transit" ofModel:modelId logo:logoId startYear:1965 endYear:0];
		[self addAutoSubmodel:@"Vanette" ofModel:modelId logo:logoId startYear:1946 endYear:1965];
		[self addAutoSubmodel:@"W-Series" ofModel:modelId logo:logoId startYear:1966 endYear:1977];
    }
	modelId = [self addAutoModel:@"Tractors" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
		[self addAutoSubmodel:@"Fordson" ofModel:modelId logo:logoId startYear:1917 endYear:1964];
		[self addAutoSubmodel:@"N Series" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"NAA Series" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Golden Jubilee" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"600 Series" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Workmaster" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Powermaster" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
	modelId = [self addAutoModel:@"Buses" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
		[self addAutoSubmodel:@"Transit bus" ofModel:modelId logo:logoId startYear:1940 endYear:1949];
		[self addAutoSubmodel:@"09-B" ofModel:modelId logo:logoId startYear:1939 endYear:1940];
		[self addAutoSubmodel:@"19-B" ofModel:modelId logo:logoId startYear:1940 endYear:1941];
		[self addAutoSubmodel:@"29-B" ofModel:modelId logo:logoId startYear:1941 endYear:1942];
        [self addAutoSubmodel:@"49-B" ofModel:modelId logo:logoId startYear:1944 endYear:-1];
		[self addAutoSubmodel:@"59-B" ofModel:modelId logo:logoId startYear:1945 endYear:1947];
		[self addAutoSubmodel:@"69-B" ofModel:modelId logo:logoId startYear:1946 endYear:1947];
		[self addAutoSubmodel:@"79-B" ofModel:modelId logo:logoId startYear:1945 endYear:1947];
		[self addAutoSubmodel:@"School Bus" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Transit" ofModel:modelId logo:logoId startYear:2007 endYear:0];
		[self addAutoSubmodel:@"Minibus F450" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Minibus E350" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Econoline 350" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"E450 Super Duty" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"MB Series" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Super Duty" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"MBC Series" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Commercial Bus" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Specialty Trolley" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Suburban Bus" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"G997" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"R-Series" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Trader" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Hawke" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"ET7" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"19B" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"29B" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"72B" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"ET7 Aqualina" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
	modelId = [self addAutoModel:@"Military" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    {
		[self addAutoSubmodel:@"Model-T 1917" ofModel:modelId logo:logoId startYear:1917 endYear:-1];
		[self addAutoSubmodel:@"3-Ton M1918" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"M1 Bomb Service Truck" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"GTB" ofModel:modelId logo:logoId startYear:0 endYear:0];
        [self addAutoSubmodel:@"Burma Jeep" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"GPW" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"GPA" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"M151 MUTT" ofModel:modelId logo:logoId startYear:0 endYear:0];
    }
	modelId = [self addAutoModel:@"Concept & movie" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
		[self addAutoSubmodel:@"021C" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"24.7 Coupe" ofModel:modelId logo:logoId startYear:2000 endYear:-1];
		[self addAutoSubmodel:@"24.7 Pickup" ofModel:modelId logo:logoId startYear:2000 endYear:-1];
		[self addAutoSubmodel:@"24.7 Wagon" ofModel:modelId logo:logoId startYear:2000 endYear:-1];
        [self addAutoSubmodel:@"4-Trac" ofModel:modelId logo:logoId startYear:2006 endYear:-1];
		[self addAutoSubmodel:@"427" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Aerostar" ofModel:modelId logo:logoId startYear:1984 endYear:-1];
		[self addAutoSubmodel:@"Airstream" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"Allegro" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
        [self addAutoSubmodel:@"Allegro II" ofModel:modelId logo:logoId startYear:1967 endYear:-1];
		[self addAutoSubmodel:@"Alpe" ofModel:modelId logo:logoId startYear:1996 endYear:-1];
		[self addAutoSubmodel:@"APV" ofModel:modelId logo:logoId startYear:1984 endYear:-1];
		[self addAutoSubmodel:@"Arioso" ofModel:modelId logo:logoId startYear:1994 endYear:-1];
		[self addAutoSubmodel:@"Atlas" ofModel:modelId logo:logoId startYear:2013 endYear:-1];
        [self addAutoSubmodel:@"Avantgarde" ofModel:modelId logo:logoId startYear:1981 endYear:-1];
		[self addAutoSubmodel:@"Aurora" ofModel:modelId logo:logoId startYear:1964 endYear:-1];
		[self addAutoSubmodel:@"Aurora II" ofModel:modelId logo:logoId startYear:1969 endYear:-1];
		[self addAutoSubmodel:@"B-Max" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"Barchetta" ofModel:modelId logo:logoId startYear:1983 endYear:-1];
        [self addAutoSubmodel:@"Brezza" ofModel:modelId logo:logoId startYear:1982 endYear:-1];
		
		[self addAutoSubmodel:@"Bronco" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
		[self addAutoSubmodel:@"Bronco DM-1" ofModel:modelId logo:logoId startYear:1988 endYear:-1];
		[self addAutoSubmodel:@"Bronco Dune Duster" ofModel:modelId logo:logoId startYear:1966 endYear:1968];
		[self addAutoSubmodel:@"Bronco Wildflower" ofModel:modelId logo:logoId startYear:1971 endYear:-1];
        [self addAutoSubmodel:@"Bronco Montana Lobo" ofModel:modelId logo:logoId startYear:1981 endYear:-1];
		[self addAutoSubmodel:@"Carousel" ofModel:modelId logo:logoId startYear:1972 endYear:-1];
		[self addAutoSubmodel:@"Cobra 230 ME" ofModel:modelId logo:logoId startYear:1986 endYear:-1];
		[self addAutoSubmodel:@"Cockpit" ofModel:modelId logo:logoId startYear:1982 endYear:-1];
		[self addAutoSubmodel:@"Coins" ofModel:modelId logo:logoId startYear:1974 endYear:-1];
        [self addAutoSubmodel:@"Comuta" ofModel:modelId logo:logoId startYear:1967 endYear:-1];
		[self addAutoSubmodel:@"Connecta" ofModel:modelId logo:logoId startYear:1992 endYear:-1];
		[self addAutoSubmodel:@"Contour" ofModel:modelId logo:logoId startYear:1991 endYear:-1];
		[self addAutoSubmodel:@"Corrida" ofModel:modelId logo:logoId startYear:1978 endYear:-1];
		[self addAutoSubmodel:@"Cougar" ofModel:modelId logo:logoId startYear:1956 endYear:-1];
        [self addAutoSubmodel:@"Cougar 406" ofModel:modelId logo:logoId startYear:1962 endYear:-1];
		[self addAutoSubmodel:@"Cougar II" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		[self addAutoSubmodel:@"DePaolo" ofModel:modelId logo:logoId startYear:1958 endYear:-1];
		[self addAutoSubmodel:@"e.go" ofModel:modelId logo:logoId startYear:2000 endYear:-1];
		[self addAutoSubmodel:@"EcoSport" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
        [self addAutoSubmodel:@"Econoline Apartment" ofModel:modelId logo:logoId startYear:1966 endYear:-1];
		
		[self addAutoSubmodel:@"Econoline Kilimanjaro" ofModel:modelId logo:logoId startYear:1970 endYear:-1];
		[self addAutoSubmodel:@"Eltec" ofModel:modelId logo:logoId startYear:1985 endYear:-1];
		[self addAutoSubmodel:@"Equator" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"Evos" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
        [self addAutoSubmodel:@"EX" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"Explorer America" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"Explorer Drifter" ofModel:modelId logo:logoId startYear:1992 endYear:-1];
		[self addAutoSubmodel:@"Explorer Sportsman" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"Explorer SUV" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
        [self addAutoSubmodel:@"F-150 Lightning Rod" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"F-150 Street" ofModel:modelId logo:logoId startYear:1990 endYear:-1];
		[self addAutoSubmodel:@"F-250 Super Chief" ofModel:modelId logo:logoId startYear:2006 endYear:-1];
		[self addAutoSubmodel:@"FAB1" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Faction" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
        [self addAutoSubmodel:@"Fairlane" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"Fiera" ofModel:modelId logo:logoId startYear:1968 endYear:-1];
		[self addAutoSubmodel:@"Fiesta Bebop" ofModel:modelId logo:logoId startYear:1990 endYear:-1];
		[self addAutoSubmodel:@"Fiesta Fantasy" ofModel:modelId logo:logoId startYear:1978 endYear:-1];
		[self addAutoSubmodel:@"Fiesta GTX" ofModel:modelId logo:logoId startYear:1980 endYear:-1];
        [self addAutoSubmodel:@"Fiesta ST" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		
		[self addAutoSubmodel:@"Fiesta Tuareg" ofModel:modelId logo:logoId startYear:1978 endYear:-1];
		[self addAutoSubmodel:@"Fiesta Urba" ofModel:modelId logo:logoId startYear:1989 endYear:-1];
		[self addAutoSubmodel:@"Flair" ofModel:modelId logo:logoId startYear:1982 endYear:-1];
		[self addAutoSubmodel:@"Flashback" ofModel:modelId logo:logoId startYear:1975 endYear:-1];
        [self addAutoSubmodel:@"Focus" ofModel:modelId logo:logoId startYear:1992 endYear:-1];
		[self addAutoSubmodel:@"Focus MA" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
		[self addAutoSubmodel:@"Focus Vignale" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
		[self addAutoSubmodel:@"Forty-Nine" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"FX-Atmos" ofModel:modelId logo:logoId startYear:1954 endYear:-1];
        [self addAutoSubmodel:@"Galaxie GT A Go-Go" ofModel:modelId logo:logoId startYear:1966 endYear:-1];
		[self addAutoSubmodel:@"HFX Aerostar" ofModel:modelId logo:logoId startYear:1987 endYear:-1];
		[self addAutoSubmodel:@"GloCar" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Granada Altair" ofModel:modelId logo:logoId startYear:1980 endYear:-1];
		[self addAutoSubmodel:@"GTK" ofModel:modelId logo:logoId startYear:1979 endYear:-1];
        [self addAutoSubmodel:@"GT-P" ofModel:modelId logo:logoId startYear:1966 endYear:-1];
		[self addAutoSubmodel:@"GT40" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
		[self addAutoSubmodel:@"GT-70" ofModel:modelId logo:logoId startYear:1971 endYear:-1];
		[self addAutoSubmodel:@"GT80" ofModel:modelId logo:logoId startYear:1978 endYear:-1];
		[self addAutoSubmodel:@"GT90" ofModel:modelId logo:logoId startYear:1995 endYear:-1];
        [self addAutoSubmodel:@"Gyron" ofModel:modelId logo:logoId startYear:1961 endYear:-1];
		
		[self addAutoSubmodel:@"IndiGo" ofModel:modelId logo:logoId startYear:1996 endYear:-1];
		[self addAutoSubmodel:@"Interceptor" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"Iosis" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"Iosis X" ofModel:modelId logo:logoId startYear:2006 endYear:-1];
        [self addAutoSubmodel:@"Iosis MAX" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
		[self addAutoSubmodel:@"La Galaxie" ofModel:modelId logo:logoId startYear:1958 endYear:-1];
		[self addAutoSubmodel:@"La Tosca" ofModel:modelId logo:logoId startYear:1955 endYear:-1];
		[self addAutoSubmodel:@"Libre" ofModel:modelId logo:logoId startYear:1998 endYear:-1];
		[self addAutoSubmodel:@"LTD Black Pearl" ofModel:modelId logo:logoId startYear:1966 endYear:-1];
        [self addAutoSubmodel:@"LTD Berline I" ofModel:modelId logo:logoId startYear:1971 endYear:-1];
		[self addAutoSubmodel:@"LTD Berline II" ofModel:modelId logo:logoId startYear:1972 endYear:-1];
		[self addAutoSubmodel:@"LTD Exp. Safety" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
		[self addAutoSubmodel:@"Lynx" ofModel:modelId logo:logoId startYear:1996 endYear:-1];
		[self addAutoSubmodel:@"Mach I Levacar" ofModel:modelId logo:logoId startYear:1959 endYear:-1];
        [self addAutoSubmodel:@"Mach 2" ofModel:modelId logo:logoId startYear:1967 endYear:-1];
		[self addAutoSubmodel:@"Magic Cruiser" ofModel:modelId logo:logoId startYear:1966 endYear:-1];
		[self addAutoSubmodel:@"Maverick Runabout" ofModel:modelId logo:logoId startYear:1970 endYear:-1];
		[self addAutoSubmodel:@"Maverick Estate Coupe" ofModel:modelId logo:logoId startYear:1971 endYear:-1];
		[self addAutoSubmodel:@"Maverick LTD" ofModel:modelId logo:logoId startYear:1972 endYear:-1];
        [self addAutoSubmodel:@"Maxima" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		
		[self addAutoSubmodel:@"Maya" ofModel:modelId logo:logoId startYear:1984 endYear:-1];
		[self addAutoSubmodel:@"Megastar" ofModel:modelId logo:logoId startYear:1977 endYear:-1];
		[self addAutoSubmodel:@"Megastar II" ofModel:modelId logo:logoId startYear:1978 endYear:-1];
		[self addAutoSubmodel:@"Microsport" ofModel:modelId logo:logoId startYear:1978 endYear:-1];
        [self addAutoSubmodel:@"Mighty F-350 Tonka" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
		[self addAutoSubmodel:@"Model U" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Muroc" ofModel:modelId logo:logoId startYear:1950 endYear:-1];
		[self addAutoSubmodel:@"Mustang" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
		[self addAutoSubmodel:@"Mustang I" ofModel:modelId logo:logoId startYear:1962 endYear:-1];
        [self addAutoSubmodel:@"Mustang II" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		[self addAutoSubmodel:@"Mustang II Sportiva" ofModel:modelId logo:logoId startYear:1974 endYear:-1];
		[self addAutoSubmodel:@"Mustang IMSA" ofModel:modelId logo:logoId startYear:1980 endYear:-1];
		[self addAutoSubmodel:@"Mustang Mach I" ofModel:modelId logo:logoId startYear:1965 endYear:-1];
		[self addAutoSubmodel:@"Mustang Mach II" ofModel:modelId logo:logoId startYear:1970 endYear:-1];
        [self addAutoSubmodel:@"Mustang Mach III" ofModel:modelId logo:logoId startYear:1993 endYear:-1];
		[self addAutoSubmodel:@"Mustang Milano" ofModel:modelId logo:logoId startYear:1970 endYear:-1];
		[self addAutoSubmodel:@"Mustang RSX" ofModel:modelId logo:logoId startYear:1981 endYear:-1];
		[self addAutoSubmodel:@"Mustang PPG" ofModel:modelId logo:logoId startYear:1984 endYear:-1];
		[self addAutoSubmodel:@"Mustela II" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
        [self addAutoSubmodel:@"Mystere" ofModel:modelId logo:logoId startYear:1955 endYear:-1];
		
		[self addAutoSubmodel:@"Navarre" ofModel:modelId logo:logoId startYear:1980 endYear:-1];
		[self addAutoSubmodel:@"Nucleon" ofModel:modelId logo:logoId startYear:1958 endYear:-1];
		[self addAutoSubmodel:@"P2000" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"Pinto Sportiva" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
        [self addAutoSubmodel:@"Plastic Car" ofModel:modelId logo:logoId startYear:1941 endYear:-1];
		[self addAutoSubmodel:@"Poccar" ofModel:modelId logo:logoId startYear:1981 endYear:-1];
		[self addAutoSubmodel:@"Powerforce" ofModel:modelId logo:logoId startYear:1997 endYear:-1];
		[self addAutoSubmodel:@"Powerstroke" ofModel:modelId logo:logoId startYear:1994 endYear:-1];
		[self addAutoSubmodel:@"Prima" ofModel:modelId logo:logoId startYear:1976 endYear:-1];
        [self addAutoSubmodel:@"Probe I" ofModel:modelId logo:logoId startYear:1979 endYear:-1];
		[self addAutoSubmodel:@"Probe II" ofModel:modelId logo:logoId startYear:1980 endYear:-1];
		[self addAutoSubmodel:@"Probe III" ofModel:modelId logo:logoId startYear:1981 endYear:-1];
		[self addAutoSubmodel:@"Probe IV" ofModel:modelId logo:logoId startYear:1982 endYear:-1];
		[self addAutoSubmodel:@"Probe V" ofModel:modelId logo:logoId startYear:1985 endYear:-1];
        [self addAutoSubmodel:@"Prodigy" ofModel:modelId logo:logoId startYear:2000 endYear:-1];
		[self addAutoSubmodel:@"Prototype" ofModel:modelId logo:logoId startYear:1989 endYear:-1];
		[self addAutoSubmodel:@"Ranger II" ofModel:modelId logo:logoId startYear:1967 endYear:-1];
		[self addAutoSubmodel:@"Ranger III" ofModel:modelId logo:logoId startYear:1968 endYear:-1];
		[self addAutoSubmodel:@"Ranger Force 5" ofModel:modelId logo:logoId startYear:1991 endYear:-1];
        [self addAutoSubmodel:@"Ranger Jukebox" ofModel:modelId logo:logoId startYear:1993 endYear:-1];
		
		[self addAutoSubmodel:@"Reflex" ofModel:modelId logo:logoId startYear:2006 endYear:-1];
		[self addAutoSubmodel:@"SAV" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"Saetta" ofModel:modelId logo:logoId startYear:1996 endYear:-1];
		[self addAutoSubmodel:@"Saguaro" ofModel:modelId logo:logoId startYear:1988 endYear:-1];
        [self addAutoSubmodel:@"Seattle-ite XXI" ofModel:modelId logo:logoId startYear:1962 endYear:-1];
		[self addAutoSubmodel:@"Shelby Cobra" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
		[self addAutoSubmodel:@"Shelby GR-1" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
		[self addAutoSubmodel:@"Shoccc Wave" ofModel:modelId logo:logoId startYear:1990 endYear:-1];
		[self addAutoSubmodel:@"Shuttler" ofModel:modelId logo:logoId startYear:1981 endYear:-1];
        [self addAutoSubmodel:@"Splash" ofModel:modelId logo:logoId startYear:1988 endYear:-1];
		[self addAutoSubmodel:@"Sport-Trac" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"Start" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"Surf" ofModel:modelId logo:logoId startYear:1990 endYear:-1];
		[self addAutoSubmodel:@"Super Chief" ofModel:modelId logo:logoId startYear:2006 endYear:-1];
        [self addAutoSubmodel:@"Super Cobra" ofModel:modelId logo:logoId startYear:1969 endYear:-1];
		[self addAutoSubmodel:@"Synergy 2010" ofModel:modelId logo:logoId startYear:1996 endYear:-1];
		[self addAutoSubmodel:@"Synthesis 2010" ofModel:modelId logo:logoId startYear:1993 endYear:-1];
		[self addAutoSubmodel:@"SYNUS" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"Syrtis" ofModel:modelId logo:logoId startYear:1953 endYear:-1];
        [self addAutoSubmodel:@"Techna" ofModel:modelId logo:logoId startYear:1968 endYear:-1];
		
		[self addAutoSubmodel:@"TH!NK" ofModel:modelId logo:logoId startYear:0 endYear:0];
		[self addAutoSubmodel:@"Thunderbird Italien" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		[self addAutoSubmodel:@"Thunderbird Golden Palomino" ofModel:modelId logo:logoId startYear:1964 endYear:-1];
		[self addAutoSubmodel:@"Thunderbird Town Landau" ofModel:modelId logo:logoId startYear:1965 endYear:-1];
        [self addAutoSubmodel:@"Thunderbird Saturn I" ofModel:modelId logo:logoId startYear:1968 endYear:-1];
		[self addAutoSubmodel:@"Thunderbird Saturn II" ofModel:modelId logo:logoId startYear:1969 endYear:-1];
		[self addAutoSubmodel:@"Thunderbird PPG" ofModel:modelId logo:logoId startYear:1984 endYear:-1];
		[self addAutoSubmodel:@"Topaz" ofModel:modelId logo:logoId startYear:1982 endYear:-1];
		[self addAutoSubmodel:@"Torino Machete Style I" ofModel:modelId logo:logoId startYear:1968 endYear:-1];
        [self addAutoSubmodel:@"Torino Machete Style II" ofModel:modelId logo:logoId startYear:1969 endYear:-1];
		[self addAutoSubmodel:@"Transit Connect Taxi" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"Tridon" ofModel:modelId logo:logoId startYear:1971 endYear:-1];
		[self addAutoSubmodel:@"Trio" ofModel:modelId logo:logoId startYear:1983 endYear:-1];
		[self addAutoSubmodel:@"Turbine Truck" ofModel:modelId logo:logoId startYear:1964 endYear:-1];
        [self addAutoSubmodel:@"Twister" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		[self addAutoSubmodel:@"Urban Car" ofModel:modelId logo:logoId startYear:1975 endYear:-1];
		[self addAutoSubmodel:@"Urby" ofModel:modelId logo:logoId startYear:1985 endYear:-1];
		[self addAutoSubmodel:@"Vertrek" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"Via" ofModel:modelId logo:logoId startYear:1989 endYear:-1];
        [self addAutoSubmodel:@"Vivace" ofModel:modelId logo:logoId startYear:1996 endYear:-1];
		
		[self addAutoSubmodel:@"Vignale Mustang" ofModel:modelId logo:logoId startYear:1984 endYear:-1];
		[self addAutoSubmodel:@"Vignale TSX-4" ofModel:modelId logo:logoId startYear:1984 endYear:-1];
		[self addAutoSubmodel:@"Vignale TSX-6" ofModel:modelId logo:logoId startYear:1986 endYear:-1];
		[self addAutoSubmodel:@"Visos" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
        [self addAutoSubmodel:@"Vega " ofModel:modelId logo:logoId startYear:1953 endYear:-1];
		[self addAutoSubmodel:@"Verve" ofModel:modelId logo:logoId startYear:2007 endYear:2008];
		[self addAutoSubmodel:@"Volante" ofModel:modelId logo:logoId startYear:1958 endYear:-1];
		[self addAutoSubmodel:@"X-100" ofModel:modelId logo:logoId startYear:1953 endYear:-1];
		[self addAutoSubmodel:@"X-1000" ofModel:modelId logo:logoId startYear:1958 endYear:-1];
        [self addAutoSubmodel:@"X2000" ofModel:modelId logo:logoId startYear:1958 endYear:-1];
		[self addAutoSubmodel:@"XP Bordinat Cobra" ofModel:modelId logo:logoId startYear:1965 endYear:-1];
		[self addAutoSubmodel:@"Zag" ofModel:modelId logo:logoId startYear:1990 endYear:-1];
		[self addAutoSubmodel:@"Zig" ofModel:modelId logo:logoId startYear:1990 endYear:-1];
    }
#pragma mark |---- GMC
    logoId = [self addLogo:@"gmc_256.png"];
    autoId = [self addAuto:@"GMC" country:countryId logoAsName:logoId independentId:GMC];
    
    [self addAutoModel:@"Acadia" ofAuto:autoId logo:logoId startYear:2006 endYear:0];
	[self addAutoModel:@"B-Series" ofAuto:autoId logo:logoId startYear:1966 endYear:2003];
	[self addAutoModel:@"Brigadier" ofAuto:autoId logo:logoId startYear:1978 endYear:1988];
	[self addAutoModel:@"Sprint" ofAuto:autoId logo:logoId startYear:1971 endYear:1977];
	[self addAutoModel:@"Caballero" ofAuto:autoId logo:logoId startYear:1978 endYear:1987];
	[self addAutoModel:@"Canyon" ofAuto:autoId logo:logoId startYear:2004 endYear:2012];
	[self addAutoModel:@"CCKW" ofAuto:autoId logo:logoId startYear:0000 endYear:0];
	[self addAutoModel:@"Chevette" ofAuto:autoId logo:logoId startYear:1980 endYear:1995];
	[self addAutoModel:@"Denali" ofAuto:autoId logo:logoId startYear:1998 endYear:0];
	[self addAutoModel:@"Denali XT" ofAuto:autoId logo:logoId startYear:2008 endYear:-1];
	[self addAutoModel:@"DUKW" ofAuto:autoId logo:logoId startYear:0000 endYear:0];
	[self addAutoModel:@"Envoy" ofAuto:autoId logo:logoId startYear:1998 endYear:2009];
	[self addAutoModel:@"Envoy XL" ofAuto:autoId logo:logoId startYear:1998 endYear:2009];
	[self addAutoModel:@"Granite" ofAuto:autoId logo:logoId startYear:2010 endYear:-1];
	[self addAutoModel:@"Graphyte Hybrid" ofAuto:autoId logo:logoId startYear:2005 endYear:-1];
	[self addAutoModel:@"K5 Jimmy" ofAuto:autoId logo:logoId startYear:1968 endYear:2001];
	[self addAutoModel:@"MagnaVan" ofAuto:autoId logo:logoId startYear:0000 endYear:0];
	[self addAutoModel:@"Motorhome" ofAuto:autoId logo:logoId startYear:1972 endYear:1978];
	[self addAutoModel:@"S-15 Jimmy" ofAuto:autoId logo:logoId startYear:1983 endYear:2005];
	[self addAutoModel:@"Sierra" ofAuto:autoId logo:logoId startYear:1998 endYear:0];
	
	[self addAutoModel:@"Sonoma" ofAuto:autoId logo:logoId startYear:1982 endYear:0];
	[self addAutoModel:@"Syclone" ofAuto:autoId logo:logoId startYear:1991 endYear:-1];
	[self addAutoModel:@"Terracross" ofAuto:autoId logo:logoId startYear:2001 endYear:-1];
	[self addAutoModel:@"Terradyne" ofAuto:autoId logo:logoId startYear:2000 endYear:-1];
	[self addAutoModel:@"Terrain" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
	[self addAutoModel:@"Topkick" ofAuto:autoId logo:logoId startYear:1980 endYear:2009];
	[self addAutoModel:@"Typhoon" ofAuto:autoId logo:logoId startYear:1992 endYear:1993];
	[self addAutoModel:@"Vandura" ofAuto:autoId logo:logoId startYear:1964 endYear:1996];
	[self addAutoModel:@"Yukon" ofAuto:autoId logo:logoId startYear:1992 endYear:0];
	[self addAutoModel:@"Yukon XL" ofAuto:autoId logo:logoId startYear:1933 endYear:0];
	[self addAutoModel:@"Tahoe" ofAuto:autoId logo:logoId startYear:1995 endYear:0];
#pragma mark |---- Hummer
    logoId = [self addLogo:@"hummer_256.png"];
    autoId = [self addAuto:@"HUMMER" country:countryId logo:logoId independentId:HUMMER];
    
    [self addAutoModel:@"H1" ofAuto:autoId logo:logoId startYear:1992 endYear:2006];
	[self addAutoModel:@"H2" ofAuto:autoId logo:logoId startYear:2003 endYear:2009];
	[self addAutoModel:@"H3" ofAuto:autoId logo:logoId startYear:2005 endYear:2010];
	[self addAutoModel:@"HX" ofAuto:autoId logo:logoId startYear:2008 endYear:-1];
    
#pragma mark |---- Buick
    logoId = [self addLogo:@"buick_256.png"];
    autoId = [self addAuto:@"Buick" country:countryId logo:logoId independentId:BUICK];
    
    [self addAutoModel:@"Allure" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"Apollo" ofAuto:autoId logo:logoId startYear:1973 endYear:1975];
	[self addAutoModel:@"Bengal" ofAuto:autoId logo:logoId startYear:2001 endYear:-1];
	[self addAutoModel:@"Blackhawk" ofAuto:autoId logo:logoId startYear:2001 endYear:-1];
	[self addAutoModel:@"Model B" ofAuto:autoId logo:logoId startYear:1904 endYear:1904];
	[self addAutoModel:@"Sail" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
	[self addAutoModel:@"Le Sabre" ofAuto:autoId logo:logoId startYear:1951 endYear:-1];
	[self addAutoModel:@"Centieme" ofAuto:autoId logo:logoId startYear:2003 endYear:-1];
	[self addAutoModel:@"Centurion" ofAuto:autoId logo:logoId startYear:1971 endYear:1973];
	[self addAutoModel:@"Century" ofAuto:autoId logo:logoId startYear:1936 endYear:2005];
	[self addAutoModel:@"Enclave" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
	[self addAutoModel:@"Encore" ofAuto:autoId logo:logoId startYear:2012 endYear:0];
    
	modelId = [self addAutoModel:@"Electra" ofAuto:autoId logo:logoId startYear:1959 endYear:1990];
	{
		[self addAutoSubmodel:@"Estate" ofModel:modelId logo:logoId startYear:1970 endYear:1990];
	}
	
	[self addAutoModel:@"Estate" ofAuto:autoId logo:logoId startYear:1970 endYear:1990];
	[self addAutoModel:@"GL8" ofAuto:autoId logo:logoId startYear:2000 endYear:0];
	[self addAutoModel:@"GNX" ofAuto:autoId logo:logoId startYear:0000 endYear:0];
	[self addAutoModel:@"Gran Sport" ofAuto:autoId logo:logoId startYear:1965 endYear:1967];
	[self addAutoModel:@"Grand National" ofAuto:autoId logo:logoId startYear:1965 endYear:1967];
	[self addAutoModel:@"GSX" ofAuto:autoId logo:logoId startYear:1970 endYear:1971];
	[self addAutoModel:@"Invicta" ofAuto:autoId logo:logoId startYear:1959 endYear:1963];
	[self addAutoModel:@"LaCrosse" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"LeSabre" ofAuto:autoId logo:logoId startYear:1959 endYear:2005];
	[self addAutoModel:@"Limited" ofAuto:autoId logo:logoId startYear:1936 endYear:1942];
	[self addAutoModel:@"Lucerne" ofAuto:autoId logo:logoId startYear:2006 endYear:2011];
	[self addAutoModel:@"Marquette" ofAuto:autoId logo:logoId startYear:1929 endYear:1931];
	[self addAutoModel:@"Master Six" ofAuto:autoId logo:logoId startYear:1925 endYear:1928];
	[self addAutoModel:@"McLaughlin" ofAuto:autoId logo:logoId startYear:0000 endYear:0];
	[self addAutoModel:@"Opel" ofAuto:autoId logo:logoId startYear:1974 endYear:2000];
	
	modelId = [self addAutoModel:@"Park Avenue" ofAuto:autoId logo:logoId startYear:1990 endYear:0];
	{
		[self addAutoSubmodel:@"Essence" ofModel:modelId logo:logoId startYear:1989 endYear:-1];
	}
	
	[self addAutoModel:@"Rainier" ofAuto:autoId logo:logoId startYear:2004 endYear:2007];
	[self addAutoModel:@"Reatta" ofAuto:autoId logo:logoId startYear:1988 endYear:1991];
	[self addAutoModel:@"Regal" ofAuto:autoId logo:logoId startYear:1973 endYear:0];
	[self addAutoModel:@"T-Type" ofAuto:autoId logo:logoId startYear:1979 endYear:1991];
	[self addAutoModel:@"Rendezvous" ofAuto:autoId logo:logoId startYear:2001 endYear:2007];
	[self addAutoModel:@"Riviera" ofAuto:autoId logo:logoId startYear:1963 endYear:1999];
	[self addAutoModel:@"Roadmaster" ofAuto:autoId logo:logoId startYear:1936 endYear:1996];
	[self addAutoModel:@"Royaum" ofAuto:autoId logo:logoId startYear:0000 endYear:0];
	[self addAutoModel:@"Skyhawk" ofAuto:autoId logo:logoId startYear:1974 endYear:1989];
	[self addAutoModel:@"Skylark" ofAuto:autoId logo:logoId startYear:1953 endYear:1998];
	[self addAutoModel:@"Somerset" ofAuto:autoId logo:logoId startYear:1985 endYear:1987];
	[self addAutoModel:@"Special" ofAuto:autoId logo:logoId startYear:1936 endYear:1969];
	[self addAutoModel:@"Sport Wagon" ofAuto:autoId logo:logoId startYear:1964 endYear:1972];
	[self addAutoModel:@"Standard Coach" ofAuto:autoId logo:logoId startYear:1926 endYear:-1];
	[self addAutoModel:@"Super" ofAuto:autoId logo:logoId startYear:1939 endYear:1958];
	[self addAutoModel:@"Terraza" ofAuto:autoId logo:logoId startYear:2005 endYear:2007];
	[self addAutoModel:@"Velite" ofAuto:autoId logo:logoId startYear:2004 endYear:-1];
	[self addAutoModel:@"Verano" ofAuto:autoId logo:logoId startYear:2011 endYear:0];
	[self addAutoModel:@"Wildcat" ofAuto:autoId logo:logoId startYear:1963 endYear:1970];
	[self addAutoModel:@"Y-Job" ofAuto:autoId logo:logoId startYear:1938 endYear:-1];
#pragma mark |---- Mercury
    logoId = [self addLogo:@"mercury_256.png"];
    autoId = [self addAuto:@"Mercury" country:countryId logo:logoId independentId:MERCURY];
    
    [self addAutoModel:@"M-Series" ofAuto:autoId logo:logoId startYear:1946 endYear:1968];
	[self addAutoModel:@"Bobcat" ofAuto:autoId logo:logoId startYear:1975 endYear:1980];
	[self addAutoModel:@"Comet" ofAuto:autoId logo:logoId startYear:1960 endYear:1977];
	[self addAutoModel:@"S-22" ofAuto:autoId logo:logoId startYear:1961 endYear:1963];
	[self addAutoModel:@"Lynx" ofAuto:autoId logo:logoId startYear:1981 endYear:1987];
	[self addAutoModel:@"Tracer" ofAuto:autoId logo:logoId startYear:1988 endYear:1999];
	[self addAutoModel:@"Zephyr" ofAuto:autoId logo:logoId startYear:1978 endYear:1983];
	[self addAutoModel:@"Topaz" ofAuto:autoId logo:logoId startYear:1984 endYear:1994];
	[self addAutoModel:@"Mystique" ofAuto:autoId logo:logoId startYear:1995 endYear:2000];
	[self addAutoModel:@"Meteor" ofAuto:autoId logo:logoId startYear:1962 endYear:1963];
	[self addAutoModel:@"S-33" ofAuto:autoId logo:logoId startYear:1962 endYear:1963];
	[self addAutoModel:@"Cyclone" ofAuto:autoId logo:logoId startYear:1964 endYear:1972];
	[self addAutoModel:@"Comet" ofAuto:autoId logo:logoId startYear:1966 endYear:1969];
	[self addAutoModel:@"Montego" ofAuto:autoId logo:logoId startYear:1968 endYear:1976];
	[self addAutoModel:@"Monarch" ofAuto:autoId logo:logoId startYear:1975 endYear:1980];
	[self addAutoModel:@"Grand Monarch Ghia" ofAuto:autoId logo:logoId startYear:1975 endYear:1976];
	[self addAutoModel:@"Cougar" ofAuto:autoId logo:logoId startYear:1977 endYear:1982];
	[self addAutoModel:@"Marquis" ofAuto:autoId logo:logoId startYear:1983 endYear:1986];
	[self addAutoModel:@"Milan" ofAuto:autoId logo:logoId startYear:2006 endYear:2011];
	[self addAutoModel:@"Eight" ofAuto:autoId logo:logoId startYear:1939 endYear:1951];
	
	[self addAutoModel:@"Monterey" ofAuto:autoId logo:logoId startYear:1950 endYear:1974];
	[self addAutoModel:@"S-55" ofAuto:autoId logo:logoId startYear:1962 endYear:1967];
	[self addAutoModel:@"Montclair" ofAuto:autoId logo:logoId startYear:1955 endYear:1968];
	[self addAutoModel:@"Medalist" ofAuto:autoId logo:logoId startYear:1956 endYear:1956];
	[self addAutoModel:@"Custom" ofAuto:autoId logo:logoId startYear:1956 endYear:1956];
	[self addAutoModel:@"Turnpike Cruiser" ofAuto:autoId logo:logoId startYear:1957 endYear:1958];
	[self addAutoModel:@"Park Lane" ofAuto:autoId logo:logoId startYear:1958 endYear:1968];
	[self addAutoModel:@"Meteor" ofAuto:autoId logo:logoId startYear:1960 endYear:1961];
	[self addAutoModel:@"Marauder" ofAuto:autoId logo:logoId startYear:1963 endYear:2004];
	[self addAutoModel:@"Marauder X-100" ofAuto:autoId logo:logoId startYear:1969 endYear:1970];
	[self addAutoModel:@"Marquis" ofAuto:autoId logo:logoId startYear:1967 endYear:1982];
	[self addAutoModel:@"Brougham" ofAuto:autoId logo:logoId startYear:1967 endYear:1968];
	[self addAutoModel:@"Park Lane Brougham" ofAuto:autoId logo:logoId startYear:1967 endYear:1968];
	[self addAutoModel:@"Sable" ofAuto:autoId logo:logoId startYear:1985 endYear:2009];
	[self addAutoModel:@"Cougar" ofAuto:autoId logo:logoId startYear:1974 endYear:1997];
	[self addAutoModel:@"Cougar" ofAuto:autoId logo:logoId startYear:1967 endYear:2002];
	[self addAutoModel:@"Capri" ofAuto:autoId logo:logoId startYear:1970 endYear:1994];
	[self addAutoModel:@"LN7" ofAuto:autoId logo:logoId startYear:1982 endYear:1983];
	[self addAutoModel:@"Monterey" ofAuto:autoId logo:logoId startYear:1955 endYear:1956];
	[self addAutoModel:@"Custom Monterey" ofAuto:autoId logo:logoId startYear:1955 endYear:1956];
	
	[self addAutoModel:@"Colony Park" ofAuto:autoId logo:logoId startYear:1957 endYear:1991];
	[self addAutoModel:@"Commuter" ofAuto:autoId logo:logoId startYear:1957 endYear:1968];
	[self addAutoModel:@"Voyager" ofAuto:autoId logo:logoId startYear:1957 endYear:1957];
	[self addAutoModel:@"Villager" ofAuto:autoId logo:logoId startYear:1993 endYear:2002];
	[self addAutoModel:@"Monterey" ofAuto:autoId logo:logoId startYear:2004 endYear:2007];
	[self addAutoModel:@"Mariner" ofAuto:autoId logo:logoId startYear:2005 endYear:2011];
	[self addAutoModel:@"Mountaineer" ofAuto:autoId logo:logoId startYear:1997 endYear:2010];
    
	modelId = [self addAutoModel:@"Concept Car" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	{
		[self addAutoSubmodel:@"Comet Fastback" ofModel:modelId logo:logoId startYear:1964 endYear:-1];
		[self addAutoSubmodel:@"Comet Cyclone Sportster" ofModel:modelId logo:logoId startYear:1965 endYear:-1];
		[self addAutoSubmodel:@"Comet Escapade" ofModel:modelId logo:logoId startYear:1966 endYear:-1];
		[self addAutoSubmodel:@"Bahamian" ofModel:modelId logo:logoId startYear:1953 endYear:-1];
		[self addAutoSubmodel:@"XM-800" ofModel:modelId logo:logoId startYear:1954 endYear:-1];
		[self addAutoSubmodel:@"XM Turnpike Cruiser" ofModel:modelId logo:logoId startYear:1956 endYear:-1];
		[self addAutoSubmodel:@"Palomar" ofModel:modelId logo:logoId startYear:1962 endYear:-1];
		[self addAutoSubmodel:@"Super Marauder" ofModel:modelId logo:logoId startYear:1964 endYear:-1];
		[self addAutoSubmodel:@"Wrist Twist Park Lane" ofModel:modelId logo:logoId startYear:1965 endYear:-1];
		[self addAutoSubmodel:@"Astron" ofModel:modelId logo:logoId startYear:1966 endYear:-1];
		[self addAutoSubmodel:@"LeGrand Marquis" ofModel:modelId logo:logoId startYear:1968 endYear:-1];
		[self addAutoSubmodel:@"Cyclone Super Spoiler" ofModel:modelId logo:logoId startYear:1969 endYear:-1];
		[self addAutoSubmodel:@"Cougar El Gato" ofModel:modelId logo:logoId startYear:1970 endYear:-1];
		[self addAutoSubmodel:@"Montego Sportshauler" ofModel:modelId logo:logoId startYear:1971 endYear:-1];
		[self addAutoSubmodel:@"XM" ofModel:modelId logo:logoId startYear:1979 endYear:-1];
		[self addAutoSubmodel:@"Capri Guardsman" ofModel:modelId logo:logoId startYear:1980 endYear:-1];
		[self addAutoSubmodel:@"Anster" ofModel:modelId logo:logoId startYear:1980 endYear:-1];
		[self addAutoSubmodel:@"LN7 PPG" ofModel:modelId logo:logoId startYear:1981 endYear:-1];
		[self addAutoSubmodel:@"Vanster" ofModel:modelId logo:logoId startYear:1985 endYear:-1];
		[self addAutoSubmodel:@"Concept 50" ofModel:modelId logo:logoId startYear:1988 endYear:-1];
		
		[self addAutoSubmodel:@"One" ofModel:modelId logo:logoId startYear:1989 endYear:-1];
		[self addAutoSubmodel:@"Mystique" ofModel:modelId logo:logoId startYear:1991 endYear:-1];
		[self addAutoSubmodel:@"Fusion" ofModel:modelId logo:logoId startYear:1996 endYear:-1];
		[self addAutoSubmodel:@"MC 2" ofModel:modelId logo:logoId startYear:1997 endYear:-1];
		[self addAutoSubmodel:@"MC 4" ofModel:modelId logo:logoId startYear:1997 endYear:-1];
		[self addAutoSubmodel:@"L'Attitude" ofModel:modelId logo:logoId startYear:1998 endYear:-1];
		[self addAutoSubmodel:@"My" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"Gametime Villager" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"Cougar S" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"Cougar Eliminator" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"Marauder Convertible" ofModel:modelId logo:logoId startYear:2000 endYear:-1];
		[self addAutoSubmodel:@"Messenger" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Meta One" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
	}
#pragma mark |---- Jeep
    logoId = [self addLogo:@"jeep_256.png"];
    autoId = [self addAuto:@"Jeep" country:countryId logoAsName:logoId independentId:JEEP];

    modelId = [self addAutoModel:@"Cherokee" ofAuto:autoId logo:logoId startYear:1974 endYear:0];
	{
		[self addAutoSubmodel:@"SJ" ofModel:modelId logo:logoId startYear:1974 endYear:1983];
		[self addAutoSubmodel:@"XJ" ofModel:modelId logo:logoId startYear:1984 endYear:2005];
		[self addAutoSubmodel:@"KL" ofModel:modelId logo:logoId startYear:2013 endYear:0];
	}
	
	[self addAutoModel:@"CJ" ofAuto:autoId logo:logoId startYear:1944 endYear:1986];
	[self addAutoModel:@"Comanche" ofAuto:autoId logo:logoId startYear:1985 endYear:1992];
	[self addAutoModel:@"Commander" ofAuto:autoId logo:logoId startYear:2006 endYear:2010];
	[self addAutoModel:@"Compass" ofAuto:autoId logo:logoId startYear:2006 endYear:0];
	[self addAutoModel:@"DJ" ofAuto:autoId logo:logoId startYear:1955 endYear:1984];
	[self addAutoModel:@"FJ" ofAuto:autoId logo:logoId startYear:1961 endYear:1965];
	[self addAutoModel:@"Forward Control" ofAuto:autoId logo:logoId startYear:1956 endYear:1964];
	[self addAutoModel:@"Gladiator" ofAuto:autoId logo:logoId startYear:1962 endYear:1988];
	[self addAutoModel:@"Grand Cherokee	" ofAuto:autoId logo:logoId startYear:1992 endYear:0];
	[self addAutoModel:@"Hurricane" ofAuto:autoId logo:logoId startYear:2005 endYear:-1];
	[self addAutoModel:@"J8" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
	[self addAutoModel:@"ter Commando" ofAuto:autoId logo:logoId startYear:1966 endYear:1973];
	[self addAutoModel:@"Liberty" ofAuto:autoId logo:logoId startYear:2002 endYear:2013];
	[self addAutoModel:@"Patriot" ofAuto:autoId logo:logoId startYear:2006 endYear:0];
	[self addAutoModel:@"Renegade" ofAuto:autoId logo:logoId startYear:2008 endYear:-1];
	[self addAutoModel:@"Trailhawk" ofAuto:autoId logo:logoId startYear:2007 endYear:-1];
	[self addAutoModel:@"Wagoneer" ofAuto:autoId logo:logoId startYear:1963 endYear:1991];
	[self addAutoModel:@"Wrangler" ofAuto:autoId logo:logoId startYear:1986 endYear:0];
	
#pragma mark |---- Chevrolet
    logoId = [self addLogo:@"chevrolet_256.png"];
    autoId = [self addAuto:@"Chevrolet" country:countryId logo:logoId independentId:CHEVROLET];
    [self addAutoModel:@"Camaro" ofAuto:autoId logo:logoId startYear:1967 endYear:2002];
	[self addAutoModel:@"Camaro" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
	modelId = [self addAutoModel:@"Camaro" ofAuto:autoId logo:logoId startYear:1967 endYear:0];
	{
		[self addAutoSubmodel:@"Black" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"Chroma" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
		[self addAutoSubmodel:@"Concept" ofModel:modelId logo:logoId startYear:2006 endYear:-1];
		[self addAutoSubmodel:@"Convertible" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"Convertible" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"Dale Earnhardt Jr." ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"Dusk" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
		[self addAutoSubmodel:@"GS Racecar" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"LS7" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"LT5" ofModel:modelId logo:logoId startYear:1988 endYear:-1];
		[self addAutoSubmodel:@"SS" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"SSX" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"ZL1" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
	}
	
	[self addAutoModel:@"Caprice" ofAuto:autoId logo:logoId startYear:1999 endYear:0];
	[self addAutoModel:@"Captiva" ofAuto:autoId logo:logoId startYear:2006 endYear:0];
	[self addAutoModel:@"Captiva Sport" ofAuto:autoId logo:logoId startYear:2006 endYear:0];
	
	modelId = [self addAutoModel:@"CERV" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
	{
		[self addAutoSubmodel:@"CERV" ofModel:modelId logo:logoId startYear:1960 endYear:-1];
		[self addAutoSubmodel:@"CERV" ofModel:modelId logo:logoId startYear:1964 endYear:-1];
		[self addAutoSubmodel:@"CERV" ofModel:modelId logo:logoId startYear:1990 endYear:-1];
		[self addAutoSubmodel:@"CERV" ofModel:modelId logo:logoId startYear:1992 endYear:-1];
		[self addAutoSubmodel:@"CERV I" ofModel:modelId logo:logoId startYear:1959 endYear:-1];
		[self addAutoSubmodel:@"CERV II" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		[self addAutoSubmodel:@"CERV III" ofModel:modelId logo:logoId startYear:1985 endYear:-1];
		[self addAutoSubmodel:@"CERV IV" ofModel:modelId logo:logoId startYear:1993 endYear:-1];
		[self addAutoSubmodel:@"CERV IV-B" ofModel:modelId logo:logoId startYear:1997 endYear:-1];
	}
	
	modelId = [self addAutoModel:@"Corvair" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
	{
		[self addAutoSubmodel:@"Corvair" ofModel:modelId logo:logoId startYear:1954 endYear:-1];
		[self addAutoSubmodel:@"Corvair" ofModel:modelId logo:logoId startYear:1960 endYear:-1];
		[self addAutoSubmodel:@"Corvair Coupe Speciale" ofModel:modelId logo:logoId startYear:1960 endYear:-1];
		[self addAutoSubmodel:@"Corvair Coupe Speciale" ofModel:modelId logo:logoId startYear:1962 endYear:-1];
		[self addAutoSubmodel:@"Corvair Coupe Speciale" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		[self addAutoSubmodel:@"Corvair Monza GT" ofModel:modelId logo:logoId startYear:1962 endYear:-1];
		[self addAutoSubmodel:@"Corvair Monza SS" ofModel:modelId logo:logoId startYear:1962 endYear:-1];
		[self addAutoSubmodel:@"Corvair Sebring Spyder" ofModel:modelId logo:logoId startYear:1961 endYear:-1];
		[self addAutoSubmodel:@"Corvair Super Spyder" ofModel:modelId logo:logoId startYear:1962 endYear:-1];
		[self addAutoSubmodel:@"Corvair Testudo" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
	}
	
	modelId = [self addAutoModel:@"Corvette" ofAuto:autoId logo:logoId startYear:1953 endYear:0];
	{
		[self addAutoSubmodel:@"Concept" ofModel:modelId logo:logoId startYear:1953 endYear:-1];
		[self addAutoSubmodel:@"C2" ofModel:modelId logo:logoId startYear:1962 endYear:-1];
		[self addAutoSubmodel:@"Indy" ofModel:modelId logo:logoId startYear:1986 endYear:-1];
		[self addAutoSubmodel:@"Nivola" ofModel:modelId logo:logoId startYear:1990 endYear:-1];
		[self addAutoSubmodel:@"Stingray" ofModel:modelId logo:logoId startYear:1959 endYear:-1];
		[self addAutoSubmodel:@"Stingray" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
		[self addAutoSubmodel:@"XP-700" ofModel:modelId logo:logoId startYear:1958 endYear:-1];
		[self addAutoSubmodel:@"XP-819 Rear Engine" ofModel:modelId logo:logoId startYear:1964 endYear:-1];
		[self addAutoSubmodel:@"Z03" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"Z06X" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"ZR1" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"ZR2" ofModel:modelId logo:logoId startYear:1989 endYear:-1];
	}
	
	modelId = [self addAutoModel:@"Cruze" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
	{
		[self addAutoSubmodel:@"Cruze" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"Cruze Eco" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"Cruze RS" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
	}
	
	modelId = [self addAutoModel:@"Astro" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
	{
		[self addAutoSubmodel:@"Astro I" ofModel:modelId logo:logoId startYear:1967 endYear:-1];
		[self addAutoSubmodel:@"Astro II" ofModel:modelId logo:logoId startYear:1968 endYear:-1];
		[self addAutoSubmodel:@"Astro III" ofModel:modelId logo:logoId startYear:1969 endYear:-1];
	}
	
	[self addAutoModel:@"Agile" ofAuto:autoId logo:logoId startYear:2009 endYear:0];
	[self addAutoModel:@"Aveo" ofAuto:autoId logo:logoId startYear:2002 endYear:0];
	[self addAutoModel:@"Celta" ofAuto:autoId logo:logoId startYear:2000 endYear:0];
	[self addAutoModel:@"Classic" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"Cobalt" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"Colorado" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
	[self addAutoModel:@"Cruze" ofAuto:autoId logo:logoId startYear:2008 endYear:0];
	[self addAutoModel:@"Equinox" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"Express" ofAuto:autoId logo:logoId startYear:1996 endYear:0];
	[self addAutoModel:@"Grand Blazer" ofAuto:autoId logo:logoId startYear:2012 endYear:0];
	[self addAutoModel:@"Impala" ofAuto:autoId logo:logoId startYear:1958 endYear:0];
	[self addAutoModel:@"Lacetti" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"Lova" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"Lumina" ofAuto:autoId logo:logoId startYear:1990 endYear:0];
	[self addAutoModel:@"Lanos" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"Malibu" ofAuto:autoId logo:logoId startYear:1964 endYear:1983];
	[self addAutoModel:@"Malibu" ofAuto:autoId logo:logoId startYear:1997 endYear:0];
	[self addAutoModel:@"Montana" ofAuto:autoId logo:logoId startYear:2003 endYear:0];
	[self addAutoModel:@"N200" ofAuto:autoId logo:logoId startYear:2008 endYear:0];
	[self addAutoModel:@"Niva" ofAuto:autoId logo:logoId startYear:1998 endYear:0];
	
	[self addAutoModel:@"Onix" ofAuto:autoId logo:logoId startYear:2012 endYear:0];
	[self addAutoModel:@"Omega" ofAuto:autoId logo:logoId startYear:1992 endYear:0];
	[self addAutoModel:@"Optra" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
	[self addAutoModel:@"Orlando" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
	[self addAutoModel:@"Prisma" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
	[self addAutoModel:@"SS" ofAuto:autoId logo:logoId startYear:2013 endYear:0];
	[self addAutoModel:@"S-10" ofAuto:autoId logo:logoId startYear:1982 endYear:0];
	[self addAutoModel:@"Sail" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
	[self addAutoModel:@"Silverado" ofAuto:autoId logo:logoId startYear:1999 endYear:0];
	[self addAutoModel:@"Sonic" ofAuto:autoId logo:logoId startYear:2012 endYear:0];
	[self addAutoModel:@"Spark" ofAuto:autoId logo:logoId startYear:2012 endYear:0];
	[self addAutoModel:@"Suburban" ofAuto:autoId logo:logoId startYear:1935 endYear:0];
	[self addAutoModel:@"Tahoe" ofAuto:autoId logo:logoId startYear:1995 endYear:0];
	[self addAutoModel:@"Tavera" ofAuto:autoId logo:logoId startYear:1998 endYear:0];
	[self addAutoModel:@"Tornado" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
	[self addAutoModel:@"Tracker" ofAuto:autoId logo:logoId startYear:1998 endYear:0];
	[self addAutoModel:@"TrailBlazer" ofAuto:autoId logo:logoId startYear:2002 endYear:0];
	[self addAutoModel:@"Volt" ofAuto:autoId logo:logoId startYear:2011 endYear:0];
	[self addAutoModel:@"454 SS" ofAuto:autoId logo:logoId startYear:1990 endYear:1993];
	[self addAutoModel:@"Blazer" ofAuto:autoId logo:logoId startYear:1995 endYear:2012];
	
	modelId = [self addAutoModel:@"Old car" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
	{
		[self addAutoSubmodel:@"Task Force" ofModel:modelId logo:logoId startYear:1955 endYear:1959];
		[self addAutoSubmodel:@"Titan" ofModel:modelId logo:logoId startYear:1969 endYear:1980];
		[self addAutoSubmodel:@"Townsman" ofModel:modelId logo:logoId startYear:1953 endYear:1972];
		[self addAutoSubmodel:@"Vega" ofModel:modelId logo:logoId startYear:1971 endYear:1977];
		[self addAutoSubmodel:@"Veraneio" ofModel:modelId logo:logoId startYear:1964 endYear:1993];
		[self addAutoSubmodel:@"Yeoman" ofModel:modelId logo:logoId startYear:1958 endYear:1958];
		[self addAutoSubmodel:@"150" ofModel:modelId logo:logoId startYear:1953 endYear:1957];
		[self addAutoSubmodel:@"210" ofModel:modelId logo:logoId startYear:1953 endYear:1957];
		[self addAutoSubmodel:@"400" ofModel:modelId logo:logoId startYear:1962 endYear:1974];
		[self addAutoSubmodel:@"1700" ofModel:modelId logo:logoId startYear:1972 endYear:1978];
		[self addAutoSubmodel:@"2500" ofModel:modelId logo:logoId startYear:1973 endYear:1978];
		[self addAutoSubmodel:@"3800" ofModel:modelId logo:logoId startYear:1972 endYear:1978];
		[self addAutoSubmodel:@"4100" ofModel:modelId logo:logoId startYear:1972 endYear:1978];
		[self addAutoSubmodel:@"Advance Design" ofModel:modelId logo:logoId startYear:1947 endYear:1955];
		[self addAutoSubmodel:@"AK Series" ofModel:modelId logo:logoId startYear:1941 endYear:1942];
		[self addAutoSubmodel:@"Baby Grand" ofModel:modelId logo:logoId startYear:1914 endYear:1922];
		[self addAutoSubmodel:@"Beauville" ofModel:modelId logo:logoId startYear:1955 endYear:1957];
		[self addAutoSubmodel:@"Beauville Van" ofModel:modelId logo:logoId startYear:1971 endYear:1996];
		[self addAutoSubmodel:@"Bel Air" ofModel:modelId logo:logoId startYear:1953 endYear:1981];
		[self addAutoSubmodel:@"Beretta" ofModel:modelId logo:logoId startYear:1987 endYear:1996];
		
		[self addAutoSubmodel:@"Biscayne" ofModel:modelId logo:logoId startYear:1958 endYear:1975];
		[self addAutoSubmodel:@"Bison" ofModel:modelId logo:logoId startYear:1977 endYear:1980];
		[self addAutoSubmodel:@"Brookwood" ofModel:modelId logo:logoId startYear:1958 endYear:1972];
		[self addAutoSubmodel:@"Bruin" ofModel:modelId logo:logoId startYear:1978 endYear:1988];
		[self addAutoSubmodel:@"C-10" ofModel:modelId logo:logoId startYear:1964 endYear:1985];
		[self addAutoSubmodel:@"C-20" ofModel:modelId logo:logoId startYear:1985 endYear:1996];
		[self addAutoSubmodel:@"Calibra" ofModel:modelId logo:logoId startYear:1989 endYear:1997];
		[self addAutoSubmodel:@"Caprice" ofModel:modelId logo:logoId startYear:1965 endYear:1996];
		[self addAutoSubmodel:@"Chevair" ofModel:modelId logo:logoId startYear:1976 endYear:1985];
		[self addAutoSubmodel:@"Chevelle" ofModel:modelId logo:logoId startYear:1964 endYear:1977];
		[self addAutoSubmodel:@"Chevette" ofModel:modelId logo:logoId startYear:1976 endYear:1998];
		[self addAutoSubmodel:@"Chevy" ofModel:modelId logo:logoId startYear:1969 endYear:1978];
		[self addAutoSubmodel:@"Chevy II" ofModel:modelId logo:logoId startYear:1962 endYear:1968];
		[self addAutoSubmodel:@"C/K" ofModel:modelId logo:logoId startYear:1960 endYear:2001];
		[self addAutoSubmodel:@"Commodore" ofModel:modelId logo:logoId startYear:1978 endYear:1982];
		[self addAutoSubmodel:@"Confederate" ofModel:modelId logo:logoId startYear:1932 endYear:1932];
		[self addAutoSubmodel:@"Constantia" ofModel:modelId logo:logoId startYear:1969 endYear:1978];
		[self addAutoSubmodel:@"Corvair" ofModel:modelId logo:logoId startYear:1960 endYear:1969];
		[self addAutoSubmodel:@"Delray" ofModel:modelId logo:logoId startYear:1958 endYear:1958];
		[self addAutoSubmodel:@"Deluxe" ofModel:modelId logo:logoId startYear:1941 endYear:1952];
		
		[self addAutoSubmodel:@"Eagle" ofModel:modelId logo:logoId startYear:1933 endYear:1933];
		[self addAutoSubmodel:@"El Camino" ofModel:modelId logo:logoId startYear:1959 endYear:1987];
		[self addAutoSubmodel:@"FA Series" ofModel:modelId logo:logoId startYear:1918 endYear:-1];
		[self addAutoSubmodel:@"FB Series" ofModel:modelId logo:logoId startYear:1919 endYear:1922];
		[self addAutoSubmodel:@"Fleetline" ofModel:modelId logo:logoId startYear:1941 endYear:1952];
		[self addAutoSubmodel:@"G506 trucks" ofModel:modelId logo:logoId startYear:1941 endYear:1945];
		[self addAutoSubmodel:@"Gemini" ofModel:modelId logo:logoId startYear:1985 endYear:1990];
		[self addAutoSubmodel:@"Greenbrier" ofModel:modelId logo:logoId startYear:1961 endYear:1972];
		[self addAutoSubmodel:@"G-series" ofModel:modelId logo:logoId startYear:1964 endYear:1996];
		[self addAutoSubmodel:@"Independence" ofModel:modelId logo:logoId startYear:1931 endYear:-1];
		[self addAutoSubmodel:@"International" ofModel:modelId logo:logoId startYear:1929 endYear:-1];
		[self addAutoSubmodel:@"K5 Blazer" ofModel:modelId logo:logoId startYear:1969 endYear:2001];
		[self addAutoSubmodel:@"Kingswood" ofModel:modelId logo:logoId startYear:1959 endYear:1972];
		[self addAutoSubmodel:@"Kingswood Estate" ofModel:modelId logo:logoId startYear:1969 endYear:1972];
		[self addAutoSubmodel:@"Kommando" ofModel:modelId logo:logoId startYear:1968 endYear:1980];
		[self addAutoSubmodel:@"Lakewood" ofModel:modelId logo:logoId startYear:1961 endYear:1962];
		[self addAutoSubmodel:@"Light Six Series L" ofModel:modelId logo:logoId startYear:1914 endYear:1915];
		[self addAutoSubmodel:@"LUV" ofModel:modelId logo:logoId startYear:1972 endYear:2005];
		[self addAutoSubmodel:@"Master" ofModel:modelId logo:logoId startYear:1933 endYear:1942];
		
		[self addAutoSubmodel:@"Mercury" ofModel:modelId logo:logoId startYear:1933 endYear:-1];
		[self addAutoSubmodel:@"Monza" ofModel:modelId logo:logoId startYear:1975 endYear:1980];
		[self addAutoSubmodel:@"National Series AB" ofModel:modelId logo:logoId startYear:1928 endYear:-1];
		[self addAutoSubmodel:@"Nomad" ofModel:modelId logo:logoId startYear:1955 endYear:1972];
		[self addAutoSubmodel:@"Nomad SUV" ofModel:modelId logo:logoId startYear:1973 endYear:1982];
		[self addAutoSubmodel:@"Nova" ofModel:modelId logo:logoId startYear:1969 endYear:1988];
		[self addAutoSubmodel:@"Stylemaster" ofModel:modelId logo:logoId startYear:1945 endYear:1948];
		[self addAutoSubmodel:@"Opala" ofModel:modelId logo:logoId startYear:1969 endYear:1992];
		[self addAutoSubmodel:@"Parkwood" ofModel:modelId logo:logoId startYear:1959 endYear:1961];
		[self addAutoSubmodel:@"Senator" ofModel:modelId logo:logoId startYear:1978 endYear:1982];
		[self addAutoSubmodel:@"Series 490" ofModel:modelId logo:logoId startYear:1915 endYear:1922];
		[self addAutoSubmodel:@"Series AA Capitol" ofModel:modelId logo:logoId startYear:1927 endYear:1927];
		[self addAutoSubmodel:@"Series C Classic Six" ofModel:modelId logo:logoId startYear:1911 endYear:1913];
		[self addAutoSubmodel:@"Series D" ofModel:modelId logo:logoId startYear:1917 endYear:1918];
		[self addAutoSubmodel:@"Series F" ofModel:modelId logo:logoId startYear:1917 endYear:1917];
		[self addAutoSubmodel:@"Series H" ofModel:modelId logo:logoId startYear:1914 endYear:1916];
		[self addAutoSubmodel:@"Series M Copper-Cooled" ofModel:modelId logo:logoId startYear:1923 endYear:1923];
		[self addAutoSubmodel:@"Special" ofModel:modelId logo:logoId startYear:1949 endYear:1957];
		[self addAutoSubmodel:@"Standard" ofModel:modelId logo:logoId startYear:1933 endYear:1936];
		[self addAutoSubmodel:@"Styleline" ofModel:modelId logo:logoId startYear:1941 endYear:1942];
		
		[self addAutoSubmodel:@"XP-882 4-Rotor" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
		[self addAutoSubmodel:@"XP-895 Reynolds" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
		[self addAutoSubmodel:@"XP-897GT 2-Rotor" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
		[self addAutoSubmodel:@"XP-898" ofModel:modelId logo:logoId startYear:1973 endYear:-1];
		[self addAutoSubmodel:@"Superior B" ofModel:modelId logo:logoId startYear:1923 endYear:1923];
		[self addAutoSubmodel:@"Superior F" ofModel:modelId logo:logoId startYear:1924 endYear:1924];
		[self addAutoSubmodel:@"Superior K" ofModel:modelId logo:logoId startYear:1925 endYear:1925];
		[self addAutoSubmodel:@"Superior V" ofModel:modelId logo:logoId startYear:1926 endYear:1925];
		
	}
	
	[self addAutoModel:@"Optra Wagon" ofAuto:autoId logo:logoId startYear:2002 endYear:0];
	[self addAutoModel:@"Alero" ofAuto:autoId logo:logoId startYear:1999 endYear:2004];
	[self addAutoModel:@"Astra" ofAuto:autoId logo:logoId startYear:1991 endYear:2009];
	[self addAutoModel:@"Astro" ofAuto:autoId logo:logoId startYear:1985 endYear:2005];
	[self addAutoModel:@"Avalanche" ofAuto:autoId logo:logoId startYear:2002 endYear:2013];
	[self addAutoModel:@"500" ofAuto:autoId logo:logoId startYear:1983 endYear:1995];
	[self addAutoModel:@"Chevy" ofAuto:autoId logo:logoId startYear:1994 endYear:2012];
	[self addAutoModel:@"Spectrum" ofAuto:autoId logo:logoId startYear:1985 endYear:1988];
	[self addAutoModel:@"Citation" ofAuto:autoId logo:logoId startYear:1980 endYear:1985];
	[self addAutoModel:@"Corsa" ofAuto:autoId logo:logoId startYear:1994 endYear:2011];
	[self addAutoModel:@"Corsica" ofAuto:autoId logo:logoId startYear:1987 endYear:1996];
	[self addAutoModel:@"Epica" ofAuto:autoId logo:logoId startYear:2004 endYear:2011];
	[self addAutoModel:@"Esteem" ofAuto:autoId logo:logoId startYear:1996 endYear:2004];
	[self addAutoModel:@"Evanda" ofAuto:autoId logo:logoId startYear:2005 endYear:2006];
	[self addAutoModel:@"Exclusive" ofAuto:autoId logo:logoId startYear:2003 endYear:2004];
	[self addAutoModel:@"D-Max" ofAuto:autoId logo:logoId startYear:2002 endYear:2008];
	[self addAutoModel:@"Monte Carlo" ofAuto:autoId logo:logoId startYear:1970 endYear:2007];
	[self addAutoModel:@"Prizm" ofAuto:autoId logo:logoId startYear:1998 endYear:2002];
	[self addAutoModel:@"Rezzo" ofAuto:autoId logo:logoId startYear:2002 endYear:2008];
	[self addAutoModel:@"Rodeo" ofAuto:autoId logo:logoId startYear:1989 endYear:2004];
	
	[self addAutoModel:@"S-10 Blazer" ofAuto:autoId logo:logoId startYear:1983 endYear:1994];
	[self addAutoModel:@"Cruze" ofAuto:autoId logo:logoId startYear:2001 endYear:2008];
	[self addAutoModel:@"D-10" ofAuto:autoId logo:logoId startYear:1980 endYear:1985];
	[self addAutoModel:@"D-20" ofAuto:autoId logo:logoId startYear:1985 endYear:1996];
	[self addAutoModel:@"Cassia" ofAuto:autoId logo:logoId startYear:1998 endYear:2002];
	[self addAutoModel:@"Cavalier" ofAuto:autoId logo:logoId startYear:1982 endYear:2005];
	[self addAutoModel:@"Celebrity" ofAuto:autoId logo:logoId startYear:1982 endYear:1990];
	[self addAutoModel:@"Kadett" ofAuto:autoId logo:logoId startYear:1979 endYear:1991];
	[self addAutoModel:@"Kalos" ofAuto:autoId logo:logoId startYear:2005 endYear:2008];
	[self addAutoModel:@"Joy" ofAuto:autoId logo:logoId startYear:2005 endYear:2009];
	[self addAutoModel:@"HHR" ofAuto:autoId logo:logoId startYear:2006 endYear:2011];
	[self addAutoModel:@"Nubira" ofAuto:autoId logo:logoId startYear:2004 endYear:-1];
	[self addAutoModel:@"Frontera" ofAuto:autoId logo:logoId startYear:1989 endYear:2004];
	[self addAutoModel:@"Kodiak" ofAuto:autoId logo:logoId startYear:1980 endYear:2009];
	[self addAutoModel:@"Lumina APV" ofAuto:autoId logo:logoId startYear:1990 endYear:1996];
	[self addAutoModel:@"Marajó" ofAuto:autoId logo:logoId startYear:1980 endYear:1989];
	[self addAutoModel:@"Forester" ofAuto:autoId logo:logoId startYear:2002 endYear:2005];
	[self addAutoModel:@"Metro" ofAuto:autoId logo:logoId startYear:1998 endYear:2001];
	[self addAutoModel:@"Meriva" ofAuto:autoId logo:logoId startYear:2002 endYear:2011];
	[self addAutoModel:@"Matiz" ofAuto:autoId logo:logoId startYear:2005 endYear:2010];
	
	[self addAutoModel:@"A-10" ofAuto:autoId logo:logoId startYear:1981 endYear:1985];
	[self addAutoModel:@"A-20" ofAuto:autoId logo:logoId startYear:1985 endYear:1996];
	[self addAutoModel:@"SSR" ofAuto:autoId logo:logoId startYear:2003 endYear:2006];
	[self addAutoModel:@"Sprint" ofAuto:autoId logo:logoId startYear:1985 endYear:2004];
	[self addAutoModel:@"Swift" ofAuto:autoId logo:logoId startYear:1991 endYear:2004];
	[self addAutoModel:@"Tacuma" ofAuto:autoId logo:logoId startYear:2002 endYear:2008];
	[self addAutoModel:@"Tigra" ofAuto:autoId logo:logoId startYear:1994 endYear:2000];
	[self addAutoModel:@"Tosca" ofAuto:autoId logo:logoId startYear:2006 endYear:2011];
	[self addAutoModel:@"Trans Sport" ofAuto:autoId logo:logoId startYear:1997 endYear:2005];
	[self addAutoModel:@"Universal Series AD" ofAuto:autoId logo:logoId startYear:1930 endYear:1930];
	[self addAutoModel:@"Uplander" ofAuto:autoId logo:logoId startYear:2005 endYear:2009];
	[self addAutoModel:@"Van" ofAuto:autoId logo:logoId startYear:1964 endYear:1996];
	[self addAutoModel:@"Vectra" ofAuto:autoId logo:logoId startYear:1993 endYear:2008];
	[self addAutoModel:@"Vitara" ofAuto:autoId logo:logoId startYear:1988 endYear:1998];
	[self addAutoModel:@"Viva" ofAuto:autoId logo:logoId startYear:2004 endYear:2008];
	[self addAutoModel:@"Vivant" ofAuto:autoId logo:logoId startYear:2002 endYear:2008];
	[self addAutoModel:@"Venture" ofAuto:autoId logo:logoId startYear:1997 endYear:2005];
	[self addAutoModel:@"W-series" ofAuto:autoId logo:logoId startYear:1998 endYear:2009];
	[self addAutoModel:@"Zafira" ofAuto:autoId logo:logoId startYear:2001 endYear:2011];
	
	modelId = [self addAutoModel:@"Concepts" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
	{
		[self addAutoSubmodel:@"Aero 2003A" ofModel:modelId logo:logoId startYear:1987 endYear:-1];
		[self addAutoSubmodel:@"Aerovette" ofModel:modelId logo:logoId startYear:1976 endYear:-1];
		[self addAutoSubmodel:@"Astrovette" ofModel:modelId logo:logoId startYear:1968 endYear:-1];
		[self addAutoSubmodel:@"Aveo RS" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"Beat" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"Bel Air" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
		[self addAutoSubmodel:@"Biscayne" ofModel:modelId logo:logoId startYear:1955 endYear:-1];
		[self addAutoSubmodel:@"Blazer XT-1" ofModel:modelId logo:logoId startYear:1987 endYear:-1];
		[self addAutoSubmodel:@"Borrego" ofModel:modelId logo:logoId startYear:2001 endYear:-1];
		[self addAutoSubmodel:@"California IROC Camaro" ofModel:modelId logo:logoId startYear:1989 endYear:-1];
		[self addAutoSubmodel:@"Caprice PPV" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"Cheyenne" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Citation IV" ofModel:modelId logo:logoId startYear:1984 endYear:-1];
		[self addAutoSubmodel:@"Cobalt" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"Code 130R" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
		[self addAutoSubmodel:@"Colorado" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"GPiX" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"Equinox Xtreme" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Express" ofModel:modelId logo:logoId startYear:1987 endYear:-1];
		[self addAutoSubmodel:@"Groove" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		
		[self addAutoSubmodel:@"Highlander" ofModel:modelId logo:logoId startYear:1993 endYear:-1];
		[self addAutoSubmodel:@"HHR" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"Impala" ofModel:modelId logo:logoId startYear:1956 endYear:-1];
		[self addAutoSubmodel:@"Jay Leno Camaro" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
		[self addAutoSubmodel:@"M3X" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
		[self addAutoSubmodel:@"Mako Shark" ofModel:modelId logo:logoId startYear:1961 endYear:-1];
		[self addAutoSubmodel:@"Mako Shark II" ofModel:modelId logo:logoId startYear:1965 endYear:-1];
		[self addAutoSubmodel:@"Malibu" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"Malibu Maxx" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Manta Ray" ofModel:modelId logo:logoId startYear:1969 endYear:-1];
		[self addAutoSubmodel:@"Mulsanne" ofModel:modelId logo:logoId startYear:1974 endYear:-1];
		[self addAutoSubmodel:@"Nomad" ofModel:modelId logo:logoId startYear:1954 endYear:-1];
		[self addAutoSubmodel:@"Nomad" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"Nomad" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
		[self addAutoSubmodel:@"Orlando" ofModel:modelId logo:logoId startYear:2008 endYear:-1];
		[self addAutoSubmodel:@"Colorado Rally" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"Q Corvette" ofModel:modelId logo:logoId startYear:1957 endYear:-1];
		[self addAutoSubmodel:@"Ramarro" ofModel:modelId logo:logoId startYear:1984 endYear:-1];
		[self addAutoSubmodel:@"Rondine" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		[self addAutoSubmodel:@"S3X" ofModel:modelId logo:logoId startYear:2004 endYear:-1];
		
		[self addAutoSubmodel:@"Scirocco" ofModel:modelId logo:logoId startYear:1970 endYear:-1];
		[self addAutoSubmodel:@"Sequel" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"Silverado 427" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"Silverado Orange" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"Silverado ZR2" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"Sonic" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"Sonic Z-Spec" ofModel:modelId logo:logoId startYear:2011 endYear:-1];
		[self addAutoSubmodel:@"SR-2" ofModel:modelId logo:logoId startYear:1957 endYear:-1];
		[self addAutoSubmodel:@"SS" ofModel:modelId logo:logoId startYear:2003 endYear:-1];
		[self addAutoSubmodel:@"Suburban 75th Anniv" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"Synergy Camaro" ofModel:modelId logo:logoId startYear:2009 endYear:-1];
		[self addAutoSubmodel:@"T2X" ofModel:modelId logo:logoId startYear:2005 endYear:-1];
		[self addAutoSubmodel:@"Tandem 2000" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
		[self addAutoSubmodel:@"Trailblazer SS" ofModel:modelId logo:logoId startYear:2002 endYear:-1];
		[self addAutoSubmodel:@"Trax" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"Triax" ofModel:modelId logo:logoId startYear:2000 endYear:-1];
		[self addAutoSubmodel:@"Tru 140S" ofModel:modelId logo:logoId startYear:2012 endYear:-1];
		[self addAutoSubmodel:@"Venture" ofModel:modelId logo:logoId startYear:1988 endYear:-1];
		[self addAutoSubmodel:@"Volt" ofModel:modelId logo:logoId startYear:2007 endYear:-1];
		[self addAutoSubmodel:@"Volt MPV5 Electric" ofModel:modelId logo:logoId startYear:2010 endYear:-1];
		[self addAutoSubmodel:@"Wedge Corvette" ofModel:modelId logo:logoId startYear:1963 endYear:-1];
		
		[self addAutoSubmodel:@"WTCC ULTRA" ofModel:modelId logo:logoId startYear:2006 endYear:-1];
		[self addAutoSubmodel:@"XT-2" ofModel:modelId logo:logoId startYear:1989 endYear:-1];
		[self addAutoSubmodel:@"YGM1" ofModel:modelId logo:logoId startYear:1999 endYear:-1];
	}
	
	modelId = [self addAutoModel:@"Prototypes" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
	{
		[self addAutoSubmodel:@"Corvette" ofModel:modelId logo:logoId startYear:1983 endYear:-1];
		[self addAutoSubmodel:@"Corvette ZR-1 Active Suspension" ofModel:modelId logo:logoId startYear:1990 endYear:-1];
	}
    
#pragma mark === UK ===
    countryId = [self addCountry:@"UK"];
#pragma mark |---- Bentley
    logoId = [self addLogo:@"bentley_256.png"];
    autoId = [self addAuto:@"Bentley" country:countryId logo:logoId independentId:BENTLEY];
    
    [self addAutoModel:@"Speed 8" ofAuto:autoId logo:logoId startYear:2001 endYear:-1];
	[self addAutoModel:@"Brooklands" ofAuto:autoId logo:logoId startYear:1992 endYear:1998];
	modelId = [self addAutoModel:@"Retro cars" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
	{
		[self addAutoSubmodel:@"Continental" ofModel:modelId logo:logoId startYear:1952 endYear:1965];
		[self addAutoSubmodel:@"Continental Flying Spur" ofModel:modelId logo:logoId startYear:1957 endYear:1966];
		[self addAutoSubmodel:@"Blower No.1" ofModel:modelId logo:logoId startYear:1931 endYear:1934];
		[self addAutoSubmodel:@"3 Litre" ofModel:modelId logo:logoId startYear:1921 endYear:1929];
		[self addAutoSubmodel:@"3.5 Litre" ofModel:modelId logo:logoId startYear:1933 endYear:1939];
		[self addAutoSubmodel:@"4 Litre" ofModel:modelId logo:logoId startYear:1931 endYear:-1];
		[self addAutoSubmodel:@"4.5 Litre" ofModel:modelId logo:logoId startYear:1927 endYear:1931];
		[self addAutoSubmodel:@"Speed Six" ofModel:modelId logo:logoId startYear:1929 endYear:1930];
		[self addAutoSubmodel:@"8 Litre" ofModel:modelId logo:logoId startYear:1930 endYear:1932];
		[self addAutoSubmodel:@"Arnage" ofModel:modelId logo:logoId startYear:1998 endYear:2009];
		[self addAutoSubmodel:@"Azure" ofModel:modelId logo:logoId startYear:1995 endYear:2003];
		[self addAutoSubmodel:@"Black Adder 6" ofModel:modelId logo:logoId startYear:0000 endYear:0];
		[self addAutoSubmodel:@"Blue Train" ofModel:modelId logo:logoId startYear:1928 endYear:-1];
		[self addAutoSubmodel:@"Mark V" ofModel:modelId logo:logoId startYear:1939 endYear:1941];
		[self addAutoSubmodel:@"Mark VI" ofModel:modelId logo:logoId startYear:1946 endYear:1952];
		[self addAutoSubmodel:@"R Type" ofModel:modelId logo:logoId startYear:1952 endYear:1955];
		[self addAutoSubmodel:@"S1" ofModel:modelId logo:logoId startYear:1955 endYear:1959];
		[self addAutoSubmodel:@"S2" ofModel:modelId logo:logoId startYear:1959 endYear:1962];
		[self addAutoSubmodel:@"S3" ofModel:modelId logo:logoId startYear:1962 endYear:1965];
	}
	
	modelId = [self addAutoModel:@"Continental" ofAuto:autoId logo:logoId startYear:1952 endYear:0];
	{
		[self addAutoSubmodel:@"Flying Spur	" ofModel:modelId logo:logoId startYear:1957 endYear:1966];
		[self addAutoSubmodel:@"Flying Spur	" ofModel:modelId logo:logoId startYear:2005 endYear:0];
		[self addAutoSubmodel:@"GT" ofModel:modelId logo:logoId startYear:2003 endYear:0];
		[self addAutoSubmodel:@"GTC" ofModel:modelId logo:logoId startYear:2003 endYear:0];
		[self addAutoSubmodel:@"R" ofModel:modelId logo:logoId startYear:1991 endYear:2003];
		[self addAutoSubmodel:@"S" ofModel:modelId logo:logoId startYear:1994 endYear:1995];
		[self addAutoSubmodel:@"T" ofModel:modelId logo:logoId startYear:1992 endYear:2002];
	}
    
	[self addAutoModel:@"Eight" ofAuto:autoId logo:logoId startYear:1984 endYear:1992];
	[self addAutoModel:@"EXP 9 F" ofAuto:autoId logo:logoId startYear:2012 endYear:-1];
	[self addAutoModel:@"Hunaudières" ofAuto:autoId logo:logoId startYear:1999 endYear:-1];
	[self addAutoModel:@"Java" ofAuto:autoId logo:logoId startYear:1994 endYear:-1];
	[self addAutoModel:@"Mulsanne" ofAuto:autoId logo:logoId startYear:1980 endYear:1992];
	[self addAutoModel:@"Mulsanne" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
	[self addAutoModel:@"State Limousine" ofAuto:autoId logo:logoId startYear:2002 endYear:-1];
	[self addAutoModel:@"T-series" ofAuto:autoId logo:logoId startYear:1965 endYear:1980];
	[self addAutoModel:@"Turbo R" ofAuto:autoId logo:logoId startYear:1985 endYear:1997];
	[self addAutoModel:@"Turbo RT" ofAuto:autoId logo:logoId startYear:1997 endYear:1999];
	[self addAutoModel:@"Turbo S" ofAuto:autoId logo:logoId startYear:1995 endYear:-1];
    
#pragma mark |---- Rolls Royce
    logoId = [self addLogo:@"rr_256.png"];
    autoId = [self addAuto:@"Rolls Royce" country:countryId logo:logoId independentId:ROLLSROYCE];
    
    modelId = [self addAutoModel:@"RR Limited" ofAuto:autoId logo:logoId startYear:0 endYear:0 isSelectable:NO];
    {
        [self addAutoSubmodel:@"10 hp" ofModel:modelId logo:logoId startYear:1904 endYear:1906];
        [self addAutoSubmodel:@"15 hp" ofModel:modelId logo:logoId startYear:1905 endYear:1905];
        [self addAutoSubmodel:@"20 hp" ofModel:modelId logo:logoId startYear:1905 endYear:1908];
        [self addAutoSubmodel:@"30 hp" ofModel:modelId logo:logoId startYear:1905 endYear:1906];
        [self addAutoSubmodel:@"V-8" ofModel:modelId logo:logoId startYear:1905 endYear:1906];
        [self addAutoSubmodel:@"40/50 Silver Ghost" ofModel:modelId logo:logoId startYear:1906 endYear:1925];
        [self addAutoSubmodel:@"Twenty" ofModel:modelId logo:logoId startYear:1922 endYear:1929];
        [self addAutoSubmodel:@"40/50 Phantom" ofModel:modelId logo:logoId startYear:1925 endYear:1929];
        [self addAutoSubmodel:@"20/25" ofModel:modelId logo:logoId startYear:1929 endYear:1936];
        [self addAutoSubmodel:@"Phantom II" ofModel:modelId logo:logoId startYear:1929 endYear:1935];
        [self addAutoSubmodel:@"25/30" ofModel:modelId logo:logoId startYear:1936 endYear:1938];
        [self addAutoSubmodel:@"Phantom III" ofModel:modelId logo:logoId startYear:1936 endYear:1939];
        [self addAutoSubmodel:@"Wraith" ofModel:modelId logo:logoId startYear:1938 endYear:1939];
        [self addAutoSubmodel:@"Silver Wraith" ofModel:modelId logo:logoId startYear:1946 endYear:1959];
        [self addAutoSubmodel:@"Silver Dawn" ofModel:modelId logo:logoId startYear:1949 endYear:1955];
        [self addAutoSubmodel:@"Phantom IV" ofModel:modelId logo:logoId startYear:1950 endYear:1956];
        [self addAutoSubmodel:@"Silver Cloud" ofModel:modelId logo:logoId startYear:1955 endYear:1966];
        [self addAutoSubmodel:@"Phantom V" ofModel:modelId logo:logoId startYear:1959 endYear:1968];
        [self addAutoSubmodel:@"Silver Shadow" ofModel:modelId logo:logoId startYear:1965 endYear:1980];
        [self addAutoSubmodel:@"Phantom VI" ofModel:modelId logo:logoId startYear:1968 endYear:1991];
        
        [self addAutoSubmodel:@"Corniche I–V" ofModel:modelId logo:logoId startYear:1971 endYear:1996];
        [self addAutoSubmodel:@"Silver Spirit" ofModel:modelId logo:logoId startYear:1980 endYear:1998];
    }
    
    [self addAutoModel:@"Camargue" ofAuto:autoId logo:logoId startYear:1975 endYear:1986];
    [self addAutoModel:@"Silver Spirit" ofAuto:autoId logo:logoId startYear:1980 endYear:1998];
    [self addAutoModel:@"Silver Spur" ofAuto:autoId logo:logoId startYear:1980 endYear:1998];
    [self addAutoModel:@"Silver Seraph" ofAuto:autoId logo:logoId startYear:1998 endYear:2002];
    [self addAutoModel:@"Corniche V" ofAuto:autoId logo:logoId startYear:2000 endYear:2002];
    [self addAutoModel:@"Phantom" ofAuto:autoId logo:logoId startYear:2003 endYear:0];
    [self addAutoModel:@"Phantom Drophead Coupé" ofAuto:autoId logo:logoId startYear:2007 endYear:0];
    [self addAutoModel:@"Phantom Coupé" ofAuto:autoId logo:logoId startYear:2008 endYear:0];
    [self addAutoModel:@"Ghost" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
    [self addAutoModel:@"Wraith" ofAuto:autoId logo:logoId startYear:2013 endYear:0];

#pragma mark |---- Aston Martin
    logoId = [self addLogo:@"astonmartin_256.png"];
    autoId = [self addAuto:@"Aston Martin" country:countryId logo:logoId independentId:ASTONMARTIN];
    
    [self addAutoModel:@"2-Litre Sports	" ofAuto:autoId logo:logoId startYear:1948 endYear:1950];
    [self addAutoModel:@"Atom" ofAuto:autoId logo:logoId startYear:1939 endYear:1944];
    [self addAutoModel:@"Bulldog" ofAuto:autoId logo:logoId startYear:1979 endYear:-1];
    [self addAutoModel:@"CC100" ofAuto:autoId logo:logoId startYear:2013 endYear:-1];
    [self addAutoModel:@"Cygnet" ofAuto:autoId logo:logoId startYear:2008 endYear:0];
    [self addAutoModel:@"DB AR1" ofAuto:autoId logo:logoId startYear:2003 endYear:2004];
    [self addAutoModel:@"DB2" ofAuto:autoId logo:logoId startYear:1950 endYear:1953];
    [self addAutoModel:@"DB2/4" ofAuto:autoId logo:logoId startYear:1953 endYear:1957];
    [self addAutoModel:@"DB Mark III" ofAuto:autoId logo:logoId startYear:1957 endYear:1959];
    
    modelId = [self addAutoModel:@"DB4" ofAuto:autoId logo:logoId startYear:1958 endYear:1963];
    {
        [self addAutoSubmodel:@"GT Zagato" ofModel:modelId logo:logoId startYear:1960 endYear:1963];
    }
    
    [self addAutoModel:@"DB5" ofAuto:autoId logo:logoId startYear:1963 endYear:1965];
    [self addAutoModel:@"DB6" ofAuto:autoId logo:logoId startYear:1965 endYear:1971];
    
    modelId = [self addAutoModel:@"DB7" ofAuto:autoId logo:logoId startYear:1994 endYear:2004];
    {
        [self addAutoSubmodel:@"Zagato" ofModel:modelId logo:logoId startYear:2002 endYear:2003];
    }
    
    [self addAutoModel:@"DB9" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
    
    modelId = [self addAutoModel:@"DBS" ofAuto:autoId logo:logoId startYear:1967 endYear:1972];
    {
        [self addAutoSubmodel:@"V12" ofModel:modelId logo:logoId startYear:2007 endYear:2012];
    }
    
    [self addAutoModel:@"Halford Special" ofAuto:autoId logo:logoId startYear:1922 endYear:-1];
    [self addAutoModel:@"Lagonda" ofAuto:autoId logo:logoId startYear:1976 endYear:1990];
    [self addAutoModel:@"Le Mans" ofAuto:autoId logo:logoId startYear:1932 endYear:1934];
    [self addAutoModel:@"Lola B08/60" ofAuto:autoId logo:logoId startYear:1992 endYear:0];
    [self addAutoModel:@"Lola B11/40" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
    [self addAutoModel:@"One-77" ofAuto:autoId logo:logoId startYear:2009 endYear:2012];
    
    modelId = [self addAutoModel:@"DBS" ofAuto:autoId logo:logoId startYear:1967 endYear:1972];
    {
        [self addAutoSubmodel:@"V12" ofModel:modelId logo:logoId startYear:2007 endYear:2012];
    }
    
    modelId = [self addAutoModel:@"Rapide" ofAuto:autoId logo:logoId startYear:2010 endYear:0];
    {
        [self addAutoSubmodel:@"Bertone Jet" ofModel:modelId logo:logoId startYear:2013 endYear:-1];
    }
    
    [self addAutoModel:@"Razor Blade" ofAuto:autoId logo:logoId startYear:1923 endYear:-1];
    [self addAutoModel:@"Short Chassis Volante" ofAuto:autoId logo:logoId startYear:1965 endYear:1966];
    
    modelId = [self addAutoModel:@"V12 Vantage" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
    {
        [self addAutoSubmodel:@"RS" ofModel:modelId logo:logoId startYear:2006 endYear:0];
    }
    
    modelId = [self addAutoModel:@"V8" ofAuto:autoId logo:logoId startYear:1969 endYear:0];
    {
        [self addAutoSubmodel:@"Vantage" ofModel:modelId logo:logoId startYear:1989 endYear:2000];
        [self addAutoSubmodel:@"Vantage" ofModel:modelId logo:logoId startYear:1977 endYear:1989];
        [self addAutoSubmodel:@"Zagato" ofModel:modelId logo:logoId startYear:1986 endYear:1990];
    }
    
    modelId = [self addAutoModel:@"Vantage" ofAuto:autoId logo:logoId startYear:2005 endYear:0];
    {
        [self addAutoSubmodel:@"GT2" ofModel:modelId logo:logoId startYear:2008 endYear:0];
        [self addAutoSubmodel:@"GT4" ofModel:modelId logo:logoId startYear:2008 endYear:0];
        [self addAutoSubmodel:@"N24" ofModel:modelId logo:logoId startYear:2008 endYear:0];
    }
    
    [self addAutoModel:@"Vanquish" ofAuto:autoId logo:logoId startYear:2001 endYear:0];
    [self addAutoModel:@"VH platform" ofAuto:autoId logo:logoId startYear:2004 endYear:0];
    [self addAutoModel:@"Virage" ofAuto:autoId logo:logoId startYear:1993 endYear:2000];
    [self addAutoModel:@"Volante" ofAuto:autoId logo:logoId startYear:1996 endYear:0];
    
#pragma mark === Ukraine ===
    countryId = [self addCountry:@"Ukraine"];
#pragma mark |---- Bogdan
    logoId = [self addLogo:@"bogdan_256.png"];
    autoId = [self addAuto:@"Bogdan" country:countryId logo:logoId independentId:BOGDAN];
    
    [self addAutoModel:@"Bus" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"Trolleybus" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"A092" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"A092.80" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"A1445" ofAuto:autoId logo:logoId startYear:0 endYear:0];
	[self addAutoModel:@"T601" ofAuto:autoId logo:logoId startYear:0 endYear:0];
    // V
#pragma mark -
#pragma mark V
    // W
#pragma mark -
#pragma mark W
    // X
#pragma mark -
#pragma mark X
    // Y
#pragma mark -
#pragma mark Z
    // Z
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
            DLog(@"Added country: %@", name);
        } else {
            DLog(@"Failed to add country %@", name);
            DLog(@"Info:%s", sqlite3_errmsg(instacarDb));
        }
    } else {
        DLog(@"Error:%s", sqlite3_errmsg(instacarDb));
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
            DLog(@"Added logo: %@", filename);
        } else {
            DLog(@"Failed to add logo %@", filename);
            DLog(@"Info:%s", sqlite3_errmsg(instacarDb));
        }
    } else {
        DLog(@"Error:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return [self getIdForLogo:filename];
}

-(int)addAuto:(NSString*)name country:(int)countryId logo:(int)logoId independentId:(int)indId{
    return [self addAuto:name country:countryId logo:logoId logoIsName:false independentId:indId];
}

-(int)addAuto:(NSString*)name country:(int)countryId logoAsName:(int)logoId independentId:(int)indId{
    return [self addAuto:name country:countryId logo:logoId logoIsName:true independentId:indId];
}

-(int)addAuto:(NSString*)name country:(int)countryId logo:(int)logoId logoIsName:(bool)logoIsName independentId:(int)indId{
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@, %@, %@) VALUES (?, %d, %d, %d, %d)", T_AUTOS, F_NAME, F_COUNTRY_ID, F_LOGO_ID, F_LOGO_IS_NAME, F_IND_ID, countryId, logoId, logoIsName, indId];
    
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            DLog(@"Added auto: %@", name);
        } else {
            DLog(@"Failed to add auto %@", name);
            DLog(@"Info:%s", sqlite3_errmsg(instacarDb));
        }
    } else {
        DLog(@"Error:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
    
    return [self getIdForAuto:name country:countryId];
}

-(int)addAutoModel:(NSString*)name ofAuto:(int)autoId logo:(int)logoId startYear:(int)startYear endYear:(int)endYear{
    return [self addAutoModel:name ofAuto:autoId logo:logoId startYear:startYear endYear:endYear isSelectable:YES];
}

-(int)addAutoModel:(NSString*)name ofAuto:(int)autoId logo:(int)logoId startYear:(int)startYear endYear:(int)endYear isSelectable:(BOOL)isSelectable{
    return [self addCustomAutoModel:name ofAuto:autoId logo:logoId startYear:startYear endYear:endYear isSelectable:isSelectable];
}

-(int)addCustomAutoModel:(NSString*)name ofAuto:(int)autoId logo:(int)logoId startYear:(int)startYear endYear:(int)endYear isSelectable:(BOOL)isSelectable{
    NSAssert(name, @"Auto model name cannot be null");
    NSAssert(name.length > 0, @"Auto model name cannot be empty");
    
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@) VALUES (?, %d, %d, %d, %d, %d, 0)", T_MODELS, F_NAME, F_AUTO_ID, F_LOGO_ID, F_YEAR_START, F_YEAR_END, F_SELECTABLE, F_IS_USER_DEFINED, autoId, logoId, startYear, endYear, isSelectable];
    
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

-(void)addAutoSubmodel:(NSString*)name ofModel:(int)modelId logo:(int)logoId startYear:(int)startYear endYear:(int)endYear{
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@, %@, %@) VALUES (?, %d, %d, %d, %d)", T_SUBMODELS, F_NAME, F_MODEL_ID, F_LOGO_ID, F_YEAR_START, F_YEAR_END, modelId, logoId, startYear, endYear];
    
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(instacarDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            DLog(@"Added submodel: %@", name);
        } else {
            DLog(@"Failed to add submodel %@", name);
            DLog(@"Info:%s", sqlite3_errmsg(instacarDb));
        }
    } else {
        DLog(@"Error:%s", sqlite3_errmsg(instacarDb));
    }
    sqlite3_finalize(statement);
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
            DLog(@"Country not found");
        }
    } else {
        DLog(@"Error getting id for Country:%s", sqlite3_errmsg(instacarDb));
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

@end