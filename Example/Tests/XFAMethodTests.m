//
//  XFAMethodTests.m
//  xflowapp
//
//  Created by Mohammed Tillawy on 7/16/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XFAMethod.h"
#import "TXTestViewController.h"
#import "MTMethodInvocation.h"
#import "MTMethodArgument.h"
#import "MTVcMethodInvocation.h"
#import <OCMock/OCMock.h>
#import "XFAConstants.h"
#import "UIViewController+XFAProperties.h"
#import <Aspects/Aspects.h>
#import "ObjectMultiCalls.h"
#import "ObjectRecursiveCalls.h"
#import "XFAInvocationAOP.h"


@interface XFAMethodTests : XCTestCase{
    XFAInvocationAOP * aop;
}

@end

@implementation XFAMethodTests

- (void)setUp
{
    [super setUp];
    aop = [XFAInvocationAOP new];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



-(XFAMethod*)methodButton1:(TXTestViewController*)vc{
    XFAMethod * method = [XFAMethod new];
    method.methodName = @"actionButton1:";
    method.methodReturnType = @"v";
    method.methodTypeEncoding = @"v12@0:4@8";
    UIButton * btn = vc.button1;
    XCTAssert(btn, @"no button");
    NSValue * val = [NSValue valueWithNonretainedObject:btn];
    MTMethodArgument * arg1 = [MTMethodArgument argumentForType:@"@"];
    XCTAssert(val.nonretainedObjectValue, @"no value");
    arg1.argumentValue = val;
//    [method.methodArguments addObject:arg1];
    method.methodArguments = [method.methodArguments arrayByAddingObject:arg1];
    return method;
}

-(XFAMethod*)methodButton2:(TXTestViewController*)vc{
    XFAMethod * method = [XFAMethod new];
    method.methodName = @"actionButton2:event:";
    method.methodReturnType = @"v";
    method.methodTypeEncoding = @"v16@0:4@8@12";
    UIButton * btn = vc.button1;
    XCTAssert(btn, @"no button");
    NSValue * val = [NSValue valueWithNonretainedObject:btn];
    MTMethodArgument * arg1 = [MTMethodArgument argumentForType:@"@"];
    XCTAssert(val.nonretainedObjectValue, @"no value");
    arg1.argumentValue = val;
//    [method.methodArguments addObject:arg1];
    method.methodArguments = [method.methodArguments arrayByAddingObject:arg1];
    MTMethodArgument * arg2 = [MTMethodArgument argumentForType:@"@"];
    UIEvent * event = UIEvent.new;
    arg2.argumentValue = [NSValue valueWithNonretainedObject:event];
//    [method.methodArguments addObject:arg2];
    method.methodArguments = [method.methodArguments arrayByAddingObject:arg2];
    return method;
}


- (void)test_MTMethod_ApplyTo_{
    TXTestViewController * vc = [TXTestViewController new];
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
    vc.string1 = @"TEXT2";
    
    XFAMethod * method = [self methodButton1:vc];
    [method applyTo:vc];
    
    XCTAssertEqual(vc.string2, @"TEXT2", @"should be TEXT2");
}




- (void)test_MTMethod_Monitor_AOP
{
    
    TXTestViewController * vc = TXTestViewController.new;
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
    vc.xfaProperties = @{}.mutableCopy;
    
    NSError * errorAspectHook = nil;
    XFAMethod * method = [self methodButton1:vc];

    [aop invoAopPre:vc method:method];
    
    XCTAssert(!errorAspectHook, @"aspect error:%@",errorAspectHook.localizedDescription);
    
    id observerMock = [OCMockObject observerMock];
    
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                     name:NOTIF_METHOD_PRE_INVOCATION
                                                   object:nil];
    
    [[observerMock expect] notificationWithName:NOTIF_METHOD_PRE_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
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
        return TRUE;
    }] userInfo:[OCMArg any]];
    
    vc.string1 = @"ACTION_BUTTON_1";
    
    [vc actionButton1:vc.button1];
    
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
    
    [observerMock verify];
    
    XCTAssertEqualObjects(vc.string2, @"ACTION_BUTTON_1", @"should be PRESSED");
    
}



