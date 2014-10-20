//
//  SkinCommandProvider.m
//  InstaCar
//
//  Created by VRS on 18/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import "SkinCommandProvider.h"

#import "SkinCommandProtocol.h"
#import "SkinCmdTextEditor.h"
#import "SkinCmdPrefixEditor.h"
#import "SkinCmdRatingEditor.h"
#import "SkinCmdInvertColors.h"

@implementation SkinCommandProvider

+(SkinCommandProvider*)getInstance{
    static SkinCommandProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SkinCommandProvider alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    self = [super init];
    if (self){
        [self initCommands];
    }
    return self;
}

-(void)initCommands{
    NSMutableDictionary *cmdDict = [[NSMutableDictionary alloc] init];
    // load UI commands from NIB
    /*NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"SkinCommands" owner:self options:nil];
    DLog(@"SkinCommands Bundle objects: %lu",(unsigned long)bundle.count);
    
    for (id object in bundle) {
        SkinCommand *cmd = nil;
        if ([object isKindOfClass:[SkinCmdTextEditor class]]){
            cmd = (SkinCmdTextEditor*)object;
        }
        
        NSAssert(cmd, @"Undefined skin command!");
        
        NSNumber *cmdTypeAsNumber = [NSNumber numberWithInt:[cmd getCommandType]];
        assert(![cmdDict.allKeys containsObject:cmdTypeAsNumber]); // each command only once
        
        [cmdDict setObject:cmd forKey:cmdTypeAsNumber];
    }*/
    
    SkinCommand *
    cmdUI = [[SkinCmdTextEditor alloc] init];
    [cmdDict setObject:cmdUI forKey:[NSNumber numberWithInt:COMMAND_EDITTEXT]];
    cmdUI = [[SkinCmdPrefixEditor alloc] init];
    [cmdDict setObject:cmdUI forKey:[NSNumber numberWithInt:COMMAND_EDITPREFIX]];
    cmdUI = [[SkinCmdRatingEditor alloc] init];
    [cmdDict setObject:cmdUI forKey:[NSNumber numberWithInt:COMMAND_EDITRATING]];
    
    // add simple commands
    SkinCommand *
    cmd = [[SkinCmdInvertColors alloc] init];
    [cmdDict setObject:cmd forKey:[NSNumber numberWithInt:COMMAND_INVERTCOLORS]];
    
    // init internal array
    skinCommands = [[NSDictionary alloc] initWithDictionary:cmdDict];
}

-(SkinCommand*)getCommand:(NSNumber*)cmdId{
    return [skinCommands objectForKey:cmdId];
}

@end
