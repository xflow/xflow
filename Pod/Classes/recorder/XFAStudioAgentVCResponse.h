//
//  XFAStudioAgentVCResponse.h
//  POC2
//
//  Created by Mohammed Tillawy on 3/13/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <Mantle.h>

@interface XFAStudioAgentVCResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString * childrenKey;
@property (nonatomic, strong) NSArray * methods;
@property (nonatomic, strong) NSArray * properties;

@end
