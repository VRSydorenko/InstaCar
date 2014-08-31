//
//  GradientView.m
//  AssetGrid
//
//  Created by Joe Andolina on 10/18/12.
//
//
#import <QuartzCore/QuartzCore.h>
#import "UIAlphaGradientView.h"

@implementation UIAlphaGradientView
{
    CGPoint startPoint;
    CGPoint endPoint;
    float _alpha;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _alpha = 1.0;
        self.userInteractionEnabled = false;
        self.backgroundColor = [UIColor clearColor];
        self.color = [UIColor blackColor];
    }
    
    return self;
}


-(void) setAlpha:(CGFloat)alpha
{
    _alpha = alpha;
    [self setNeedsDisplay];    
}

-(void) setColor:(UIColor *)value
{
    _color = value;
    [self setNeedsDisplay];
}

-(void) setDirection:(GradientDirection)value
{
    _direction = value;
    [self setNeedsDisplay];
}

-(void) calculateStartAndEndPoints
{
    switch (self.direction)
    {
        case GRADIENT_UP:
            startPoint  = CGPointMake( 0, self.frame.size.height);
            endPoint    = CGPointMake( 0, 0);
            break;
            
        case GRADIENT_DOWN:
            startPoint  = CGPointMake( 0, 0);
            endPoint    = CGPointMake( 0, self.frame.size.height);
            break;
            
        case GRADIENT_LEFT:
            startPoint  = CGPointMake( self.frame.size.width, 0);
            endPoint    = CGPointMake( 0, 0);
            break;
            
        case GRADIENT_RIGHT:
            startPoint  = CGPointMake( 0, 0);
            endPoint    = CGPointMake( self.frame.size.width, 0);
            break;
    }
   
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawGradientInContext:&context inRect:rect];
}

-(void) drawGradientInContext:(CGContextRef*)context inRect:(CGRect)rect
{
    CGFloat maskColors[] =
    {
        0.0f, 0.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 1.0f, 1.0f,
    };
    
    // Set up the start and end points for the gradient
    [self calculateStartAndEndPoints];
    
    // Create an image of a solid slab in the desired color
    CGRect frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    CGContextRef imgContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(imgContext, [self.color colorWithAlphaComponent:_alpha].CGColor);
    CGContextFillRect( UIGraphicsGetCurrentContext(), frame);
    CGImageRef colorRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
    
    // Create an image of a gradient from black to white
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(rgb, maskColors, NULL, sizeof(maskColors) / (sizeof(maskColors[0]) * 4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(imgContext, gradientRef, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGImageRef maskRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
    
    // Blend the solid image and the gradient to produce the final gradient.
    CGImageRef tmpMask = CGImageMaskCreate(
                                           CGImageGetWidth(maskRef),
                                           CGImageGetHeight(maskRef),
                                           CGImageGetBitsPerComponent(maskRef),
                                           CGImageGetBitsPerPixel(maskRef),
                                           CGImageGetBytesPerRow(maskRef),
                                           CGImageGetDataProvider(maskRef),
                                           NULL,
                                           false);
    
    // Draw the resulting mask.
    CGContextDrawImage(*context, rect, CGImageCreateWithMask(colorRef, tmpMask));
}

#pragma mark DrawElement protocol 

-(UIColor*)elemColor{
    return self.color;
}

-(CGRect)elemRectInParent{
    return self.frame;
}

-(ElementType)elemType{
    return ELEM_GRADIENT;
}

-(int)elemGradDirection
{
    return self.direction;
}

@end
