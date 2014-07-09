//
//  TXAction.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/1/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "TXAction.h"
#import "MTMethod.h"


@implementation TXAction


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"objectsPath"         : @"objectsPath",
             @"classesPath"         : @"classesPath",
             @"objHash"             : @"objHash",
             @"invocationMethod"    : @"invocationMethod",
             };
}



+ (NSValueTransformer *)invocationMethodJSONTransformer {
    
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MTMethod.class];
    
}


@end
