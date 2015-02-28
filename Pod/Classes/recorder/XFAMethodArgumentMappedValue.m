//
//  XFAMethodArgumentMappedValue.m
//  Pods
//
//  Created by Mohammed Tillawy on 2/28/15.
//
//

#import "XFAMethodArgumentMappedValue.h"
#import "UIViewController+XFAProperties.h"
#import "XFAVCProperty.h"
#import <RXCollections/RXCollection.h>
#import "XFAMethodArgumentMappedVCUIViewPropertyValue.h"

@implementation XFAMethodArgumentMappedValue


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

+(XFAMethodArgumentMappedValue *)virtualArgumentValue:(NSValue*)value ofViewController:(UIViewController*)vc
{
    XFAMethodArgumentMappedValue * mval = nil;
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
        XFAVCProperty * vcProperty = [output firstObject];
        XFAMethodArgumentMappedVCUIViewPropertyValue * mpval = [XFAMethodArgumentMappedVCUIViewPropertyValue new];
        mpval.vcProperty = vcProperty;
        mpval.mappedValueType = XFAMethodArgumentMappedValueTypeVCUIViewProperty;
        mval = (XFAMethodArgumentMappedValue*)mpval;
    }
    return mval;
}


+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    return nil;
}


@end
