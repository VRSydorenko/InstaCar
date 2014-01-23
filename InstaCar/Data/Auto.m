//
//  Auto.m
//  InstaCar
//
//  Created by VRS on 8/26/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "Auto.h"

@implementation Auto

-(id)initWithId:(int)_id name:(NSString*)name logo:(NSString*)logo logoAsName:(BOOL)logoAsName country:(NSString*)country{
    self = [super init];
    if (self){
        __id = _id;
        _name = name;
        _logo = logo;
        _country = country;
        _model = nil;
        _logoAsName = logoAsName;
    }
    return self;
}

-(NSString*)selectedText{
    if (self.model){
        if (self.model.submodel){
            return [NSString stringWithFormat:@"%@ %@", self.model.isSelectable?self.model.name:self.name, self.model.submodel.name];
        } else {
            return [NSString stringWithFormat:@"%@ %@", self.name, self.model.name];
        }
    }
    return self.name;
}

-(CGFloat)logoWidthHeightRate{
    NSString *logoName = self.logo;
    if (self.model){
        if (self.model.submodel){
            logoName = self.model.submodel.logo;
        } else {
            logoName = self.model.logo;
        }
    }
    UIImage *logoImage = [UIImage imageNamed:logoName];
    
    return MIN(logoImage.size.width / logoImage.size.height, 1.5);
}

@end
