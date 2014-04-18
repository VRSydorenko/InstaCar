//
//  DbHelper.h
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"

#define DATABASE_NAME_FREE @"instacardb"
#define DATABASE_NAME_PRO @"instacarprodb"
#define DATABASE_NAME_RES @"db" // name of the attached db file 

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
#define F_LOGO_AS_NAME @"f_logo_as_name"
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

@interface DbManager : NSObject

-(id) init;
-(void) close;

#pragma mark Custom methods

-(int)addCustomAutoModel:(NSString*)name ofAuto:(int)autoId logo:(NSString*)logoFileName startYear:(int)startYear endYear:(int)endYear;
-(int)getIdOfAutoTheModelBelongsTo:(int)modelId;
-(void)deleteCustomAutoModel:(int)modelId;
-(void)deleteCustomModelsOfAuto:(int)autoId;
-(NSArray*)getAllAutos; // type: Auto
-(NSInteger)getModelsCountForAuto:(NSUInteger)autoId;
-(NSArray*)getBuiltInModelsOfAuto:(NSUInteger)autoId; // type: AutoModel
-(NSArray*)getUserDefinedModelsOfAuto:(NSUInteger)autoId; // type: AutoModel
-(NSInteger)getSubmodelsCountOfModel:(NSUInteger)modelId;
-(NSArray*)getSubmodelsOfModel:(NSUInteger)modelId; // type: AutoSubmodel
-(UIImage*)getIconForPath:(NSString*)path;
-(int)getIdOfAutoWithIndependentId:(NSUInteger)indId;
-(int)getIndependentIdOfAutoWithDbId:(NSUInteger)dbId;

-(void)addIcon:(UIImage*)icon forPath:(NSString*)iconPath;

@end
