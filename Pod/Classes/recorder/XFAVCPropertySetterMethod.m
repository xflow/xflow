//
//  XFAPropertySetterMethod.m
//  Pods
//
//  Created by Mohammed Tillawy on 2/11/15.
//
//

#import "XFAVCPropertySetterMethod.h"
#import "XFAVCProperty.h"


@interface XFAVCPropertySetterMethod ()

@property (nonatomic, assign) BOOL isPropertySetter;

@end




@implementation XFAVCPropertySetterMethod

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isPropertySetter = YES;
    }
    return self;
}

/*
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary * dic = @{
//                           @"property" : [NSNull null]
                           };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:dic];
}
*/

+ (NSValueTransformer *)propertyJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XFAVCProperty class]];
}


@end
