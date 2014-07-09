//
//  MTVcMethodInvocation.h
//  POC2
//
//  Created by Mohammed Tillawy on 4/1/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "MTMethodInvocation.h"

@interface MTVcMethodInvocation : MTMethodInvocation

+(NSDictionary*)dicStateOfViewController:(UIViewController*)vc;

@property (nonatomic,readonly) NSDictionary * vcStateBefore;
@property (nonatomic,readonly) NSDictionary * vcStateAfter;

-(void)saveVcStateBefore;
-(void)saveVcStateAfter;

@end
