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
        ann.location.countryCode = v[@"location"][@"cc"];
        ann.location.country = v[@"location"][@"country"];
        ann.location.state = v[@"location"][@"state"];
        ann.location.city = v[@"location"][@"city"];

        NSArray *categories = [v objectForKey:@"categories"];
        if (categories && categories.count > 0){
            NSDictionary *catsDic = [categories objectAtIndex:0];
            if (catsDic && catsDic.count > 0){
                NSString *prefix = catsDic[@"icon"][@"prefix"];
                NSString *suffix = catsDic[@"icon"][@"suffix"];
                if (prefix && suffix){
                    ann.iconURL = [NSString stringWithFormat:@"%@64%@", prefix, suffix];
                }
            }
        }
        
        [ann.location setCoordinate:CLLocationCoordinate2DMake([v[@"location"][@"lat"] doubleValue],
                                                               [v[@"location"][@"lng"] doubleValue])];
        [objects addObject:ann];
    }

    return objects;
}

@end
