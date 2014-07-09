//
//  TXViewControllerState.h
//  POC2
//
//  Created by Mohammed Tillawy on 3/8/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXViewControllerState : NSObject

-(NSArray *)viewControllerObjectsPathToWindow:(UIViewController *)vc;
-(NSArray *)viewControllerClassesPathToWindow:(UIViewController*)vc;

@end
