//
//  GradientView.h
//  AssetGrid
//
//  Created by Joe Andolina on 10/18/12.
//
//

#import "DrawingElementProtocolBase.h"

@interface UIAlphaGradientView : UIView <DrawElemGradientProtocol>

typedef enum
{
    GRADIENT_UP = 0,
    GRADIENT_DOWN,
    GRADIENT_LEFT,
    GRADIENT_RIGHT
} GradientDirection;

@property (nonatomic) UIColor* color;
@property (nonatomic) GradientDirection direction;

@end
