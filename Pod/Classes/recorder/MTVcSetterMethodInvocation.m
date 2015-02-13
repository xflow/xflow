//
//  MTVcSetterMethodInvocation.m
//  Pods
//
//  Created by Mohammed Tillawy on 2/11/15.
//
//

#import "MTVcSetterMethodInvocation.h"
#import "XFAVCProperty.h"

@implementation MTVcSetterMethodInvocation


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
//             @"property" : [NSNull null],
//             @"method" : @"method",
//             @"invocationIndexWithStack" : @"invocationIndexWithStack",
             };
}

+ (NSValueTransformer *)propertyJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XFAVCProperty class]];
}

@end
