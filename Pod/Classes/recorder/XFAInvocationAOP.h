//
//  XFAInvocationAOP.h
//  Pods
//
//  Created by Mohammed Tillawy on 7/18/14.
//
//

#import <Foundation/Foundation.h>

@protocol AspectToken;
@class MTMethod;

@interface XFAInvocationAOP : NSObject

-(id<AspectToken>)invoAopPre:(NSObject *)obj method:(MTMethod*)method;
-(id<AspectToken>)invoAopPost:(NSObject *)obj method:(MTMethod*)method;
-(void)removeAllHooks;

@end