-(XFAMethod*)methodCall:(NSObject *)vc selector:(SEL)selector{
    XFAMethod * method = [XFAMethod new];
    method.methodName = NSStringFromSelector(selector);
    method.methodReturnType = @"v";
    method.methodTypeEncoding = @"v16@0:8";
    return method;
}


-(void)test_Multi_Calls_AOP
{
    
    ObjectMultiCalls * objTestSubject = [ObjectMultiCalls new];
    objTestSubject.xfaProperties = @{}.mutableCopy;
    XFAMethod * method0 = [self methodCall:objTestSubject selector:@selector(call0)];
    id<AspectToken>tok00 = [aop invoAopPre:objTestSubject method:method0];
    id<AspectToken>tok01 = [aop invoAopPost:objTestSubject method:method0];
    XCTAssert(tok00);
    XCTAssert(tok01);
    __block MTMethodInvocation * invo0 = nil;
    
    XFAMethod * method1 = [self methodCall:objTestSubject selector:@selector(call1)];
    [aop invoAopPre:objTestSubject method:method1];
    [aop invoAopPost:objTestSubject method:method1];

    __block MTMethodInvocation * invo1 = nil;
    
    XFAMethod * method2 = [self methodCall:objTestSubject selector:@selector(call2)];
    [aop invoAopPre:objTestSubject method:method2];
    [aop invoAopPost:objTestSubject method:method2];

    __block MTMethodInvocation * invo2 = nil;
    
    XFAMethod * method3 = [self methodCall:objTestSubject selector:@selector(call3)];
    
    [aop invoAopPre:objTestSubject method:method3];
    [aop invoAopPost:objTestSubject method:method3];

    __block MTMethodInvocation * invo3 = nil;
    
    id observerMock = [OCMockObject observerMock];
    
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                     name:NOTIF_METHOD_PRE_INVOCATION
                                                   object:nil];
    
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                     name:NOTIF_METHOD_POST_INVOCATION
                                                   object:nil];
    

    [[observerMock expect] notificationWithName:NOTIF_METHOD_PRE_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        MTMethodInvocation * invo = (MTMethodInvocation *) obj;
        NSLog(@"NOTIF_METHOD_PRE_INVOCATION %@",invo.method.methodName);
        if (![invo.method.methodName isEqualToString:@"call3"]) {
            return NO;
        }
        invo3 = (MTMethodInvocation *)obj;
        XCTAssertFalse(invo3.isFirstInVirtualStack, @"should not be first");
        return YES;
    }] userInfo:[OCMArg any]];
    

    [[observerMock expect] notificationWithName:NOTIF_METHOD_PRE_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        MTMethodInvocation * invo = (MTMethodInvocation *) obj;
        NSLog(@"NOTIF_METHOD_PRE_INVOCATION %@",invo.method.methodName);
        if (![invo.method.methodName isEqualToString:@"call0"]) {
            return NO;
        }
        invo0 = invo;
        XCTAssertTrue(invo0.isFirstInVirtualStack, @"should be first");
        return YES;
    }] userInfo:[OCMArg any]];

    [[observerMock expect] notificationWithName:NOTIF_METHOD_PRE_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        MTMethodInvocation * invo = (MTMethodInvocation *) obj;
        NSLog(@"NOTIF_METHOD_PRE_INVOCATION %@",invo.method.methodName);
        if (![invo.method.methodName isEqualToString:@"call1"]) {
            return NO;
        }
        invo1 = (MTMethodInvocation *)obj;
        XCTAssertFalse(invo1.isFirstInVirtualStack, @"should not be first");
        return YES;
    }] userInfo:[OCMArg any]];
    
    [[observerMock expect] notificationWithName:NOTIF_METHOD_PRE_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        MTMethodInvocation * invo = (MTMethodInvocation *) obj;
        NSLog(@"NOTIF_METHOD_PRE_INVOCATION %@",invo.method.methodName);
        if (![invo.method.methodName isEqualToString:@"call2"]) {
            return NO;
        }
        invo2 = (MTMethodInvocation *)obj;
        XCTAssertFalse(invo2.isFirstInVirtualStack, @"should not be first");
        return YES;
    }] userInfo:[OCMArg any]];
    

    [[observerMock expect] notificationWithName:NOTIF_METHOD_POST_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        MTMethodInvocation * invo = (MTMethodInvocation *) obj;
        NSLog(@"NOTIF_METHOD_POST_INVOCATION %@",invo.method.methodName);
        if (![invo.method.methodName isEqualToString:@"call0"]) {
            return NO;
        }
        XCTAssertEqualObjects(invo0, obj, @"expeted invo0");
        XCTAssertTrue(invo0.isFirstInVirtualStack, @"should be first");
        return YES;
    }] userInfo:[OCMArg any]];

    
    [[observerMock expect] notificationWithName:NOTIF_METHOD_POST_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        
        MTMethodInvocation * invo = (MTMethodInvocation *) obj;
        NSLog(@"NOTIF_METHOD_POST_INVOCATION %@",invo.method.methodName);
        if (![invo.method.methodName isEqualToString:@"call1"]) {
            return NO;
        }
        
        XCTAssertEqualObjects(invo1, obj, @"expeted invo0");
        XCTAssertFalse(invo1.isFirstInVirtualStack, @"should not be first");
        return YES;
    }] userInfo:[OCMArg any]];

    
    [[observerMock expect] notificationWithName:NOTIF_METHOD_POST_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        NSLog(@"NOTIF_METHOD_POST_INVOCATION");
        
        MTMethodInvocation * invo = (MTMethodInvocation *) obj;
        NSLog(@"NOTIF_METHOD_POST_INVOCATION %@",invo.method.methodName);
        if (![invo.method.methodName isEqualToString:@"call2"]) {
            return NO;
        }
        
        XCTAssertEqualObjects(invo2, obj, @"expeted invo2");
        XCTAssertFalse(invo2.isFirstInVirtualStack, @"should not be first");
        return YES;
    }] userInfo:[OCMArg any]];

    
    [[observerMock expect] notificationWithName:NOTIF_METHOD_POST_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        
        MTMethodInvocation * invo = (MTMethodInvocation *) obj;
        NSLog(@"NOTIF_METHOD_POST_INVOCATION %@",invo.method.methodName);
        if (![invo.method.methodName isEqualToString:@"call3"]) {
            return NO;
        }
        
        XCTAssertEqualObjects(invo3, obj, @"expeted invo0");
        XCTAssertFalse(invo3.isFirstInVirtualStack, @"should not be first");
        return YES;
    }] userInfo:[OCMArg any]];

    [objTestSubject call0];
    
    [observerMock verify];
    
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
    [aop removeAllHooks];
}


