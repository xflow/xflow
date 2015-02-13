//
//  TXViewControllerState.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/8/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAViewControllerState.h"

@implementation XFAViewControllerState


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



-(NSArray *)viewControllerObjectsPathToWindow:(UIViewController*)vc{
    
    NSArray * path = nil;
    
    if (vc.parentViewController) {
        NSArray * parentPath = nil;
        parentPath = [self viewControllerObjectsPathToWindow:vc.parentViewController];
        
        if ([vc.parentViewController isKindOfClass:[UINavigationController class]]) {
            UITabBarController * tbvc = (UITabBarController *)vc.parentViewController;
            NSInteger idx = [tbvc.childViewControllers indexOfObject:vc];

            NSString * p = [NSString stringWithFormat:@"childViewControllers[%d]",idx];
            path = [NSArray arrayWithObject:p];
            
        } else if ([vc.parentViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController * tbvc = (UITabBarController *)vc.parentViewController;
            NSInteger idx = [tbvc.viewControllers indexOfObject:vc];
            
            NSString * p = [NSString stringWithFormat:@"viewControllers[%d]",idx];
            path = [NSArray arrayWithObject:p];

        } else {
            UITabBarController * tbvc = (UITabBarController *)vc.parentViewController;
            NSInteger idx = [tbvc.childViewControllers indexOfObject:vc];

            NSString * p = [NSString stringWithFormat:@"childViewControllers[%d]",idx];
            path = [NSArray arrayWithObject:p];
        }
        path = [parentPath arrayByAddingObjectsFromArray:path];
        
    } else {
         path = @[@"self.window.rootViewController"];
    }
    
    return path;
}


-(NSArray *)viewControllerClassesPathToWindow:(UIViewController*)vc{
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

@end
