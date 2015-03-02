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
#import "XFAMethodArgumentMappedVCValue.h"
#import "XFAViewControllerState.h"

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
    
    if ([value isKindOfClass:[UIViewController class]])
    {
        XFAMethodArgumentMappedVCValue * mvcval = [XFAMethodArgumentMappedVCValue  new];
        mvcval.vcPath = [XFAViewControllerState viewControllerPathToWindow:(UIViewController*)value];
        mvcval.mappedValueType = XFAMethodArgumentMappedValueTypeVC;
        mval = (XFAMethodArgumentMappedValue*)mvcval;
    }
    
    return mval;
}

-(NSValue*)loadValueOfObject:(NSObject*)obj
{
    NSAssert(NO, @"calling abstract %s",__PRETTY_FUNCTION__);
    return nil;
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    NSNumber * mappedValueTypeNumber = JSONDictionary[@"mappedValueType"];
    XFAMethodArgumentMappedValueType mappedValueType = mappedValueTypeNumber.integerValue;
    Class outputClass = nil;
    switch (mappedValueType) {
        case XFAMethodArgumentMappedValueTypeVCUIViewProperty:{
            outputClass = [XFAMethodArgumentMappedVCUIViewPropertyValue class];
            break;
        }
        case XFAMethodArgumentMappedValueTypeVC:{
            outputClass = [XFAMethodArgumentMappedVCValue class];
            break;
        }
        default:{
            NSAssert(NO, @"unknownn classForParsingJSONDictionary %ld",mappedValueType);
            break;
        }
    }
    return outputClass;
}


@end
