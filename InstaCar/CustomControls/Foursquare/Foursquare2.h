//
//  Foursquare2.h
//  Foursquare API
//
//  Created by Constantine Fry on 1/7/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSRequester.h"

//update this date to use up-to-date Foursquare API
#ifndef FS2_API_VERSION
#define FS2_API_VERSION (@"20130117")
#endif


#define FS2_API_BaseUrl @"https://api.foursquare.com/v2/"

typedef void(^Foursquare2Callback)(BOOL success, id result);

typedef enum {
	sortRecent,
	sortNearby,
	sortPopular
} FoursquareSortingType;

typedef enum {
	problemMislocated,
	problemClosed,
	problemDuplicate
} FoursquareProblemType;

typedef enum {
	broadcastPrivate,
	broadcastPublic,
	broadcastFacebook,
	broadcastTwitter,
	broadcastBoth
} FoursquareBroadcastType;

typedef enum {
	intentCheckin,
	intentBrowse,
	intentGlobal,
	intentMatch
} FoursquareIntentType;

@interface Foursquare2 : FSRequester {
	
}

+(void)setBaseURL:(NSString *)uri;
+(void)setAccessToken:(NSString*)token;
+(void)removeAccessToken;
+(BOOL)isNeedToAuthorize;
+(BOOL)isAuthorized;

#pragma mark -

+ (void)setupFoursquareWithKey:(NSString *)key
                        secret:(NSString *)secret
                   callbackURL:(NSString *)callbackURL;


#pragma mark Venues

+(void)getDetailForVenue:(NSString*)venueID
				callback:(Foursquare2Callback)callback;

+(void)addVenueWithName:(NSString*)name
				address:(NSString*)address
			crossStreet:(NSString*)crossStreet
				   city:(NSString*)city
				  state:(NSString*)state
					zip:(NSString*)zip
				  phone:(NSString*)phone
			   latitude:(NSString*)lat
			  longitude:(NSString*)lon
	  primaryCategoryId:(NSString*)primaryCategoryId
			   callback:(Foursquare2Callback)callback;

+(void)getVenueCategoriesCallback:(Foursquare2Callback)callback;

+(void)searchVenuesNearByLatitude:(NSNumber*) lat
						longitude:(NSNumber*)lon
					   accuracyLL:(NSNumber*)accuracyLL
						 altitude:(NSNumber*)altitude
					  accuracyAlt:(NSNumber*)accuracyAlt
							query:(NSString*)query
							limit:(NSNumber*)limit
						   intent:(FoursquareIntentType)intent
                           radius:(NSNumber*)radius
                       categoryId:(NSString*)categoryId
						 callback:(Foursquare2Callback)callback;

+(void)searchVenuesInBoundingQuadrangleS:(NSNumber*)s
                                       w:(NSNumber*)w
                                       n:(NSNumber*)n
                                       e:(NSNumber*)e
                                   query:(NSString*)query
                                   limit:(NSNumber*)limit
                                callback:(Foursquare2Callback)callback;


@end
