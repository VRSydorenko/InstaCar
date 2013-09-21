    //
//  SHKSharer.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/8/10.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "SHKSharer.h"

#import "SHKSharerDelegate.h"
#import "SHKRequest.h"
#import "SharersCommonHeaders.h"

static NSString *const kSHKStoredItemKey=@"kSHKStoredItem";
static NSString *const kSHKStoredActionKey=@"kSHKStoredAction";
static NSString *const kSHKStoredShareInfoKey=@"kSHKStoredShareInfo";

@interface SHKSharer ()

- (void)updateItemWithForm:(SHKFormController *)form;

@end

@implementation SHKSharer

#pragma mark -
#pragma mark Configuration : Service Defination

// Each service should subclass these and return YES/NO to indicate what type of sharing they support.
// Superclass defaults to NO so that subclasses only need to add methods for types they support

+ (NSString *)sharerTitle
{
	return @"";
}

- (NSString *)sharerTitle
{
	return [[self class] sharerTitle];
}

+ (NSString *)sharerId
{
	return NSStringFromClass([self class]);
}

- (NSString *)sharerId
{
	return [[self class] sharerId];	
}

+ (BOOL)canShareText
{
	return NO;
}

+ (BOOL)canShareURL
{
	return NO;
}

- (BOOL)requiresShortenedURL
{
    return NO;
}

+ (BOOL)canShareImage
{
	return NO;
}

+ (BOOL)canShareFile:(SHKFile *)file;
{
	return NO;
}

+ (BOOL)canGetUserInfo
{
    return NO;
}

+ (BOOL)shareRequiresInternetConnection
{
	return YES;
}

+ (BOOL)canShareOffline
{
	return YES;
}

+ (BOOL)requiresAuthentication
{
	return YES;
}

+ (BOOL)canShareItem:(SHKItem *)item
{
	switch (item.shareType)
	{
		case SHKShareTypeURL:
			return [self canShareURL];
			
		case SHKShareTypeImage:
			return [self canShareImage];
			
		case SHKShareTypeText:
			return [self canShareText];
			
		case SHKShareTypeFile:
			return [self canShareFile:item.file];
            
        case SHKShareTypeUserInfo:
			return [self canGetUserInfo];
			
		default: 
			break;
	}
	return NO;
}

+ (BOOL)canAutoShare
{
	return YES;
}



#pragma mark -
#pragma mark Configuration : Dynamic Enable

// Allows a subclass to programically disable/enable services depending on the current environment

+ (BOOL)canShare
{
	return YES;
}

