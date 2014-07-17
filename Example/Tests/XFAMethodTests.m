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
#import "MTVcMethodInvocation.h"
#import <OCMock/OCMock.h>
#import "XFAConstants.h"
#import "UIViewController+XFAProperties.h"
#import <Aspects/Aspects.h>

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

-(MTMethod*)methodButton2:(TXTestViewController*)vc{
    MTMethod * method = MTMethod.new;
    method.methodName = @"actionButton2:event:";
    method.methodReturnType = @"v";
    method.methodTypeEncoding = @"v16@0:4@8@12";
    UIButton * btn = vc.button1;
    XCTAssert(btn, @"no button");
    NSValue * val = [NSValue valueWithNonretainedObject:btn];
    MTMethodArgument * arg1 = [MTMethodArgument argumentForType:@"@"];
    XCTAssert(val.nonretainedObjectValue, @"no value");
    arg1.argumentValue = val;
    [method.methodArguments addObject:arg1];
    MTMethodArgument * arg2 = [MTMethodArgument argumentForType:@"@"];
    UIEvent * event = UIEvent.new;
    arg2.argumentValue = [NSValue valueWithNonretainedObject:event];
    [method.methodArguments addObject:arg2];
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


- (void)test_MTMethod_Monitor_OLD_CODE{
    
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
        XCTAssertEqual(methodInvoc.method.methodArguments.count, 1, @"args should be: 1");
        MTMethodArgument * argv = methodInvoc.method.methodArguments.firstObject;
        
        XCTAssertEqual(argv.argumentValue ,(NSValue*)vc.button1, @"args should be:%@, not: %@ ",vc.button1, methodInvoc.method.methodArguments.firstObject);
    }] userInfo:[OCMArg any]];
    
    vc.string1 = @"ACTION_BUTTON_1";
    
    [vc actionButton1:vc.button1];
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
    
    [observerMock verify];
    
    XCTAssertEqualObjects(vc.string2, @"ACTION_BUTTON_1", @"should be PRESSED");
    
}


- (void)test_MTMethod_Monitor_void_one_object_arg{
    
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
        XCTAssertEqual(methodInvoc.method.methodArguments.count, 1, @"args should be: 1");
        MTMethodArgument * argv = methodInvoc.method.methodArguments.firstObject;
        
        XCTAssertEqual(argv.argumentValue ,(NSValue*)vc.button1, @"args should be:%@, not: %@ ",vc.button1, methodInvoc.method.methodArguments.firstObject);
    }] userInfo:[OCMArg any]];
    
    vc.string1 = @"ACTION_BUTTON_1";
    
    [vc actionButton1:vc.button1];
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
    
    [observerMock verify];
    
    XCTAssertEqualObjects(vc.string2, @"ACTION_BUTTON_1", @"should be PRESSED");
    
}


- (void)test_MTMethod_Monitor_void_two_object_arg{
    
    TXTestViewController * vc = TXTestViewController.new;
    
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
    vc.xfaProperties = @{}.mutableCopy;
    
    MTMethod * method = [self methodButton2:vc];
    
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
        XCTAssertEqual(methodInvoc.method.methodArguments.count, 2, @"args should be: 1");
        MTMethodArgument * argv1 = methodInvoc.method.methodArguments.firstObject;
        
        XCTAssertEqual(argv1.argumentValue ,(NSValue*)vc.button2, @"args should be:%@, not: %@ ",vc.button1, methodInvoc.method.methodArguments.firstObject);
        
        MTMethodArgument * argv2 = [methodInvoc.method.methodArguments objectAtIndex:1];
        
        XCTAssert([argv2.argumentValue isKindOfClass:[UIEvent class]]);
        
    }] userInfo:[OCMArg any]];
    
    vc.string1 = @"ACTION_BUTTON_1";
    
    [vc actionButton2:vc.button2 event:UIEvent.new];
    
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
    
    [observerMock verify];
    
    XCTAssertEqualObjects(vc.string2, @"ACTION_BUTTON_1", @"should be PRESSED");
    
}




- (void)test_MTMethod_Monitor_AOP
{
    
    TXTestViewController * vc = TXTestViewController.new;
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
    vc.xfaProperties = @{}.mutableCopy;
    
    NSError * errorAspectHook = nil;
    MTMethod * method = [self methodButton1:vc];
    [TXTestViewController aspect_hookSelector:@selector(actionButton1:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo, id sender) {
        MTVcMethodInvocation * mvcInvo = MTVcMethodInvocation.new;
        mvcInvo.method = method;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_METHOD_INVOCATION object:mvcInvo userInfo:nil];
    } error:&errorAspectHook];
    
    XCTAssert(!errorAspectHook, @"aspect error:%@",errorAspectHook.localizedDescription);
    
    id observerMock = [OCMockObject observerMock];
    
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                     name:NOTIF_METHOD_INVOCATION
                                                   object:nil];
    
    [[observerMock expect] notificationWithName:NOTIF_METHOD_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertNotNil(obj, @"no notification");
        XCTAssert([obj isKindOfClass:MTMethodInvocation.class], @"should be a MTMethodInvocation");
        MTMethodInvocation * methodInvoc = obj;
        XCTAssertNotNil(methodInvoc.method, @"no method");
        XCTAssertEqual(methodInvoc.method, method, @"not right method");
        XCTAssertEqual(methodInvoc.method.methodArguments.count, 1, @"methodArguments count should be 1");
        MTMethodArgument * arg = methodInvoc.method.methodArguments.firstObject;
        NSValue * argvalue = arg.argumentValue;
        
        XCTAssert(argvalue , @"should be a argument value");

        XCTAssertEqual(argvalue.nonretainedObjectValue ,(NSValue*)vc.button1, @"args should be:%@, not: %@ ",vc.button1, methodInvoc.method.methodArguments.firstObject);
    }] userInfo:[OCMArg any]];
    
    vc.string1 = @"ACTION_BUTTON_1";
    
    [vc actionButton1:vc.button1];
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
    
    
    [observerMock verify];
    
    XCTAssertEqualObjects(vc.string2, @"ACTION_BUTTON_1", @"should be PRESSED");
    
}


-(void)testMultiCalls_OLD_CODE
{
    
}



@end
