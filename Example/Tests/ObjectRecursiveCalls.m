//
//  ObjectRecursiveCalls.m
//  xflowapp
//
//  Created by Mohammed Tillawy on 7/18/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "ObjectRecursiveCalls.h"


@interface ObjectRecursiveCalls(){
    NSInteger counter;
}

@end


@implementation ObjectRecursiveCalls

- (instancetype)init
{
    self = [super init];
    if (self) {
        counter = 0;
    }
    return self;
}

-(void)callfirst{
    NSLog(@"[ObjectRecursiveCalls call]");
    [self calledTwoTimes];
}

-(void)calledTwoTimes{
    NSLog(@"[ObjectRecursiveCalls calledTwoTimes]");
    if (counter == 0) {
        counter++;
        [self calledTwoTimes];
    }
}


@end
