//
//  XFObjcVcClassTests.m
//  xflowapp
//
//  Created by Mohammed Tillawy on 12/2/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "XFObjcVcClass.h"

@interface XFObjcVcClassTests : XCTestCase

@end

@implementation XFObjcVcClassTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParsingAViewContollerClass {
    // This is an example of a functional test case.
    
    NSBundle *bundle = [NSBundle bundleForClass: [self class]];
    NSString * str = [NSString stringWithFormat:@"vc.json"];
    NSString * filePath = [bundle pathForResource:str ofType:nil];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    NSError * err = nil;
    NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    XCTAssertNil(err);
    XFObjcVcClass * vc = [MTLJSONAdapter modelOfClass:[XFObjcVcClass class] fromJSONDictionary:jsonDic error:&err];
    
    XCTAssertNil(err);
    XCTAssert(vc, @"Pass");
    XCTAssertEqual(vc.methods.count, 2);
    XCTAssertEqual(vc.properties.count, 10);
}


@end
