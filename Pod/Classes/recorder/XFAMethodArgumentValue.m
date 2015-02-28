//
//  TXMethodArgumentValue.m
//  POC2
//
//  Created by Mohammed Tillawy on 4/16/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAMethodArgumentValue.h"
#import "UIViewController+XFAProperties.h"
#import "XFAVCProperty.h"
#import <RXCollections/RXCollection.h>

@implementation XFAMethodArgumentValue


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


+(NSDictionary *)virtualArgumentValue:(NSValue*)value ofViewController:(UIViewController*)vc
{
    NSDictionary * dic = nil;
    if ([value isKindOfClass:[UIView class]])
    {
        NSArray * output = [vc.xfaProperties rx_filterWithBlock:^BOOL(XFAVCProperty * eachProperty) {
            if (eachProperty.isNSObject) {
                NSObject * obj = [vc valueForKey:eachProperty.propertyName];
                BOOL output = obj.hash == value.hash;
                return output;
            }
            return NO;
           
        }];
        dic = [output firstObject];
    }
    return dic;
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


