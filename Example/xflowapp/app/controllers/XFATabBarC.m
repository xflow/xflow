//
//  MTTabBarC.m
//  Contexter
//
//  Created by Mohammed Tillawy on 11/6/13.
//  Copyright (c) 2013 Mohammed Tillawy. All rights reserved.
//

#import "XFATabBarC.h"
//#import <ReactiveCocoa/ReactiveCocoa.h>


@interface XFATabBarC ()

@end

@implementation XFATabBarC


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.selectedViewController = self.viewControllers[1];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /*
    [RACObserve(self, selectedViewController) subscribeNext:^(UIViewController * x) {
        NSLog(@"[XFATabBarC selectedViewController]: %@",x);
    }];
     */
}


-(void)setSelectedViewController:(UIViewController *)selectedViewController{
    [super setSelectedViewController:selectedViewController];
}


@end
