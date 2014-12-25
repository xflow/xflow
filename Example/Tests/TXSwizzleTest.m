//
//  TXSwizzleTest.m
//  POC2
//
//  Created by Mohammed Tillawy on 2/27/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MTSwizzleManager.h"

#import "TXTestObject.h"

#import "MTMethodsList.h"


#import "XFAConstants.h"

//#import "XFAFeedService.h"
#import "MTMethod.h"
#import "MTMethodArgument.h"
#import "TXTestViewController.h"
#import "MTMethodInvocation.h"

@interface TXSwizzleTest : XCTestCase

@end

@implementation TXSwizzleTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}
/*
-(void)testString{
    id obj = [OCMockObject  mockForClass:[NSString class]];
    [[[obj stub] andReturn:@"HI MAN"] lowercaseString];
    
    NSString * s = [obj lowercaseString];
    NSLog(@"%@",s);
    
    id obj2 = [OCMockObject mockForClass:[TXTestObject class]];
    [[[obj2 stub] andReturn:@"hi"] voidClassMethod];
    NSString * s2 =  [obj2 voidClassMethod];
    NSLog(@"s2: %@",s2);

    
    
}
*/


- (void)testBasicNotification
{
    
    MTSwizzleManager * swzlMgr = [MTSwizzleManager new];
    
    TXTestObject * obj = [TXTestObject new];
  
    [swzlMgr swizzleAllMethodsOfObject:obj];
    
    MTMethod * method = [swzlMgr methodForObject:obj
                                        withName:@"publicVoidMethod"];
    
    XCTAssertNotNil(method, @"no method");
    
    id observerMock = [OCMockObject observerMock];
    
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                     name:NOTIF_METHOD
                                                   object:nil];
  
    [[observerMock expect] notificationWithName:NOTIF_METHOD
                                         object:method
                                       userInfo:[OCMArg any] ];
    
    [obj publicVoidMethod];
    
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
    
    [observerMock verify];
}



- (void)testTXTestViewControllerBasicFunctionality{
    TXTestViewController * vc = TXTestViewController.new;
    vc.string1 = @"TEXT1";
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
    XCTAssertNotNil(vc.button1, @"");

    
    vc.string1 = @"TEXT2";
    [vc.button1 sendActionsForControlEvents:UIControlEventTouchUpInside];
    XCTAssertEqual(vc.string2, @"TEXT2", @"should be TEXT2");
    
}


- (void)testTXTestViewControllerBasicFunc3{
    TXTestViewController * vc = TXTestViewController.new;
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
    NSString * const SOME_STRING = @"SOME_STRING";

    XCTAssertNotEqualObjects(vc.string1, SOME_STRING,@"should not be %@",SOME_STRING);
    vc.string1 = SOME_STRING;
    
    MTMethod * method = [MTMethod new];
    method.methodName = @"actionButton2:event:";
    method.methodReturnType = @"v";
    method.methodTypeEncoding = @"v16@0:4@8@12";
    UIButton * btn = vc.button2;
    XCTAssert(btn, @"no button");
    NSValue * val = [NSValue valueWithNonretainedObject:btn];
    MTMethodArgument * arg1 = [MTMethodArgument argumentForType:@"@"];
    XCTAssert(val.nonretainedObjectValue, @"no value");
    arg1.argumentValue = val;
//    [method.methodArguments addObject:arg1]
    method.methodArguments = [method.methodArguments arrayByAddingObject:arg1];
    MTMethodArgument * arg2 = [MTMethodArgument argumentForType:@"@"];
    UIEvent * event;
    event = [UIEvent new];
    arg2.argumentValue =[NSValue valueWithNonretainedObject:event];
//    [method.methodArguments addObject:arg2];
    method.methodArguments = [method.methodArguments arrayByAddingObject:arg2];
    
    [method applyTo:vc];
    
    XCTAssertEqualObjects(vc.string2, SOME_STRING , @"should be %@",SOME_STRING);
    
}







/*
-(void)testInvocationNotification{
    
    TXTestViewController * vc = TXTestViewController.new;
    
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
    
    MTMethod * m = [self methodButton2];
    
    [m monitorForObject:vc];
    
    id observerMock = [OCMockObject observerMock];
    
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                     name:NOTIF_METHOD_INVOCATION
                                                   object:nil];
    
    [[observerMock expect] notificationWithName:NOTIF_METHOD_INVOCATION object:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssert([obj isMemberOfClass:MTMethodInvocation.class], @"should be a MTMethodInvocation");
    }] userInfo:[OCMArg any] ];

    vc.string1 = @"TEXT2";
    
    [vc.button2 sendActionsForControlEvents:UIControlEventTouchUpInside];

    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
    
    [observerMock verify];
    
//    XCTAssertEqualObjects(vc.label.text, @"TEXT2", @"should be TEXT2");
    
}
*/


-(void)testPlay{
    
//    id obj = [OCMockObject mockForClass:[TXTestObject class]];
    
//    MTRecorderSession * session = MTRecorderSession.new;
    
    MTMethodsList *ml = MTMethodsList.new;
    
    NSArray * arr = [ml methods:TXTestObject.new];
    
    XCTAssertTrue(arr.count > 1, @"no methods");
    
//    MTMeasureEngine * engine = MTMeasureEngine.new;
    
//    TXPlan * plan = TXPlan.new;
    
//    TXAction * action1 = TXAction.new;
//    MTMethod * method = MTMethod.new;
//    method.methodName =

//    action1.method = method;
    
//    [plan addAction:action1];
    
//    [engine playTestPlan:plan];
    
}






@end

