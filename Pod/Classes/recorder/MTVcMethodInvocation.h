//
//  MTVcMethodInvocation.h
//  POC2
//
//  Created by Mohammed Tillawy on 4/1/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "MTMethodInvocation.h"


typedef NS_ENUM(NSInteger, MTVcMethodInvocationStatus) {
    MTVcMethodInvocationStatusUnknown       = 0,
    MTVcMethodInvocationStatusPre           = 1,
    MTVcMethodInvocationStatusPost          = 2
};

@interface MTVcMethodInvocation : MTMethodInvocation

@property (nonatomic,readonly) NSDictionary * vcStateBefore;
@property (nonatomic,readonly) NSDictionary * vcStateAfter;
@property (nonatomic, assign) MTVcMethodInvocationStatus status;

-(void)saveVcStateBefore;
-(void)saveVcStateAfter;

@end
