//
//  ObjectMultiCalls.m
//  xflowapp
//
//  Created by Mohammed Tillawy on 7/17/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "ObjectMultiCalls.h"

@implementation ObjectMultiCalls

-(void)call0{
    NSLog(@"call0");
    [self call1];
}

-(void)call1{
    NSLog(@"call1");
    [self call2];
}

-(void)call2{
    NSLog(@"call2");
    [self call3];
}

-(void)call3{
    NSLog(@"call3");
}


@end
