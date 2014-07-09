//
//  MTCrawler.m
//  Contexter
//
//  Created by Mohammed Tillawy on 11/6/13.
//  Copyright (c) 2013 Mohammed Tillawy. All rights reserved.
//

#import "XFACrawler.h"
#import <UIKit/UIKit.h>

@implementation XFACrawler

/*
 -(void)crawl{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIViewController *vc = window.rootViewController;
    
//    [self childControllers:vc level:0];
}
*/

/* this should come from the API service  */

-(NSString *)childrenKeyForObject:(NSObject*)obj{
    NSDictionary *dic = @{ @"UINavigationController": @"viewControllers",
                           @"UITabBarController": @"viewControllers",
                           @"UIViewController": @"childViewControllers",
                          };
    NSString * output = nil;
    for (NSString * k in dic.allKeys) {
        NSLog(@"%@",k);
        if ([obj isKindOfClass:NSClassFromString(k)]) {
            output = k;
            break;
        }
    }
    return [dic objectForKey:output];
}

-(void)childControllers:(UIViewController *)viewController
                  level:(NSInteger)level
                  andDo:(void (^)(NSObject *obj))block
{
    
    NSString *childrenKey = [self childrenKeyForObject:viewController];
    /* if ([viewController isKindOfClass:[UINavigationController class]]) {
        childrenKey = @"viewControllers";
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        childrenKey = @"viewControllers";
    } else {
        childrenKey = @"childViewControllers";
    }*/
    
    
    NSArray *children = [viewController valueForKey:childrenKey];
    
    NSLog(@"%@",viewController.class);
    block(viewController);
//    [self subviews:viewController.view level:0];

    for (UIViewController *vc in children) {
        [self childControllers:vc level:level+1 andDo:block];
    }
}



/*
-(void)subviews:(UIView*)view level:(NSInteger)level{
    NSLog(@" • %d %@ %@",view.subviews.count,view.class,view.superclass);
//    if ([[view.class description] isEqualToString:@"_UIBackdropView"]) {
//        return;
//    }
    
    NSDictionary *dic = [view properties_values_keys];
//    NSString *parentPath = level > 0 ?  view.parentTpath : [NSString stringWithFormat:@"/%@",NSStringFromClass(view.class)];
    
    if (level == 0) {
        view.parentTpath = @"/";
    }
    
    NSLog(@"%@",view.tpath);

    for (UIView *v in view.subviews) {
        
        v.parentTpath = view.tpath;
        NSNumber *ok = [NSNumber numberWithInteger:v.hash];
        NSString *k = [dic objectForKey:ok];
//        NSLog(@"%d %@ %@",level,[v class],k);
        NSLog(@"%@",v.parentTpath);
        [self subviews:v level:level+1];

    }
}
*/

@end
