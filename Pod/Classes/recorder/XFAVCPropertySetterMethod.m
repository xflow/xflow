//
//  XFAPropertySetterMethod.m
//  Pods
//
//  Created by Mohammed Tillawy on 2/11/15.
//
//

#import "XFAVCPropertySetterMethod.h"
#import "XFAVCProperty.h"
#import "XFPObjcMethodSignature.h"


@interface XFAVCPropertySetterMethod ()

@property (nonatomic, assign) BOOL isPropertySetter;

@end




@implementation XFAVCPropertySetterMethod

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isPropertySetter = YES;
        self.returnObjcType = @"void";
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

-(void)setProperty:(XFAVCProperty *)property{
    _property = property;
    NSString * propertyNameCapitalized = [self.property.propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.property.propertyName substringToIndex:1] capitalizedString]];

    NSString * signature = [[@"set" stringByAppendingString:propertyNameCapitalized] stringByAppendingString:@":"];
    self.encoding = @"v12@0:4@8";
    self.signature = signature;
}

+ (NSValueTransformer *)propertyJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XFAVCProperty class]];
}


@end
