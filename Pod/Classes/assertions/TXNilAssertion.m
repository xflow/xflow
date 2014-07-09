//
//  TXNotNilAssertion.m
//  POC2
//
//  Created by Mohammed Tillawy on 4/16/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "TXNilAssertion.h"

@implementation TXNilAssertion



-(void)evaluate:(NSValue *)val
{
    NSLog(@"self.value.boolValue :%d",self.assertionValue.boolValue );
    if ( ! self.assertionValue.boolValue &&  ! val ){
        [self reportFailure];
    }
}



@end
