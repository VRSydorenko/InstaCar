//
//  SkinViewBase.m
//  InstaCar
//
//  Created by VRS on 8/28/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SkinViewBase.h"
#import "Utils.h"
#import "DrawingElementProtocolBase.h"

@implementation SkinViewBase

#pragma mark Initialization

-(void)setupGradient:(CGFloat)alpha inDirection:(GradientDirection)direction{
    return; // CURRENTLY DISABLED AT ALL
    if (!gradient){
        gradient = [[UIAlphaGradientView alloc] initWithFrame:self.frame];
        gradient.color = [UIColor blackColor];
        gradient.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    
    gradient.direction = direction;
    gradient.alpha = alpha;
    
    if (!gradientInitialized){
        [self addSubview:gradient];
        [self sendSubviewToBack:gradient];
        gradientInitialized = YES;
    }
}

#pragma mark -

-(BOOL) canEditField:(SkinField)field{
    switch (field) {
        case fLOCATION:
            return canEditFieldLocation;
        case fAUTO1:
            return canEditFieldAuto1;
        case fAUTO2:
            return canEditFieldAuto2;
        case fTEXT1:
            return canEditFieldText1;
        case fTEXT2:
            return canEditFieldText2;
        default:
            return NO;
    }
}

-(void) updateField:(SkinField)field withValue:(NSObject*)value{
    if (![self canEditField:field]){
        return;
    }
    switch (field) {
        case fLOCATION:
            if ([value isKindOfClass:FSVenue.class]){
                fieldLocation = [[Location alloc] initWIthVenue:(FSVenue*)value];
                [self fieldLocationDidUpdate];
            }
            break;
        case fAUTO1:
            if ([value isKindOfClass:Auto.class]){
                fieldAuto1 = (Auto*)value;
                [self fieldAuto1DidUpdate];
            }
            break;
        case fAUTO2:
            if ([value isKindOfClass:Auto.class]){
                fieldAuto2 = (Auto*)value;
                [self fieldAuto2DidUpdate];
            }
            break;
        case fTEXT1:
            if ([value isKindOfClass:NSString.class]){
                fieldText1 = (NSString*)value;
                [self fieldText1DidUpdate];
            }
            break;
        case fTEXT2:
            if ([value isKindOfClass:NSString.class]){
                fieldText2 = (NSString*)value;
                [self fieldText2DidUpdate];
            }
            break;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

// initial values for the base class
-(void)baseInit{
    canEditFieldLocation = NO;
    canEditFieldAuto1 = NO;
    canEditFieldAuto2 = NO;
    canEditFieldText1 = NO;
    canEditFieldText2 = NO;
    
    _commandFlags.canCmdInvertColors = NO;
    _commandFlags.canCmdEditText = NO;
    
    self.userInteractionEnabled = YES;
    gradient = nil;
    gradientInitialized = NO;
    isContentOnTop = YES;
    movingViewTopBottomMargin = 0.0;
}

-(void)initialise{
    // overriden by descendants
}

-(void)setMovingViewConstraint:(NSLayoutConstraint*)topMargin andViewHeight:(unsigned short)height{
    movingViewTopMarginConstraint = topMargin;
    movingViewHeight = height;
    heightScaleFactor = height / self.bounds.size.height;
}

-(UIImage*)getSkinImage{
    return [self getSkinImageWithBlur:0.0];
}

-(UIImage*)getSkinImageWithBlur2:(CGFloat)blurStrength {
    CGFloat scaleFactorHeight = DESIRED_SIDE_LENGTH/self.bounds.size.height;
    
    self.layer.contentsScale = scaleFactorHeight;
    CGRect currentFrame = self.frame;
    bool movingViewIsOnTop = movingViewTopMarginConstraint.constant == movingViewTopBottomMargin;
    if (movingViewIsOnTop){
        movingViewTopMarginConstraint.constant = movingViewTopBottomMargin*scaleFactorHeight;
    } else {
        movingViewTopMarginConstraint.constant = DESIRED_SIDE_LENGTH - movingViewHeight*scaleFactorHeight - movingViewTopBottomMargin*scaleFactorHeight;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, DESIRED_SIDE_LENGTH, DESIRED_SIDE_LENGTH);
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self layoutSubviews];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(DESIRED_SIDE_LENGTH, DESIRED_SIDE_LENGTH), NO, 1);//scaleFactorHeight);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.frame = currentFrame;
    if (movingViewIsOnTop){
        movingViewTopMarginConstraint.constant = movingViewTopBottomMargin;
    } else {
        movingViewTopMarginConstraint.constant = currentFrame.size.height - movingViewHeight - movingViewTopBottomMargin;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self layoutSubviews];
    
    if (blurStrength > 0){
        result = [Utils blurImage:result strength:blurStrength];
    }
    
    return result;
}

-(UIImage*)getSkinImageWithBlur:(CGFloat)blurStrength {
    //CGFloat scaleFactorHeight = self.bounds.size.height/DESIRED_SIDE_LENGTH;
    UIGraphicsBeginImageContext(CGSizeMake(DESIRED_SIDE_LENGTH, DESIRED_SIDE_LENGTH));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (UIView *view in self.subviews) {
        [self renderControl:view inContext:&ctx withParentPoint:CGPointMake(0, 0)]; // initial point is 0.0
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)renderControl:(UIView*)control inContext:(CGContextRef*)context withParentPoint:(CGPoint)point{
    CGPoint selfAbsoluteOriginPoint = CGPointMake(control.frame.origin.x + point.x, control.frame.origin.y + point.y);
    
    if ([control conformsToProtocol:@protocol(DrawElemBaseProtocol)]){
        CGFloat scaleFactorHeight = DESIRED_SIDE_LENGTH/self.bounds.size.height;
        
        UIView<DrawElemBaseProtocol> *elemBase = (UIView<DrawElemBaseProtocol> *)control;
        
        // prepare the rect
        CGRect rectToDrawIn = [elemBase elemRectInParent];
        rectToDrawIn.origin.x = selfAbsoluteOriginPoint.x;
        rectToDrawIn.origin.y = selfAbsoluteOriginPoint.y;
        
        rectToDrawIn.origin.x *= scaleFactorHeight;
        rectToDrawIn.origin.y *= scaleFactorHeight;
        rectToDrawIn.size.height *= scaleFactorHeight;
        rectToDrawIn.size.width *= scaleFactorHeight;
        
        switch ([elemBase elemType]) {
#pragma mark Draw GRADIENT
            case ELEM_GRADIENT:{
                break; // CURRENTLY DISABLED AT ALL
                UIView<DrawElemGradientProtocol> *elemGrad = (UIView<DrawElemGradientProtocol>*)control;
                
                [elemGrad drawGradientInContext:context inRect:rectToDrawIn];
                break;
            }
#pragma mark Draw IMAGE
            case ELEM_IMAGE:{
                UIView<DrawElemImageProtocol> *elemImg = (UIView<DrawElemImageProtocol> *)control;
                
                // adjust the rect based on the content mode
                UIImage *toDraw = [elemImg elemImage256];
                
                switch (elemImg.contentMode) {
                    case UIViewContentModeScaleAspectFit:{
                        toDraw = [Utils image:toDraw byScalingProportionallyToSize:rectToDrawIn.size];
                        break;
                    }
                    default:
                        //assert(false);
                        break;
                }
                
                [toDraw drawInRect:rectToDrawIn];
                break;
            }
#pragma mark Draw TEXT
            case ELEM_TEXT:{
                UIView<DrawElemTextProtocol> *elemText = (UIView<DrawElemTextProtocol> *)control;
                
                // fill label background if any
                if (![[elemText backgroundColor] isEqual:[UIColor clearColor]]){
                    CGFloat fillRed = 0.0, fillGreen = 0.0, fillBlue = 0.0, fillAlpha = 0.0;
                    [[elemText backgroundColor] getRed:&fillRed green:&fillGreen blue:&fillBlue alpha:&fillAlpha];
                    CGContextSetRGBFillColor(*context, fillRed, fillGreen, fillBlue, fillAlpha);
                    CGContextFillRect(*context, rectToDrawIn);
                }
                
                NSDictionary *attrs = @{NSFontAttributeName: [elemText elemFont], NSForegroundColorAttributeName: [elemBase elemColor]};
                NSString *text = [elemText elemString];
                
                CGRect textRect = [elemText elemRectInParent];
                const CGSize textSize = [text sizeWithAttributes: attrs];
                CGFloat textHRatio = textSize.height / textRect.size.height;
                CGFloat textWRatio = textSize.width / textRect.size.width;
                
                NSDictionary *savedStringAttrs = attrs;
                for (CGFloat fontSize = 1.0; ; fontSize += 2.0){
                    UIFont *currFont = [UIFont fontWithName:[elemText elemFont].fontName size:fontSize];
                    NSDictionary *currAttrs = @{NSFontAttributeName: currFont, NSForegroundColorAttributeName: [elemBase elemColor]};
                    const CGSize currTextSize = [text sizeWithAttributes: currAttrs];
                    
                    CGFloat currTextHRatio = currTextSize.height / rectToDrawIn.size.height;
                    CGFloat currTextWRatio = currTextSize.width / rectToDrawIn.size.width;
                    
                    if (currTextHRatio > textHRatio || currTextWRatio > textWRatio || // ratio
                        currTextSize.width > rectToDrawIn.size.width || currTextSize.height > rectToDrawIn.size.height){ // size limit
                        
                        // calc vertical text alignment
                        rectToDrawIn.origin.y += MAX(0, (rectToDrawIn.size.height - currTextSize.height) * 0.5);
                        rectToDrawIn.size.height = currTextSize.height;
                        
                        // calc horizontal text alignment
                        switch (elemText.elemAlignment) {
                            case NSTextAlignmentCenter:{
                                rectToDrawIn.origin.x += MAX(0, (rectToDrawIn.size.width - currTextSize.width) * 0.5);
                                break;
                            }
                            case NSTextAlignmentRight:{
                                rectToDrawIn.origin.x += MAX(0, rectToDrawIn.size.width - currTextSize.width);
                                break;
                            }
                            default: // = NSTextAlignmentLeft
                                break;
                        }
                        
                        break;
                    }
                    
                    savedStringAttrs = currAttrs;
                }
                
                // draw the text
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:savedStringAttrs];
                [attrString drawAtPoint:rectToDrawIn.origin];
                
                break;
            }
#pragma mark Draw RECT
            case ELEM_RECT:{
                UIView<DrawElemRectProtocol> *elemRect = (UIView<DrawElemRectProtocol> *)control;
                
                CGFloat fillRed = 0.0, fillGreen = 0.0, fillBlue = 0.0, fillAlpha = 0.0;
                [[elemRect elemColor] getRed:&fillRed green:&fillGreen blue:&fillBlue alpha:&fillAlpha];
                
                CGFloat strokeRed = 0.0, strokeGreen = 0.0, strokeBlue = 0.0, strokeAlpha = 0.0;
                [[elemRect borderColor] getRed:&strokeRed green:&strokeGreen blue:&strokeBlue alpha:&strokeAlpha];
    
                CGContextSetRGBFillColor(*context, fillRed, fillGreen, fillBlue, fillAlpha);
                CGContextSetRGBStrokeColor(*context, strokeRed, strokeGreen, strokeBlue, strokeAlpha);
                CGContextSetLineWidth(*context, [elemRect borderWidth]);
                
                CGContextFillRect(*context, rectToDrawIn);
                CGContextStrokeRect(*context, rectToDrawIn);
                break;
            }
            default:
                break;
        }
    }
    
    for (UIView *subView in control.subviews) {
        [self renderControl:subView inContext:context withParentPoint:selfAbsoluteOriginPoint];
    }
}

-(BOOL)isSkinContentAtTheTop{
    return isContentOnTop;
}

-(void)moveContentUp{
    if (!movingViewTopMarginConstraint || movingViewHeight == 0){
        return;
    }
    
    if (movingViewTopMarginConstraint.constant == movingViewTopBottomMargin){
        return; // already at the top
    }

    [UIView animateWithDuration:MOVINGVIEW_TIME
            animations:^(void){
                movingViewTopMarginConstraint.constant = movingViewTopBottomMargin;
                [self layoutIfNeeded];
            }
            completion:^(BOOL finished){
            }
     ];
    isContentOnTop = YES;
}

-(void)moveContentDown{
    if (!movingViewTopMarginConstraint || movingViewHeight == 0){
        return;
    }
    
    if (movingViewTopMarginConstraint.constant != movingViewTopBottomMargin){
        return; // already at the bottom (at least not on the top)
    }
    
    [UIView animateWithDuration:MOVINGVIEW_TIME
            animations:^(void){
                movingViewTopMarginConstraint.constant = self.bounds.size.height - movingViewHeight - movingViewTopBottomMargin;
                [self layoutIfNeeded];
            }
            completion:^(BOOL finished){
            }
     ];
    isContentOnTop = NO;
}

-(CommandFlags)getSkinCommands{
    return _commandFlags;
}

#pragma mark Skin commands descendant overrides

-(void)onCmdInvertColors{
    // overriden in descendants
}
-(void)onCmdEditText:(NSString *)newText{
    // overriden in descendants
}
-(NSString*)getSkinContentText{
    return @"";
}
-(BOOL)getAllowsEmptyContentText{
    return YES;
}

#pragma mark Descendant overrides

-(void)fieldLocationDidUpdate{
    // overriden in descendants
}

-(void)fieldAuto1DidUpdate{
    // overriden in descendants
}

-(void)fieldAuto2DidUpdate{
    // overriden in descendants
}

-(void)fieldText1DidUpdate{
    // overriden in descendants
}

-(void)fieldText2DidUpdate{
    // overriden in descendants
}

@end
