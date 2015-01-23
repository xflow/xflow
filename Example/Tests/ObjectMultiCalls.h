//
//  ObjectMultiCalls.h
//  xFlowApp
//
//  Created by Mohammed Tillawy on 7/17/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//


#import <UIKit/UIViewController.h>

@interface ObjectMultiCalls : UIViewController

-(void)call0; // calls call1

-(void)call1; // calls call2

-(void)call2; // calls call3

-(void)call3; // calls nothing.

@end
