//
//  DBDefinition.h
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATABASE_NAME @"instacardb.sqlite"

#define DBTYPE_TEXT @"text"
#define DBTYPE_REAL @"real"
#define DBTYPE_INT  @"integer"
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
#define F_IND_ID @"f_ind_id"

#define T_MODELS @"t_models"
#define F_AUTO_ID @"f_auto_id"
#define F_YEAR_START @"f_year_start"
#define F_YEAR_END @"f_year_end"
#define F_SELECTABLE @"f_is_selectable"
#define F_IS_USER_DEFINED @"f_is_user_defined"
// F_LOGO_ID
// F_NAME

#define T_SUBMODELS @"t_submodels"
#define F_MODEL_ID @"f_model_id"
// F_NAME
// F_LOGO_ID
// F_YEAR_START
// F_YEAR_END

#define T_COUNTRIES @"t_countries"
// F_NAME

#define T_ICONS @"t_icons"
#define F_FILENAME @"f_filename"
#define F_DATA @"f_data"

#pragma mark -

@interface DBDefinition : NSObject

-(NSArray*) getTablesCreationQueries;

@end
