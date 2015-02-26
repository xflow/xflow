//
//  MTVcMethodInvocation.h
//  POC2
//
//  Created by Mohammed Tillawy on 4/1/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAMethodInvocation.h"
@class XFAViewControllerState;

typedef NS_ENUM(NSInteger, MTVcMethodInvocationStatus) {
    MTVcMethodInvocationStatusUnknown       = 0,
    MTVcMethodInvocationStatusPre           = 1,
    MTVcMethodInvocationStatusPost          = 2
};

@interface XFAVcMethodInvocation : XFAMethodInvocation

@property (nonatomic,strong) XFAViewControllerState * vcStateBefore;
@property (nonatomic,strong) XFAViewControllerState * vcStateAfter;

@property (nonatomic, assign) MTVcMethodInvocationStatus status;


-(void)saveVcStateBefore;
-(void)saveVcStateAfter;

@end
