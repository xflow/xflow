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
    
    if ([JSONDictionary[@"objc_class_name"] isEqual:@"UILabel"]) {
        return NSClassFromString(@"XFAVCLabelProperty");
    }
    
    if ([JSONDictionary[@"objc_type"] isEqual:@"UIView"]) {
        return NSClassFromString(@"XFAVCViewProperty");
    }

    if ([JSONDictionary[@"objc_type"] isEqual:@"IBoutlet"]) {
        return NSClassFromString(@"XFAVCIBOutletViewProperty");
    }
    
    if ([JSONDictionary[@"objc_type"] isEqual:@"Scalar"]) {
        return NSClassFromString(@"XFAVCScalarProperty");
    }
    
    
    NSAssert(NO, @"No matching class for the JSON dictionary '%@'.", JSONDictionary);
    return self;
}

@end
