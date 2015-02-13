//
//  XFAVCProperty.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/17/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAVCProperty.h"
#import "XFAVCIBOutletViewProperty.h"
#import "XFAVCScalarProperty.h"
#import "XFAVCLabelProperty.h"
#import "XFAVCScalarProperty.h"
#import "XFAVCVCProperty.h"

@implementation XFAVCProperty


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"propertyName"            : @"propertyName",
//             @""        : [NSNull null],
//             @""      : [NSNull null],
//             @""           : [NSNull null]
             };
}



+ (NSDictionary *)JSONKeyPathsByPropertyKeyOLD {
    NSDictionary * dic = @{ };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:dic];
}


-(NSDictionary *)loadValuesFromVC:(UIViewController*)vc
{
    NSAssert(FALSE, @"calling loadValueFromVC from ABSTRACT XFAVCProperty");
    return @{ @"very bad" : @"useless" };
}



+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    
    if (JSONDictionary[@"isIBOutlet"] && [JSONDictionary[@"isIBOutlet"] isEqualToNumber:@1]) {
//        return NSClassFromString(@"XFAVCIBOutletViewProperty");
        return [XFAVCIBOutletViewProperty class];
    }
    
    if ([JSONDictionary[@"objcType"] isEqualToString:@"UILabel *"]) {
//        return NSClassFromString(@"XFAVCLabelProperty");
        return [XFAVCLabelProperty class];
    }
    
    if ([JSONDictionary[@"objcType"] isEqualToString:@"UIView *"]) {
//        return NSClassFromString(@"XFAVCViewProperty");
        return [XFAVCViewProperty class];
    }

    if ([JSONDictionary[@"objcType"] isEqualToString:@"Scalar"]) {
//        return NSClassFromString(@"XFAVCScalarProperty");
        return [XFAVCScalarProperty class];
    }

    if ([JSONDictionary[@"objcType"] isEqualToString:@"UIViewController *"]) {
//        return NSClassFromString(@"XFAVCScalarProperty");
        return [XFAVCVCProperty class];
    }
    
    
    NSAssert(NO, @"%s No matching class for: '%@'.",__PRETTY_FUNCTION__, JSONDictionary[@"objc_type"]);
    return [self class];
}

@end
