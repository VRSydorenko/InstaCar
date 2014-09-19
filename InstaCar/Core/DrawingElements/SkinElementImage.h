//
//  SkinElementImage.h
//  InstaCar
//
//  Created by VRS on 20/06/14.
//  Copyright (c) 2014 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingElementProtocolBase.h"

@interface SkinElementImage : UIImageView <DrawElemImageProtocol>{
@private
    NSString *logoName;
}

// this method is ONLY used to change images because of the color inversion
// (backgrounds, etc) so ONLY for images set initially in the design mode (not for car logos)
// the difference between this and the setImage: methos only is that this one has
// no assert checking image name availability
-(void)setInvertedImage:(UIImage *)image;

@end
