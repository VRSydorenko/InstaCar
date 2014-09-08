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
        _logoName = logo;
        _country = country;
        _model = nil;
        _logoAsName = logoAsName;
    }
    return self;
}

-(NSString*)selectedText{ // specific formatting
    NSString *autoName = self.logoAsName ? @"" : self.name;
    if (self.model){
        if (self.model.submodel){
            return [NSString stringWithFormat:@"%@ %@", (self.model.isSelectable ? self.model.name : autoName), self.model.submodel.name];
        } else {
            return [NSString stringWithFormat:@"%@ %@", autoName, self.model.name];
        }
    }
    return self.name;
}

-(NSString*)selectedTextMarkModel{
    if (self.model && self.model.isSelectable){
        return [NSString stringWithFormat:@"%@ %@", self.name, self.model.name];
    }
    return self.name;
}

-(NSString*)selectedTextModel{
    if (self.model){
        return self.model.name;
    }
    return @"";
}

-(NSString*)selectedTextModelSubmodel{
    if (self.model){
        NSString *modelName = self.model.isSelectable ? self.model.name : @"";
        NSString *submodelName = self.model.submodel
        ?
        [NSString stringWithFormat:@"%@%@", modelName.length > 0 ? @" " : @"", self.model.submodel.name]
        :
        @"";
        return [NSString stringWithFormat:@"%@%@", modelName, submodelName];
    }
    return @"";
}

-(UIImage*)logo128{
    NSString *logoFileName = [NSString stringWithFormat:@"%@_128.png", self.logoName];
    return [UIImage imageNamed:logoFileName];
}

-(UIImage*)logo256{
    NSString *logoFileName = [NSString stringWithFormat:@"%@_256.png", self.logoName];
    return [UIImage imageNamed:logoFileName];
}

-(CGFloat)logoWidthHeightRate{
    UIImage *logoImage = nil;
    if (self.model){
        if (self.model.submodel){
            logoImage = self.model.submodel.logo128;
        } else {
            logoImage = self.model.logo128;
        }
    }
    
    if (nil == logoImage){
        logoImage = self.logo128;
    }
    
    return MIN(logoImage.size.width / logoImage.size.height, 1.5);
}

@end
