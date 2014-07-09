//
//  MethodsList.h
//  AutoSwizzler
//
//  Created by Mohammed Tillawy on 10/3/13.
//  Copyright (c) 2013 Mohammed Tillawy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTMethodsList : NSObject

-(void)scan:(NSObject*)obj;

-(NSMutableArray*)methods:(NSObject*)obj;

@end
