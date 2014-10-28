//
//  SkinCmdInvertColors.m
//  InstaCar
//
//  Created by VRS on 19/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinCmdInvertColors.h"

@implementation SkinCmdInvertColors

-(BOOL)isPro{
    return NO;
}

-(UIView*)getCmdView{
    return nil;
}

-(void)cmdViewShown{
}

-(void)execute{
    assert(self.delegate);
    
    [self.delegate onCmdInvertColors];
}

-(void)prepare{
}

-(UIImage*)getIcon{
    return [UIImage imageNamed:@"imgCmdInvert"];
}

-(NSString*)getTitle{
    return @"Invert";
}

@end
