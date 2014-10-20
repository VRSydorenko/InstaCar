//
//  SkinCommandProtocol.h
//  InstaCar
//
//  Created by VRS on 18/10/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    COMMAND_NOCOMMANDS = 0, // default command
    COMMAND_INVERTCOLORS,
    COMMAND_EDITTEXT, // UI
    COMMAND_EDITPREFIX, // UI
    COMMAND_EDITRATING, // UI
} SkinCmdTypes;

@protocol SkinCommandContainerDelegate <NSObject>
-(void)skinCommandOnExecuted;
@end

@protocol SkinCommandDelegate <NSObject>
-(void)onCmdInvertColors;
-(void)onCmdEditText:(NSString*)newText;
-(void)onCmdEditPrefix:(NSString*)newPrefix;
-(void)onCmdEditRaiting:(int)newRaiting;

-(NSString*)getSkinContentText;
-(NSString*)getSkinPrefixText;
-(int)getSkinRaiting;
-(BOOL)getAllowsEmptyContentText;
@end

typedef NSObject<SkinCommandDelegate> SkinCommandDelegate;
typedef NSObject<SkinCommandContainerDelegate> SkinCommandContainerDelegate;

@protocol SkinCommandProtocol <NSObject>
-(BOOL)isPro;
-(UIView*)getCmdView;
-(void)execute;
-(void)prepare;
-(UIImage*)getIcon;
-(NSString*)getTitle;
@property (nonatomic) SkinCommandDelegate *delegate;
@property (nonatomic) SkinCommandContainerDelegate *container;
@end

typedef NSObject<SkinCommandProtocol> SkinCommand;