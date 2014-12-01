//
//  MTCrawler.h
//  Contexter
//
//  Created by Mohammed Tillawy on 11/6/13.
//  Copyright (c) 2013 Mohammed Tillawy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFACrawler : NSObject

//-(void)crawl;

+(NSString *)childrenKeyForObject:(UIViewController*)obj;

-(void)childControllers:(UIViewController *)viewController
                  level:(NSInteger)level
                  andDo:(void (^)(NSObject *obj))block;

@end