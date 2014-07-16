//
//  XFAMethodTests.m
//  xflowapp
//
//  Created by Mohammed Tillawy on 7/16/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MTMethod.h"
#import "TXTestViewController.h"
#import "MTMethodInvocation.h"
#import "MTMethodArgument.h"
#import <OCMock/OCMock.h>
#import "XFAConstants.h"
#import "UIViewController+XFAProperties.h"

@interface XFAMethodTests : XCTestCase

@end

@implementation XFAMethodTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



-(MTMethod*)methodButton1:(TXTestViewController*)vc{
    MTMethod * method = MTMethod.new;
    method.methodName = @"actionButton1:";
    method.methodReturnType = @"v";
    method.methodTypeEncoding = @"v12@0:4@8";
    UIButton * btn = vc.button1;
    XCTAssert(btn, @"no button");
    NSValue * val = [NSValue valueWithNonretainedObject:btn];
    MTMethodArgument * arg1 = [MTMethodArgument argumentForType:@"@"];
    XCTAssert(val.nonretainedObjectValue, @"no value");
    arg1.argumentValue = val;
    [method.methodArguments addObject:arg1];
    return method;
}


- (void)test_MTMethod_ApplyTo_{
    TXTestViewController * vc = TXTestViewController.new;
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
    vc.string1 = @"TEXT2";
    
    MTMethod * method = [self methodButton1:vc];
    [method applyTo:vc];
    
    XCTAssertEqual(vc.string2, @"TEXT2", @"should be TEXT2");
}


- (void)test_MTMethod_Monitor{
    
    TXTestViewController * vc = TXTestViewController.new;
    
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
    vc.xfaProperties = @{}.mutableCopy;
    
    MTMethod * method = [self methodButton1:vc];
    
    [method monitorForObject:vc];
    
    id observerMock = [OCMockObject observerMock];
    
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                     name:NOTIF_METHOD_INVOCATION
                                                   object:nil];
    
    [[observerMock expect] notificationWithName:NOTIF_METHOD_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertNotNil(obj, @"no notification");
        XCTAssert([obj isKindOfClass:MTMethodInvocation.class], @"should be a MTMethodInvocation");
        MTMethodInvocation * methodInvoc = obj;
        XCTAssertNotNil(methodInvoc.method, @"no notification");
        XCTAssertEqual(methodInvoc.method.methodArguments.count, 1, @"args soule be 1");
    }] userInfo:[OCMArg any]];
    
    vc.string1 = @"ACTION_BUTTON_1";
    
    [vc actionButton1:vc.button1];
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
    
    
    [observerMock verify];
    
    XCTAssertEqualObjects(vc.string2, @"ACTION_BUTTON_1", @"should be PRESSED");
    
}



@end