- (BOOL)shouldAutoShare
{	
	return [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_shouldAutoShare", [self sharerId]]];
}

#pragma mark -
#pragma mark Initialization

- (id)init
{
	if (self = [super initWithNibName:nil bundle:nil])
	{
        self.shareDelegate = [[SHKSharerDelegate alloc] init];
				
		if ([self respondsToSelector:@selector(modalPresentationStyle)])
			self.modalPresentationStyle = [SHK modalPresentationStyleForController:self];
		
		if ([self respondsToSelector:@selector(modalTransitionStyle)])
			self.modalTransitionStyle = [SHK modalTransitionStyleForController:self];
	}
	return self;
}


#pragma mark -
#pragma mark Share Item Loading Convenience Methods

+ (id)shareItem:(SHKItem *)i
{
	[SHK pushOnFavorites:[self sharerId] forItem:i];
	
	// Create controller and set share options
	SHKSharer *controller = [[self alloc] init];
	controller.item = i;
	
	// share and/or show UI
	[controller share];
	
	return controller;
}

- (void)loadItem:(SHKItem *)i
{
	[SHK pushOnFavorites:[self sharerId] forItem:i];
	
	// Create controller set share options
	self.item = i;
}

+ (id)shareURL:(NSURL *)url
{
	return [self shareURL:url title:nil];
}

+ (id)shareURL:(NSURL *)url title:(NSString *)title
{
    SHKItem *item = [SHKItem URL:url title:title contentType:SHKURLContentTypeWebpage];
    
    // Create controller and set share options
	SHKSharer *controller = [[self alloc] init];
    [controller loadItem:item];

	// share and/or show UI
	[controller share];

	return controller;
}

+ (id)shareImage:(UIImage *)image title:(NSString *)title
{
    SHKItem *item = [SHKItem image:image title:title];
	
    // Create controller and set share options
	SHKSharer *controller = [[self alloc] init];
    [controller loadItem:item];
	
	// share and/or show UI
	[controller share];
	
	return controller;
}

+ (id)shareText:(NSString *)text
{
	SHKItem *item = [SHKItem text:text];
    // Create controller and set share options
	SHKSharer *controller = [[self alloc] init];
    [controller loadItem:item];
	
	// share and/or show UI
	[controller share];
	
	return controller;
}

+ (id)shareFile:(NSData *)file filename:(NSString *)filename mimeType:(NSString *)mimeType title:(NSString *)title
{
    return [[self class] shareFileData:file filename:filename title:title];
}

+ (id)shareFileData:(NSData *)data filename:(NSString *)filename title:(NSString *)title
{
    SHKItem *item = [SHKItem fileData:data filename:filename title:title];
    
    // Create controller and set share options
	SHKSharer *controller = [[self alloc] init];
    [controller loadItem:item];
	
	// share and/or show UI
	[controller share];
	
	return controller;
}

+ (id)shareFilePath:(NSString *)path title:(NSString *)title
{
    SHKItem *item = [SHKItem filePath:path title:title];
    
    // Create controller and set share options
	SHKSharer *controller = [[self alloc] init];
    [controller loadItem:item];
	
	// share and/or show UI
	[controller share];
	
	return controller;
}

+ (id)getUserInfo
{
    SHKItem *item = [[SHKItem alloc] init];
    item.shareType = SHKShareTypeUserInfo;
    
    // Create controller and set share options
	SHKSharer *controller = [[self alloc] init];
	controller.item = item;
    
	// share and/or show UI
	[controller share];
    
    return controller;
}

#pragma mark -
#pragma mark Commit Share

- (void)share
{
    [self send];
}

#pragma mark -

- (NSString *)tagStringJoinedBy:(NSString *)joinString allowedCharacters:(NSCharacterSet *)charset tagPrefix:(NSString *)prefixString tagSuffix:(NSString *)suffixString {
    
    NSMutableArray *cleanedTags = [NSMutableArray arrayWithCapacity:[self.item.tags count]];
    NSCharacterSet *removeSet = [charset invertedSet];
    
    for (NSString *tag in self.item.tags) {
        
        NSString *strippedTag;
        if (removeSet) {
            strippedTag = [[tag componentsSeparatedByCharactersInSet:removeSet] componentsJoinedByString:@""];
        } else {
            strippedTag = tag;
        }
                                 
        if ([strippedTag length] < 1) continue;
        strippedTag = [strippedTag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([strippedTag length] < 1) continue;
        
        if ([prefixString length] > 0) {
            strippedTag = [prefixString stringByAppendingString:strippedTag];
        }
        
        if ([suffixString length] > 0) {
            strippedTag = [strippedTag stringByAppendingString:suffixString];
        }
        
        [cleanedTags addObject:strippedTag];
    }
    
    if ([cleanedTags count] < 1) return @"";
    return [cleanedTags componentsJoinedByString:joinString];
}

#pragma mark -
#pragma mark API Implementation

- (BOOL)validateItem
{
	switch (self.item.shareType)
	{
		case SHKShareTypeURL:
			return (self.item.URL != nil);
			
		case SHKShareTypeImage:
			return (self.item.image != nil);
			
		case SHKShareTypeText:
			return (self.item.text != nil);
			
		case SHKShareTypeFile:
			return (self.item.file != nil);
            
        case SHKShareTypeUserInfo:
            return [[self class] canGetUserInfo];
		default:
			break;
	}
	
	return NO;
}

- (BOOL)send
{	
	// Does not actually send anything.
	// Your subclass should implement the sending logic.
	// There is no reason to call [super send] in your subclass
	
	// You should never call [XXX send] directly, you should use [XXX tryToSend].  TryToSend will perform an online check before trying to send.
	return NO;
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

#pragma mark -
#pragma mark Delegate Notifications

- (void)sendDidStart
{		
    [[NSNotificationCenter defaultCenter] postNotificationName:SHKSendDidStartNotification object:self];
    
	if ([self.shareDelegate respondsToSelector:@selector(sharerStartedSending:)])
		[self.shareDelegate performSelector:@selector(sharerStartedSending:) withObject:self];	
}

- (void)sendDidFinish
{	
	[[NSNotificationCenter defaultCenter] postNotificationName:SHKSendDidFinishNotification object:self];

    if ([self.shareDelegate respondsToSelector:@selector(sharerFinishedSending:)])
		[self.shareDelegate performSelector:@selector(sharerFinishedSending:) withObject:self];
	}

- (void)sendDidFailWithError:(NSError *)error
{
	[self sendDidFailWithError:error shouldRelogin:NO];	
}

- (void)sendDidFailWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
	self.lastError = error;
    
	[[NSNotificationCenter defaultCenter] postNotificationName:SHKSendDidFailWithErrorNotification object:self];    
}

- (void)sendDidCancel
{
	[[NSNotificationCenter defaultCenter] postNotificationName:SHKSendDidCancelNotification object:self];
    
    if ([self.shareDelegate respondsToSelector:@selector(sharerCancelledSending:)])
		[self.shareDelegate performSelector:@selector(sharerCancelledSending:) withObject:self];	
}

- (void)authDidFinish:(BOOL)success	
{
	[[NSNotificationCenter defaultCenter] postNotificationName:SHKAuthDidFinishNotification object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:success] forKey:@"success"]];
    
    if ([self.shareDelegate respondsToSelector:@selector(sharerAuthDidFinish:success:)]) {		
        [self.shareDelegate sharerAuthDidFinish:self success:success];
    }
}

- (void)sendShowSimpleErrorAlert {
    [self sendDidFailWithError:[SHK error:@"There was a problem saving to %@", [[self class] sharerTitle]]];
}

@end