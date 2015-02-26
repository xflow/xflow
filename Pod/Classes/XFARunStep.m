//
//  XFARunStep.m
//  Pods
//
//  Created by Mohammed Tillawy on 2/26/15.
//
//

#import "XFARunStep.h"
#import "XFAVcMethodInvocation.h"


@implementation XFARunStep


+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             };
}


+ (NSValueTransformer*)invocationsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XFAVcMethodInvocation class]];
}


@end
