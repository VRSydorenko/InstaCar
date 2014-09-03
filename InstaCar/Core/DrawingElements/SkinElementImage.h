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

@end
