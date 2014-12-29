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
    
    
    NSAssert(NO, @"%s No matching class for: '%@'.",__PRETTY_FUNCTION__, JSONDictionary[@"objc_type"]);
    return self;
}

@end
