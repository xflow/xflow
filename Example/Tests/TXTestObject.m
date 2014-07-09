//
//  TXTestObject.m
//  POC2
//
//  Created by Mohammed Tillawy on 2/27/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "TXTestObject.h"



@interface TXTestObject (){
    
}
-(void)privateVoidMethod;
-(NSInteger)privateNSIntegerMethod;

@end


@implementation TXTestObject


+(NSString *)voidClassMethod{
        return @"NOOOO";
}

-(void)publicVoidMethod{
    NSLog(@"publicVoidMethod");
}


-(void)privateVoidMethod{
    NSLog(@"privateVoidMethod");
}

-(NSInteger)privateNSIntegerMethod{
    return 9;
}

-(NSInteger)publicNSIntegerMethod{
    return 1;
}

@end
