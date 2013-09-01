//
//  DBDefinition.h
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATABASE_NAME @"instacar.db"

#define DBTYPE_TEXT @"text"
#define DBTYPE_REAL @"real"
#define DBTYPE_BOOL @"boolean"
#define DBTYPE_BLOB @"blob"

#define F_ID @"_id"

#pragma mark -
#pragma mark Database structure

#define T_LOGOS @"t_logos"
#define F_NAME @"f_name"

#define T_AUTOS @"t_autos"
#define F_COUNTRY_ID @"f_country_id"
#define F_LOGO_ID @"f_logo_id"
// F_NAME

#define T_MODELS @"t_models"
#define F_AUTO_ID @"f_auto_id"
#define F_YEAR_START @"f_year_start"
#define F_YEAR_END @"f_year_end"
// F_LOGO_ID
// F_NAME

#define T_COUNTRIES @"t_coutries"
// F_NAME

#pragma mark -

@interface DBDefinition : NSObject

-(NSString*) getTablesCreationSQL;
-(NSString*) getTablesDropSQL;

@end
