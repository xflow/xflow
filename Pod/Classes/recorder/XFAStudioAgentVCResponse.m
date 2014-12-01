//
//  XFAStudioAgentVCResponse.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/13/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAStudioAgentVCResponse.h"
#import "MTMethod.h"
#import "XFAVCProperty.h"
//#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>


@interface XFAStudioAgentVCResponse (){
    
}

//@property (nonatomic, strong) NSString * childrenKey;
@property (nonatomic, strong) NSArray * methods;
@property (nonatomic, strong) NSArray * properties;

@end


@implementation XFAStudioAgentVCResponse


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
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MTMethod class]];
}

+ (NSValueTransformer *)propertiesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XFAVCProperty class]];
}


@end
