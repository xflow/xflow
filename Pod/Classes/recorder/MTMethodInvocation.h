//
//  MTMethodApplication.h
//  POC2
//
//  Created by Mohammed Tillawy on 3/11/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

typedef NS_ENUM(NSInteger, BoolExtended) {
    BoolExtendedUnknown = -1,
    BoolExtendedFalse   = 0,
    BoolExtendedTrue    = 1
};

@class MTMethod;

@interface MTMethodInvocation : MTLModel <MTLJSONSerializing>

@property (nonatomic,strong) MTMethod * method;
@property (nonatomic,strong) UIViewController * invocationTarget;

@property (nonatomic,assign) BoolExtended isFirstInVirtualStack;
@property (nonatomic,assign) NSInteger sessionGroupIndex;
@property (nonatomic,assign) NSInteger sessionGroupInvocationIndex;

@end
