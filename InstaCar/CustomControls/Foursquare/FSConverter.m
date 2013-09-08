//
//  FSConverter.m
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 2/7/13.
//
//

#import "FSConverter.h"
#import "FSVenue.h"

@implementation FSConverter

-(NSArray*)convertToObjects:(NSArray*)venues{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:venues.count];
    for (NSDictionary *v  in venues) {
        FSVenue *ann = [[FSVenue alloc]init];
        
        ann.name = v[@"name"];
        ann.venueId = v[@"id"];
        ann.location.address = v[@"location"][@"address"];
        ann.location.distance = v[@"location"][@"distance"];

        ann.iconURL = @"https://foursquare.com/img/categories_v2/parks_outdoors/plaza_64.png";
        //ann.iconURL = [NSString stringWithFormat:@"%@bg_64%@", v[@"categories"][@"icon"][@"prefix"], v[@"categories"][@"icon"][@"suffix"]];
        // TODO: save to db and load then
        
        [ann.location setCoordinate:CLLocationCoordinate2DMake([v[@"location"][@"lat"] doubleValue],
                                                               [v[@"location"][@"lng"] doubleValue])];
        [objects addObject:ann];
    }
    return objects;
}

@end
