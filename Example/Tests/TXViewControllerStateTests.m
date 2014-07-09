//
//  TXViewControllerState.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/8/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TXViewControllerState.h"

@interface TXViewControllerStateTests : XCTestCase

@end

@implementation TXViewControllerStateTests

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

- (void)testObjectsPathRootVC
{
    UIViewController * rootVC = UIViewController.new;
    UIViewController * vc1 = UIViewController.new;
    [rootVC addChildViewController:vc1];
    
    TXViewControllerState * vcState = TXViewControllerState.new;
    NSArray * array = [vcState viewControllerObjectsPathToWindow:rootVC];
    NSLog(@"%@",array);
    NSArray * expectedOutput = @[ @"self.window.rootViewController"];
    XCTAssertEqualObjects(array, expectedOutput, @"output not nice");
}

- (void)testObjectsPathChildVC
{
    UIViewController * rootVC = UIViewController.new;
    UIViewController * vc1 = UIViewController.new;
    [rootVC addChildViewController:vc1];
    
    TXViewControllerState * vcState = TXViewControllerState.new;
    NSArray * array = [vcState viewControllerObjectsPathToWindow:vc1];
    NSLog(@"%@",array);
    NSArray * expectedOutput = @[ @"self.window.rootViewController",
                                  @"childViewControllers[0]"];
    XCTAssertEqualObjects(array, expectedOutput, @"output not nice");
}


- (void)testClassesPathRootVC
{
    UIViewController * rootVC = UIViewController.new;
    UIViewController * vc1 = UIViewController.new;
    [rootVC addChildViewController:vc1];
    
    TXViewControllerState * vcState = TXViewControllerState.new;
    NSArray * array = [vcState viewControllerClassesPathToWindow:rootVC];
    NSLog(@"%@",array);
    NSArray * expectedOutput = @[ @"UIViewController" ];
    XCTAssertEqualObjects(array, expectedOutput, @"output not nice");
}


- (void)testClassesPathChildVC
{
    UIViewController * rootVC = UIViewController.new;
    UIViewController * vc1 = UIViewController.new;
    [rootVC addChildViewController:vc1];
    
    TXViewControllerState * vcState = TXViewControllerState.new;
    NSArray * array = [vcState viewControllerClassesPathToWindow:vc1];
    NSLog(@"%@",array);
    NSArray * expectedOutput = @[ @"UIViewController",
                                  @"UIViewController" ];
    XCTAssertEqualObjects(array, expectedOutput, @"output not nice");
}






@end




