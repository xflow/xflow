//
//  TXLengthMoreThanAssertion.m
//  POC2
//
//  Created by Mohammed Tillawy on 4/17/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "TXLengthMoreThanAssertion.h"

@implementation TXLengthMoreThanAssertion

-(void)evaluate:(NSValue *)value{
    NSObject * obj = value;
    NSLog(@"obj:%@ %@",obj.class,[obj valueForKey:@"length"] );
    NSValue * lengthVal = [obj valueForKey:@"length"];
    NSNumber * lengthNumber = (NSNumber*)lengthVal;
    if (lengthNumber.integerValue < self.assertionValue.integerValue) {
        [self reportFailure];
    }
}

@end
