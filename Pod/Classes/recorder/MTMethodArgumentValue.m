//
//  TXMethodArgumentValue.m
//  POC2
//
//  Created by Mohammed Tillawy on 4/16/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "MTMethodArgumentValue.h"

@implementation MTMethodArgumentValue


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"value"           : @"value",
             @"objcType"        : @"objcType",
             @"argumentType"    : @"argumentType",
             @"isNil"           : @"isNil",
             @"objectsPath"     : @"objectsPath",
             @"classesPath"     : @"classesPath",
             };
}


+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    if (JSONDictionary[@"argumentType"] != nil &&
        [JSONDictionary[@"argumentType"] isEqualToString:@"UIViewController"] ) {
        return NSClassFromString(@"MTMethodArgumentMapVcObjectValue");
    }
    
    if (JSONDictionary[@"argumentType"] != nil &&
        [JSONDictionary[@"argumentType"] isEqualToString:@"Scalar"] ) {
        return NSClassFromString(@"MTMethodArgumentScalarValue");
    }
    
//    NSAssert(NO, @"No matching class for the JSON dictionary '%@'.", JSONDictionary);
    return self;
}

@end


