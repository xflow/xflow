//
//  TXViewControllerState.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/8/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XFAViewControllerState.h"
@import UIKit;

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
    
//    XFAViewControllerState * vcState = [XFAViewControllerState new];
    NSArray * array = [XFAViewControllerState viewControllerObjectsPathToWindow:rootVC];
    NSLog(@"%@",array);
    NSArray * expectedOutput = @[ @"self.window.rootViewController"];
    XCTAssertEqualObjects(array, expectedOutput, @"output not nice");
}

- (void)testObjectsPathChildVC
{
    UIViewController * rootVC = UIViewController.new;
    UIViewController * vc1 = UIViewController.new;
    [rootVC addChildViewController:vc1];
    
//    XFAViewControllerState * vcState = [XFAViewControllerState new];
    NSArray * array = [XFAViewControllerState viewControllerObjectsPathToWindow:vc1];
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
    
//    XFAViewControllerState * vcState = [XFAViewControllerState new];
    NSArray * array = [XFAViewControllerState viewControllerClassesPathToWindow:rootVC];
    NSLog(@"%@",array);
    NSArray * expectedOutput = @[ @"UIViewController" ];
    XCTAssertEqualObjects(array, expectedOutput, @"output not nice");
}


- (void)testClassesPathChildVC
{
    UIViewController * rootVC = UIViewController.new;
    UIViewController * vc1 = UIViewController.new;
    [rootVC addChildViewController:vc1];
    
//    XFAViewControllerState * vcState = [XFAViewControllerState new];
    NSArray * array = [XFAViewControllerState viewControllerClassesPathToWindow:vc1];
    NSLog(@"%@",array);
    NSArray * expectedOutput = @[ @"UIViewController",
                                  @"UIViewController" ];
    XCTAssertEqualObjects(array, expectedOutput, @"output not nice");
}






@end




