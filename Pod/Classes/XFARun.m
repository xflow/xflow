//
//  XFARun.m
//  Pods
//
//  Created by Mohammed Tillawy on 2/23/15.
//
//

#import "XFARun.h"
#import "XFARunStep.h"


@implementation XFARun

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{};
}


+ (NSValueTransformer*)stepsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XFARunStep class]];
}


@end