-(void)test_twice_Recursive_Calls{
    
    ObjectRecursiveCalls * objcTestSubject = [ObjectRecursiveCalls new];
    objcTestSubject.xfaProperties = @{}.mutableCopy;
    XFAMethod * method0 = [self methodCall:objcTestSubject selector:@selector(callfirst)];

    [aop invoAopPre:objcTestSubject method:method0];
    [aop invoAopPost:objcTestSubject method:method0];
    
    __block MTMethodInvocation * invo0 = nil;
    
    XFAMethod * method1 = [self methodCall:objcTestSubject selector:@selector(calledTwoTimes)];

    [aop invoAopPre:objcTestSubject method:method1];
    [aop invoAopPost:objcTestSubject method:method1];
    
    __block MTMethodInvocation * invo1 = nil;
    __block MTMethodInvocation * invo2 = nil;
    
    id observerMock = [OCMockObject observerMock];
    
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                     name:NOTIF_METHOD_PRE_INVOCATION
                                                   object:nil];
    
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                     name:NOTIF_METHOD_POST_INVOCATION
                                                   object:nil];
    
     // 1
    [[observerMock expect] notificationWithName:NOTIF_METHOD_PRE_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        MTMethodInvocation * invo = (MTMethodInvocation *) obj;
        NSLog(@"NOTIF_METHOD_PRE_INVOCATION 1 %@",invo.method.methodName);
        if (![invo.method.methodName isEqualToString:@"callfirst"]) {
            return NO;
        }
        invo0 = invo;
        XCTAssertTrue(invo0.isFirstInVirtualStack, @"should be first");
        return YES;
    }] userInfo:[OCMArg any]];
    
    // 2
    [[observerMock expect] notificationWithName:NOTIF_METHOD_PRE_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        MTMethodInvocation * invo = (MTMethodInvocation *) obj;
        NSLog(@"NOTIF_METHOD_PRE_INVOCATION 2 %@",invo.method.methodName);
        if (![invo.method.methodName isEqualToString:@"calledTwoTimes"]) {
            return NO;
        }
        invo1 = invo;
        XCTAssertFalse(invo1.isFirstInVirtualStack, @"should be first");
        return YES;
    }] userInfo:[OCMArg any]];
    
    // 3
    [[observerMock expect] notificationWithName:NOTIF_METHOD_PRE_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        MTMethodInvocation * invo = (MTMethodInvocation *) obj;
        NSLog(@"NOTIF_METHOD_PRE_INVOCATION 3 %@",invo.method.methodName);
        if (![invo.method.methodName isEqualToString:@"calledTwoTimes"]) {
            return NO;
        }
        invo2 = invo;
        XCTAssertNotEqual(invo, invo1, @"should not be equal");
        XCTAssertFalse(invo2.isFirstInVirtualStack, @"should be first");
        return YES;
    }] userInfo:[OCMArg any]];
    
    // 4
    [[observerMock expect] notificationWithName:NOTIF_METHOD_POST_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        
        MTMethodInvocation * invo = (MTMethodInvocation *) obj;
        NSLog(@"NOTIF_METHOD_POST_INVOCATION 4 %@",invo.method.methodName);
        if (![invo.method.methodName isEqualToString:@"callfirst"]) {
            return NO;
        }
        
        XCTAssertEqualObjects(invo0, obj, @"expeted invo0");
        XCTAssertTrue(invo0.isFirstInVirtualStack, @"should not be first");
        return YES;
    }] userInfo:[OCMArg any]];
    
     // 5
    [[observerMock expect] notificationWithName:NOTIF_METHOD_POST_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        
        MTMethodInvocation * invo = (MTMethodInvocation *) obj;
        NSLog(@"NOTIF_METHOD_POST_INVOCATION 5 %@",invo.method.methodName);
        if (![invo.method.methodName isEqualToString:@"calledTwoTimes"]) {
            return NO;
        }
        
        XCTAssertEqualObjects(invo1, obj, @"expeted invo0");
        XCTAssertFalse(invo1.isFirstInVirtualStack, @"should not be first");
        return YES;
    }] userInfo:[OCMArg any]];
    
    // 6
    [[observerMock expect] notificationWithName:NOTIF_METHOD_POST_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        
        MTMethodInvocation * invo = (MTMethodInvocation *) obj;
        NSLog(@"NOTIF_METHOD_POST_INVOCATION 6 %@",invo.method.methodName);
        if (![invo.method.methodName isEqualToString:@"calledTwoTimes"]) {
            return NO;
        }
        
        XCTAssertEqualObjects(invo2, obj, @"expeted invo0");
        XCTAssertFalse(invo2.isFirstInVirtualStack, @"should not be first");
        return YES;
    }] userInfo:[OCMArg any]];
    
    [objcTestSubject callfirst];
    
    [observerMock verify];
    
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
    [aop removeAllHooks];
}

@end
