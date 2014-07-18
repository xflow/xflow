//
//  MTMethodApplication.h
//  POC2
//
//  Created by Mohammed Tillawy on 3/11/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@class MTMethod;

@interface MTMethodInvocation : MTLModel <MTLJSONSerializing>

@property (nonatomic,strong) MTMethod * method;
@property (nonatomic,strong) UIViewController * invocationTarget;

@property (nonatomic,readonly) BOOL isFirstInVirtualStack;
@property (nonatomic,assign) NSInteger invocationIndexWithStack;

@end
