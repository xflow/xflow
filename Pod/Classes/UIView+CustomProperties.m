//
//  UIView+CustomProperties.m
//  Contexter
//
//  Created by Mohammed Tillawy on 11/11/13.
//  Copyright (c) 2013 Mohammed Tillawy. All rights reserved.
//

#import "UIView+CustomProperties.h"

@implementation UIView (CustomProperties)

-(NSNumber*)tx_frame_origin_x{
    return [NSNumber numberWithFloat:self.frame.origin.x];
}

@end
