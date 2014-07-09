//
//  XFAVCObjectProperty.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/20/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAVCObjectProperty.h"

@implementation XFAVCObjectProperty

-(NSObject *)objectFromVC:(UIViewController *)vc
{
    NSObject * obj = [vc valueForKey:self.propertyName];
//    NSString * assertMsg = [NSString stringWithFormat:@"VC Object Property: %@ obj not set", self.propertyName];
//    NSAssert(obj, assertMsg);
    return obj;
}


-(NSDictionary *)loadValuesFromVC:(UIViewController*)vc
{
    NSObject * obj = [self objectFromVC:vc];
    return @{@"obj_hash": @(obj.hash)};
}

@end
