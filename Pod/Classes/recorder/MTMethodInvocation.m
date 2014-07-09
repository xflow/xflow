//
//  MTMethodApplication.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/11/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "MTMethodInvocation.h"
#import "MTMethod.h"


@implementation MTMethodInvocation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isFirstInVirtualStack = BoolExtendedUnknown;
        self.sessionGroupIndex = -1;
        self.sessionGroupInvocationIndex = -1;
    }
    return self;
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"method"          : @"method",
             @"isFirstInVirtualStack" : @"isFirstInVirtualStack",
             @"sessionGroupIndex" : @"sessionGroupIndex",
             @"sessionGroupInvocationIndex" : @"sessionGroupInvocationIndex",
           };
}

/*
+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    if (JSONDictionary[@"method"] != nil) {
        return MTMethod.class;
    }
    NSAssert(NO, @"No matching class for the JSON dictionary '%@'.", JSONDictionary);

    return self;
}*/


+ (NSValueTransformer *)invocationTargetJSONTransformer {
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateString) {
        return @"value";
    } reverseBlock:^(UIViewController * vc) {
        return @{
                 @"objHash": @(vc.hash)
                 };
    }];
    
    
}


+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"method"]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass: MTMethod.class];
    }    
    return nil;

}


@end
