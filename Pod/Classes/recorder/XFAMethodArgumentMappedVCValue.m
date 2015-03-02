//
//  XFAMethodArgumentMappedVCValue.m
//  Pods
//
//  Created by Mohammed Tillawy on 3/2/15.
//
//

#import "XFAMethodArgumentMappedVCValue.h"
#import "XFAViewControllerState.h"
#import "XFEngine.h"

@implementation XFAMethodArgumentMappedVCValue


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}


-(NSValue*)loadValueOfObject:(NSObject*)obj
{
    UIWindow * window =  [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIViewController * vc = [XFAViewControllerState viewControllerForPath:self.vcPath withWindow:window];
    return (NSValue*)vc;
}

@end
