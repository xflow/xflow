//
//  XFAVCViewProperty.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/19/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAVCViewProperty.h"

@implementation XFAVCViewProperty


+(NSDictionary*)frameForView:(UIView*)view
{
    
    NSDictionary * frameDic = @{
                             @"origin" : @{
                                     @"x" : @(view.frame.origin.x),
                                     @"y" : @(view.frame.origin.y)
                                     },
                             @"size" : @{
                                     @"width" : @(view.frame.size.width),
                                     @"height" : @(view.frame.size.height),
                                     },
                             };
    return frameDic;
}


-(NSDictionary *)loadValuesFromVC:(UIViewController*)vc
{
    UIView * view = (UIView *)[self objectFromVC:vc];
 
    BOOL isNil = ! view;

//    NSAssert(view, @"property not set !");
    
    NSDictionary * dicFromSuper = [super loadValuesFromVC:vc];
    
    NSMutableDictionary * dic = @{
             @"isNil"  : @(isNil),
             @"propertyName"    : self.propertyName,
             @"isHidden"  : @(view.hidden),
             @"frame"   : [XFAVCViewProperty frameForView:view]
             }.mutableCopy;
    
    
    [dic addEntriesFromDictionary:dicFromSuper];
    return dic;
}


@end
