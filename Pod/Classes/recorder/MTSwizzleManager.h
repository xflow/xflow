//
//  MTSwizzleManager.h
//  POC2
//
//  Created by Mohammed Tillawy on 1/12/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XFAMethod;

@interface MTSwizzleManager : NSObject

+(instancetype)sharedInstance;

-(void)swizzleAllMethodsOfObject:(NSObject*)obj;

-(XFAMethod*)methodForObject:(NSObject*)obj withName:(NSString*)name;


@end

#define Sm ( (MTSwizzleManager *) [MTSwizzleManager sharedInstance] )
