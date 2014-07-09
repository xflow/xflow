//
//  XFAVCLabelProperty.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/31/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAVCLabelProperty.h"

@implementation XFAVCLabelProperty




-(NSDictionary *)loadValuesFromVC:(UIViewController*)vc
{
    UIView * view = (UIView *)[self objectFromVC:vc];
    
//    NSAssert(view, @"property not set !");
    
    NSMutableDictionary * mdic = [[super loadValuesFromVC:vc] mutableCopy];
    [mdic setValue:[view valueForKey:@"text"] forKey:@"text"];
    return mdic;
}


@end
