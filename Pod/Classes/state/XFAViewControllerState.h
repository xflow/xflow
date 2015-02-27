//
//  TXViewControllerState.h
//  POC2
//
//  Created by Mohammed Tillawy on 3/8/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
@class UIViewController;

@interface XFAViewControllerState : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSArray * vcPath;
//@property (nonatomic, strong) NSArray * vcClassesPath;
//@property (nonatomic, strong) NSArray * vcObjectsPath;

@property (nonatomic, strong) NSDictionary * vcProperties;
@property (nonatomic, strong) NSNumber * objHash;

+(NSArray *)viewControllerObjectsPathToWindow:(UIViewController *)vc;
+(NSArray *)viewControllerClassesPathToWindow:(UIViewController*)vc;
+(NSArray *)viewControllerPathToWindow:(UIViewController*)vc;


@end
