//
//  XFAInvocationAOP.m
//  Pods
//
//  Created by Mohammed Tillawy on 7/18/14.
//
//

#import "XFAInvocationAOP.h"
#import <Aspects/Aspects.h>
#import "MTMethod.h"
#import "MTVcMethodInvocation.h"
#import "XFAConstants.h"

@implementation XFAInvocationAOP



 NSMutableArray * stackArray;
 NSMutableDictionary * stackInvocationsDictionary;


+(NSMutableDictionary*)stackInvocations{
    if (! stackInvocationsDictionary) {
        stackInvocationsDictionary = NSMutableDictionary.new;
    }
    return stackInvocationsDictionary;
}

+(NSMutableArray*)stack{
    if (! stackArray) {
        stackArray = NSMutableArray.new;
    }
    return stackArray;
}

+(void)pushIntoStackInvocation:(MTMethodInvocation*)invo withKey:(NSString*)k{
    invo.invocationIndexWithStack = [XFAInvocationAOP stack].count;
    [[XFAInvocationAOP stack] addObject:invo];
    
    if (! [[XFAInvocationAOP stackInvocations] objectForKey:k] ) {
        [[XFAInvocationAOP stackInvocations] setObject:[NSMutableArray array] forKey:k];
    }
    NSMutableArray * arr = [[XFAInvocationAOP stackInvocations] objectForKey:k];
    [arr addObject:invo];
    
}

+(void)popFromStackInvocation:(MTMethodInvocation*)invo withKey:(NSString*)k{
    [[XFAInvocationAOP stack] removeObject:invo];
    NSMutableArray * arr = [[XFAInvocationAOP stackInvocations] objectForKey:k];
    NSAssert(arr, @"does not exist");
    NSAssert([arr indexOfObject:invo] != NSNotFound, @"invo not found");
    [arr removeObject:invo];
    if ([XFAInvocationAOP stack].count == 0) {
        [[XFAInvocationAOP stack] removeAllObjects];
        stackArray = nil;
        [[XFAInvocationAOP stackInvocations]removeAllObjects];
        stackInvocationsDictionary = nil;
    }
}


+(id<AspectToken>)invoAopPre:(NSObject *)obj method:(MTMethod*)method{
    
    NSError * errorAspectHook = nil;
    
    id<AspectToken> token = [obj aspect_hookSelector:method.selector withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
        MTVcMethodInvocation * mvcInvo = MTVcMethodInvocation.new;
        mvcInvo.invocationTarget = (UIViewController*)obj;
        mvcInvo.method = method;
        
        NSString * k = NSStringFromSelector([[aspectInfo originalInvocation] selector]);
        NSAssert(k, @"can't generate key for selector");
        [XFAInvocationAOP pushIntoStackInvocation:mvcInvo withKey:k];
        NSAssert(mvcInvo, @"no obj");
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_METHOD_PRE_INVOCATION object:mvcInvo userInfo:nil];
        
    } error:&errorAspectHook];
    NSAssert(! errorAspectHook , @"errorAspectHook AspectPositionBefore:%@",errorAspectHook);
    return token;
}

+(id<AspectToken>)invoAopPost:(NSObject *)obj method:(MTMethod*)method{
    NSError * errorAspectHook = nil;
    id<AspectToken> token = [obj aspect_hookSelector:method.selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        
        NSString * k = NSStringFromSelector([[aspectInfo originalInvocation] selector]);
        NSArray * arr = [[XFAInvocationAOP stackInvocations]objectForKey:k];
        MTVcMethodInvocation * mvcInvo = [arr firstObject];
        
        NSAssert(mvcInvo, @"invocation not found %@",k);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_METHOD_POST_INVOCATION object:mvcInvo userInfo:nil];
        [XFAInvocationAOP popFromStackInvocation:mvcInvo withKey:k];
        
    } error:&errorAspectHook];
    NSAssert(! errorAspectHook , @"errorAspectHook AspectPositionAfter:%@",errorAspectHook);
    return token;
}


@end
