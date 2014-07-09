//
//  XFAStudioAgentVCResponse.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/13/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAStudioAgentVCResponse.h"
#import "MTMethod.h"
#import "XFAVCProperty.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>

@implementation XFAStudioAgentVCResponse



+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"childrenKey": @"children_key",
             @"methods": @"methods",
             @"properties" : @"properties"
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"methods"]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:MTMethod.class];
    }
    
    if ([key isEqualToString:@"properties"]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:XFAVCProperty.class];
    }
    
    
    return nil;
}


@end
