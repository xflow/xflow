//
//  XFAMethodArgumentMappedPropertyValue.m
//  Pods
//
//  Created by Mohammed Tillawy on 2/28/15.
//
//

#import "XFAMethodArgumentMappedVCUIViewPropertyValue.h"
#import "XFAVCProperty.h"

@implementation XFAMethodArgumentMappedVCUIViewPropertyValue

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}


+ (NSValueTransformer *)vcPropertyJSONTransformer {
    Class k = [XFPObjcProperty class];
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:k];
}


-(NSValue*)loadValueOfObject:(NSObject*)obj
{
    NSValue * val = [obj valueForKey:self.vcProperty.propertyName];
    return val;
}

@end
