//
//  MTMethodArgumentMapVcObjectValue.m
//  POC2
//
//  Created by Mohammed Tillawy on 4/16/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "MTMethodArgumentMapVcObjectValue.h"

@implementation MTMethodArgumentMapVcObjectValue



-(id)value{
    UIWindow * window = [UIApplication sharedApplication].windows.firstObject;
    UIViewController * rootVC = window.rootViewController;
    NSAssert(rootVC, @"no root vc found");
    NSAssert([[self.objectsPath objectAtIndex:0] isEqualToString:@"self.window.rootViewController"], @"no self.window.rootViewController found! ");
    NSMutableArray * collected = [NSMutableArray array];
    for (NSString * s in self.objectsPath) {
        NSLog(@"s: %@",s);
        if ( [s isEqualToString:@"self.window.rootViewController"] ){
            [collected addObject:rootVC];
            continue;
        }
        
        if ([s hasSuffix:@"]"]) {
            NSString * pattern = @"^([a-zA-Z]+)\\[([0-9]+)\\]$";
            NSError * err = nil;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
            NSAssert(! err, @"regex error");
            NSRange range = NSMakeRange(0, s.length);
            NSString * childrenKey = [regex stringByReplacingMatchesInString:s
                                                            options:0
                                                              range:range
                                                       withTemplate:@"$1"];
    
            
            NSString * childrenStringIndex = [regex stringByReplacingMatchesInString:s
                                                            options:0
                                                              range:range
                                                       withTemplate:@"$2"];
            UIViewController * vc = collected.lastObject;
            NSArray * children = [vc valueForKey:childrenKey];
            UIViewController * childVC = [children objectAtIndex:childrenStringIndex.integerValue];
            NSAssert(childVC, @"no childVC");
            [collected addObject:childVC];
            
//            NSLog(@"ggg: %@ , %d", childrenKey ,childrenStringIndex.integerValue);
        } else {
            NSAssert(NO, @"NOOOO ! ");
        }
        
    }
    return collected.lastObject;
}

@end
