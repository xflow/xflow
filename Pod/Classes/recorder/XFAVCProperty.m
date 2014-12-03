//
//  XFAVCProperty.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/17/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAVCProperty.h"

@implementation XFAVCProperty


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"propertyName"            : @"name",
             @"propertyObjcType"        : @"objc_type",
             @"propertyObjcClassName"   : @"objc_class_name",
             @"propertyIsNil"           : @"is_nil"
             };
}

-(NSDictionary *)loadValuesFromVC:(UIViewController*)vc
{
    NSAssert(FALSE, @"calling loadValueFromVC from XFAVCProperty");
    return @{ @"very bad" : @"useless" };
}



+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    
    if ([JSONDictionary[@"objcType"] isEqualToString:@"UILabel *"]) {
        return NSClassFromString(@"XFAVCLabelProperty");
    }
    
    if ([JSONDictionary[@"objcType"] isEqualToString:@"UIView *"]) {
        return NSClassFromString(@"XFAVCViewProperty");
    }

    if ([JSONDictionary[@"objcType"] isEqualToString:@"IBOutlet"]) {
        return NSClassFromString(@"XFAVCIBOutletViewProperty");
    }
    
    if ([JSONDictionary[@"objcType"] isEqualToString:@"Scalar"]) {
        return NSClassFromString(@"XFAVCScalarProperty");
    }
    
    
    NSAssert(NO, @"%s No matching class for: '%@'.",__PRETTY_FUNCTION__, JSONDictionary[@"objc_type"]);
    return self;
}

@end
