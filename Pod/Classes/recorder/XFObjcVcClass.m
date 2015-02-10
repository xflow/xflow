//
//  XFAStudioAgentVCResponse.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/13/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFObjcVcClass.h"
#import "XFAMethod.h"
#import "XFAVCProperty.h"


@interface XFObjcVcClass (){
    
}


@end


@implementation XFObjcVcClass

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.methods = NSMutableArray.new;
        self.properties = NSMutableArray.new;
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"childrenKey": @"children_key",
//             @"methods": @"methods",
//             @"properties" : @"properties"
             };
}

+ (NSValueTransformer *)methodsJSONTransformer{
    Class klass = [XFAMethod class];
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:klass];
}

+ (NSValueTransformer *)propertiesJSONTransformer {
    Class klass = [XFAVCProperty class];
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:klass];
}


@end
