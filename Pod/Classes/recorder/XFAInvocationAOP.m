//
//  XFAInvocationAOP.m
//  Pods
//
//  Created by Mohammed Tillawy on 7/18/14.
//
//

#import "XFAInvocationAOP.h"
#import <Aspects/Aspects.h>
#import "XFAMethod.h"
#import "XFAVCPropertySetterMethod.h"
#import "XFAVcMethodInvocation.h"
#import "XFAConstants.h"
#import "XFAVCProperty.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "XFAVcMethodInvocation.h"
#import "MTVcSetterMethodInvocation.h"

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


-(void)pushIntoStackInvocation:(XFAMethodInvocation*)invo withKey:(NSString*)k{
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

-(void)popFromStackInvocation:(XFAMethodInvocation*)invo withKey:(NSString*)k{
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


-(id<AspectToken>)invoAopPre:(NSObject *)obj method:(XFAMethod*)method{
    
    NSError * errorAspectHook = nil;
    
    id<AspectToken> token = [obj aspect_hookSelector:method.selector withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
        XFAVcMethodInvocation * mvcInvo = [XFAVcMethodInvocation new];
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

-(id<AspectToken>)invoAopPost:(NSObject *)obj method:(XFAMethod*)method{
    NSError * errorAspectHook = nil;
    id<AspectToken> token = [obj aspect_hookSelector:method.selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        
        NSString * k = NSStringFromSelector([[aspectInfo originalInvocation] selector]);
        NSArray * arr = [self.stackInvocationsDictionary objectForKey:k];
        XFAVcMethodInvocation * mvcInvo = [arr firstObject];
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

-(void)observeVC:(UIViewController *)vc property:(XFAVCProperty*)property
{
    
    __weak id target_ = (vc);
    RACSignal *mySignal = [target_ rac_valuesAndChangesForKeyPath:property.propertyName
                                                          options:NSKeyValueObservingOptionPrior
                                                         observer:self];
    [mySignal subscribeNext:^(RACTuple * x){
        NSLog(@"x: %@",x);
//        NSLog(@"x: %@",x.first);
        NSDictionary * dic = x.second;
        NSLog(@"kind: %@",dic[@"kind"]);
        NSLog(@"notificationIsPrior: %@",dic[@"notificationIsPrior"]);
//        NSLog(@"x: %@",x.third);
//        NSLog(@"x: %@",x[@"kind"]);
        if ([x.first isKindOfClass:[UIViewController class]]) {

//            UITabBarController * tvc = target_;
//            NSLog(@"selectedViewController: %@",tvc.selectedViewController);
        
//            UIViewController * aVC = x.first;
//            NSDictionary * dicState = [MTVcMethodInvocation dicStateOfViewController:aVC];
            
            
            MTVcSetterMethodInvocation * invo = nil;

//            method.signature = @"";
            NSString * k = [NSString stringWithFormat:@"set %@",property.propertyName];
            
            if (dic[@"notificationIsPrior"]) {
                invo = [MTVcSetterMethodInvocation new];
                invo.status = MTVcMethodInvocationStatusPre;
                XFAVCPropertySetterMethod * method = [XFAVCPropertySetterMethod new];
                invo.property = property;
//                invo.propertyValue = x.first;
                invo.method = method;
                invo.invocationTarget = target_;
                [invo saveVcStateBefore];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_METHOD_PRE_INVOCATION object:invo userInfo:nil];
                NSAssert(k, @"can't generate key for selector");
                [self pushIntoStackInvocation:invo withKey:k];
            } else {
                NSArray * arr = [self.stackInvocationsDictionary objectForKey:k];
                invo = [arr firstObject];
                NSAssert(invo, @"invo not found in stack");
                invo.status = MTVcMethodInvocationStatusPost;
                [invo saveVcStateAfter];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_METHOD_POST_INVOCATION object:invo userInfo:nil];
                [self popFromStackInvocation:invo withKey:k];
            }
        }
//        NSLog(@"%@",x);
        NSLog(@"changed .....");
    }];
    
}

- (void)dealloc
{
    NSLog(@"[XFAInvocationAOP dealloc]");
    [self removeAllHooks];
}

@end
