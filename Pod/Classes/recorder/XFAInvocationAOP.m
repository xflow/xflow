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

@interface XFAInvocationAOP(){

}

@property(nonatomic,strong) NSMutableArray * stackArray;
@property(nonatomic,strong) NSMutableArray * sequenceArray;
@property(nonatomic,strong) NSMutableDictionary * stackInvocationsDictionary;
@property(nonatomic,strong) NSMutableArray * aspectTokens;

@end

@implementation XFAInvocationAOP

- (instancetype)init
{
    self = [super init];
    if (self) {
        _stackInvocationsDictionary = NSMutableDictionary.new;
        _stackArray = NSMutableArray.new;
        _aspectTokens = NSMutableArray.new;
        _sequenceArray = NSMutableArray.new;
    }
    return self;
}


-(void)pushIntoStackInvocation:(MTMethodInvocation*)invo withKey:(NSString*)k{
    if (self.stackArray.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_SEQUENCE_STARTED object:nil userInfo:nil];
    }
    invo.invocationIndexWithStack = self.stackArray.count;
    [self.stackArray addObject:invo];
    if (! [self.stackInvocationsDictionary objectForKey:k] ) {
        [self.stackInvocationsDictionary setObject:[NSMutableArray array] forKey:k];
    }
    NSMutableArray * arr = [self.stackInvocationsDictionary objectForKey:k];
    [arr addObject:invo];
    
}

-(void)popFromStackInvocation:(MTMethodInvocation*)invo withKey:(NSString*)k{
    [self.stackArray removeObject:invo];
    NSMutableArray * arr = [self.stackInvocationsDictionary objectForKey:k];
    NSAssert(arr, @"does not exist");
    NSAssert([arr indexOfObject:invo] != NSNotFound, @"invo not found");
    [arr removeObject:invo];
    [self.sequenceArray addObject:invo];
    if (self.stackArray.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_SEQUENCE_ENDED object:self.sequenceArray userInfo:nil];
        [self.sequenceArray removeAllObjects];
    }
}


-(id<AspectToken>)invoAopPre:(NSObject *)obj method:(MTMethod*)method{
    
    NSError * errorAspectHook = nil;
    
    id<AspectToken> token = [obj aspect_hookSelector:method.selector withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
        MTVcMethodInvocation * mvcInvo = [MTVcMethodInvocation new];
        mvcInvo.invocationTarget = (UIViewController*)obj;
        mvcInvo.method = method;
        mvcInvo.status = MTVcMethodInvocationStatusPre;
        [mvcInvo saveVcStateBefore];
        
        NSString * k = NSStringFromSelector([[aspectInfo originalInvocation] selector]);
        NSAssert(k, @"can't generate key for selector");
        [self pushIntoStackInvocation:mvcInvo withKey:k];
        NSAssert(mvcInvo, @"no obj");
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_METHOD_PRE_INVOCATION object:mvcInvo userInfo:nil];
        
    } error:&errorAspectHook];
    NSAssert(! errorAspectHook , @"errorAspectHook AspectPositionBefore:%@",errorAspectHook);
    [self.aspectTokens addObject:token];
    return token;
}

-(id<AspectToken>)invoAopPost:(NSObject *)obj method:(MTMethod*)method{
    NSError * errorAspectHook = nil;
    id<AspectToken> token = [obj aspect_hookSelector:method.selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        
        NSString * k = NSStringFromSelector([[aspectInfo originalInvocation] selector]);
        NSArray * arr = [self.stackInvocationsDictionary objectForKey:k];
        MTVcMethodInvocation * mvcInvo = [arr firstObject];
        mvcInvo.method = method;
        mvcInvo.status = MTVcMethodInvocationStatusPost;
        [mvcInvo saveVcStateAfter];
        NSAssert(mvcInvo, @"invocation not found %@",k);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_METHOD_POST_INVOCATION object:mvcInvo userInfo:nil];
        [self popFromStackInvocation:mvcInvo withKey:k];
        
    } error:&errorAspectHook];
    NSAssert(! errorAspectHook , @"errorAspectHook AspectPositionAfter:%@",errorAspectHook);
    [self.aspectTokens addObject:token];
    return token;
}


-(void)removeAllHooks{
    for (id<AspectToken>aspectToken in self.aspectTokens) {
        BOOL b = [aspectToken remove];
//        NSAssert(b, @"token not removed");
    }
}

- (void)dealloc
{
    NSLog(@"[XFAInvocationAOP dealloc]");
    [self removeAllHooks];
}

@end
