//
//  TXViewControllerState.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/8/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAViewControllerState.h"

@implementation XFAViewControllerState

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             };
}

-(NSArray *)childControllers:(UIViewController *)viewController {
    return [self childControllers:viewController atLevel:0];
}

-(NSArray *)childControllers:(UIViewController *)viewController atLevel:(NSInteger)level{
    
    NSString *childrenKey = nil;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        childrenKey = @"viewControllers";
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        childrenKey = @"viewControllers";
    } else {
        childrenKey = @"childViewControllers";
    }
    
    NSArray *children = [viewController valueForKey:childrenKey];
    
//    NSString * vcClassesPath = [self viewControllerClassesPathToWindow:viewController];
    
//    NSLog(@"VC class path: %@", vcClassesPath);
    
//    NSString * vcObjectsPath = [self viewControllerObjectsPathToWindow:viewController];
    
//    NSLog(@"VC object path: %@", vcObjectsPath);
    
    for (UIViewController *vc in children) {
        [self childControllers:vc atLevel:level+1];
    }
    
    return nil;
}



+(NSArray *)viewControllerObjectsPathToWindow:(UIViewController*)vc{
    
    NSArray * path = nil;
    
    if (vc.parentViewController) {
        NSArray * parentPath = nil;
        parentPath = [self viewControllerObjectsPathToWindow:vc.parentViewController];
        
        if ([vc.parentViewController isKindOfClass:[UINavigationController class]]) {
            UITabBarController * tbvc = (UITabBarController *)vc.parentViewController;
            NSInteger idx = [tbvc.childViewControllers indexOfObject:vc];

            NSString * p = [NSString stringWithFormat:@"childViewControllers[%ld]",(long)idx];
            path = [NSArray arrayWithObject:p];
            
        } else if ([vc.parentViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController * tbvc = (UITabBarController *)vc.parentViewController;
            NSInteger idx = [tbvc.viewControllers indexOfObject:vc];
            
            NSString * p = [NSString stringWithFormat:@"viewControllers[%ld]",(long)idx];
            path = [NSArray arrayWithObject:p];

        } else {
            UITabBarController * tbvc = (UITabBarController *)vc.parentViewController;
            NSInteger idx = [tbvc.childViewControllers indexOfObject:vc];

            NSString * p = [NSString stringWithFormat:@"childViewControllers[%ld]",(long)idx];
            path = [NSArray arrayWithObject:p];
        }
        path = [parentPath arrayByAddingObjectsFromArray:path];
        
    } else {
         path = @[@"self.window.rootViewController"];
    }
    
    return path;
}


+(NSArray *)viewControllerClassesPathToWindow:(UIViewController*)vc{
    NSString * s = NSStringFromClass(vc.class);
    NSArray * path = nil;
    if (vc.parentViewController){
        NSArray * parentPath = [self viewControllerClassesPathToWindow:vc.parentViewController];
        path = [parentPath arrayByAddingObject:s];
    } else {
        path = @[s];
    }
    return path;
}



+(NSString*)childrenKeyForVC:(UIViewController*)viewController{
    NSString *childrenKey = nil;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        childrenKey = @"viewControllers";
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        childrenKey = @"viewControllers";
    } else {
        childrenKey = @"childViewControllers";
    }
    return childrenKey;
}


NSString * K_ROOT = @"vcRoot";
NSString * K_PARENT_CHILDREN_KEY = @"vcParentChildrenKey";
NSString * K_CHILDREN_KEY = @"vcChildrenKey";
NSString * K_PARENT_CHILDREN_INDEX = @"vcInParentChildIndex";
NSString * K_VC_HASH = @"vcHash";
NSString * K_VC_CLASS = @"vcClass";

+(NSArray *)viewControllerPathToWindow:(UIViewController*)vc
{
    NSArray * path = nil;
    
    if (vc.parentViewController) {
        NSArray * parentPath = nil;
        parentPath = [self viewControllerPathToWindow:vc.parentViewController];
        
        if ([vc.parentViewController isKindOfClass:[UINavigationController class]]) {
            UITabBarController * tbvc = (UITabBarController *)vc.parentViewController;
            NSInteger idx = [tbvc.childViewControllers indexOfObject:vc];
            
//            NSString * p2 = [NSString stringWithFormat:@"childViewControllers"];
//            NSString * p3 = [NSString stringWithFormat:@"%ld",(long)idx];
            path = [NSArray arrayWithObject:@{K_PARENT_CHILDREN_KEY: [self childrenKeyForVC:vc.parentViewController],
                                              K_CHILDREN_KEY: [self childrenKeyForVC:vc] ,
                                              K_PARENT_CHILDREN_INDEX: @(idx) ,
                                              K_VC_HASH: @(vc.hash),
                                              K_VC_CLASS: NSStringFromClass([vc class])}];
            
        } else if ([vc.parentViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController * tbvc = (UITabBarController *)vc.parentViewController;
            NSInteger idx = [tbvc.viewControllers indexOfObject:vc];
            
//            NSString * p2 = [NSString stringWithFormat:@"viewControllers"];
//            NSString * p3 = [NSString stringWithFormat:@"%ld",(long)idx];
            path = [NSArray arrayWithObject:@{K_PARENT_CHILDREN_KEY: [self childrenKeyForVC:vc.parentViewController],
                                              K_CHILDREN_KEY: [self childrenKeyForVC:vc] ,
                                              K_PARENT_CHILDREN_INDEX: @(idx) ,
                                              K_VC_HASH: @(vc.hash),
                                              K_VC_CLASS :NSStringFromClass([vc class])}];
        } else {
            UITabBarController * tbvc = (UITabBarController *)vc.parentViewController;
            NSInteger idx = [tbvc.childViewControllers indexOfObject:vc];
            path = [NSArray arrayWithObject:@{K_PARENT_CHILDREN_KEY: [self childrenKeyForVC:vc.parentViewController],
                                              K_CHILDREN_KEY: [self childrenKeyForVC:vc] ,
                                              K_PARENT_CHILDREN_INDEX: @(idx) ,
                                              K_VC_HASH: @(vc.hash),
                                              K_VC_CLASS :NSStringFromClass([vc class])}];
        }
        path = [parentPath arrayByAddingObjectsFromArray:path];
        
    } else {
        UIViewController * rootVC = vc.view.window.rootViewController;
        path = [NSArray arrayWithObject:@{
                                          K_ROOT : @"self.window.rootViewController" ,
                                          K_CHILDREN_KEY: [self childrenKeyForVC:rootVC] ,
                                          K_VC_CLASS:NSStringFromClass([rootVC class])  ,
                                          K_VC_HASH : @(rootVC.hash)
                                          }];
    }
    
    return path;
}

@end
