//
//  SkinCmdNoCommands.m
//  InstaCar
//
//  Created by VRS on 20/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinCmdNoCommands.h"

@implementation SkinCmdNoCommands

-(BOOL)isPro{
    return NO;
}

-(UIView*)getCmdView{
    return 0;
}

-(void)cmdViewShown{
}

-(void)execute{
}

-(void)prepare{
}

-(UIImage*)getIcon{
    return [UIImage imageNamed:@"imgCmdInfo"];
}

-(NSString*)getTitle{
    return @"No actions";
}

@end
