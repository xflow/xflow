//
//  MTSwizzleManager.m
//  POC2
//
//  Created by Mohammed Tillawy on 1/12/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "MTSwizzleManager.h"
#import "MTMethodsList.h"
#import "XFAMethod.h"
#import "Swizzle.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "MTMethodArgument.h"
#import "XFAConstants.h"



@interface MTSwizzleManager(){

}

@property (nonatomic, strong) NSMutableDictionary * methodsMap;
// @{ originalName : ${MTMethod.new} }

@property (nonatomic, strong) NSMutableDictionary * methodsNamesMap;
// @{ originalName : replacementName }


@end




static MTSwizzleManager * globalSelf;

@implementation MTSwizzleManager


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (id)init
{
    self = [super init];
    if (self) {
        self.methodsNamesMap = [NSMutableDictionary new];
        self.methodsMap = [NSMutableDictionary new];
        globalSelf = self;
    }
    return self;
}


- (void)swizzleAllMethodsOfObject:(NSObject*)obj
{
    
    NSLog(@"swizzleObject:%@",obj.class);
    [self swizzleWithArgs:obj];
    [self swizzleVoidsWithScalars:obj];
    [self swizzleSalarWithScalars:obj];
    
    
}

-(XFAMethod*)methodForObject:(NSObject*)obj withName:(NSString*)name{
    NSLog(@"self.methodsMap:%@",globalSelf.methodsMap);
    XFAMethod * m = [self.methodsMap objectForKey:name];
    return m;
}

- (void)swizzleWithArgs:(NSObject*)obj
{

    MTMethodsList *ml = MTMethodsList.new;
    NSArray * arr = [ml methods:obj];
    NSLog(@"all methods:%@",arr);
    
    for (XFAMethod *m in arr) {
        if( m.isVoidWithTwoObjects  ||
           m.isVoidWithOneObject    ||
           m.isVoidAndNoArguments   ||
           m.isObjectAndNoArguments ||
           m.isObjectAndOneArgument ||
           m.isObjectAndTwoArguments  ){
            NSString *newMethodName = [NSString stringWithFormat:@"replacement%@",m.methodName];
            
            [self.methodsMap setValue:m
                               forKey:m.methodName];
            
            [self.methodsNamesMap setValue:newMethodName
                                    forKey:m.methodName];
            
            class_addMethod(obj.class ,
                            NSSelectorFromString(newMethodName),
                            (IMP) newMethodWithVarArgs ,
                            [m.methodTypeEncoding cStringUsingEncoding:NSUTF8StringEncoding]);
            
            SEL targetSelector2 = NSSelectorFromString(newMethodName);
            
            Swizzle(obj.class,
                    NSSelectorFromString( m.methodName ),
                    targetSelector2
                    );
        }
    }
    
}


- (void)swizzleVoidsWithScalars:(NSObject*)obj
{
    MTMethodsList *ml = [[MTMethodsList alloc] init];
    NSArray * arr = [ml methods:obj];
    NSLog(@"all methods:%@",arr);
    
    for (XFAMethod *m in arr) {
        if (m.isVoidWithScalars) {
            NSLog(@"    isVoidWithScalars: %@",m);
//            NSString *newMethodName = [NSString stringWithFormat:@"replacement%@",m.methodName];
            
            [self.methodsMap setValue:m forKey:m.methodName];
            
            NSString *replacementMethod = [self replacementMethod:m.methodName];
            
            class_addMethod(obj.class ,
                            NSSelectorFromString(replacementMethod),
                            (IMP) voidMethodWithInvoker ,
                            [m.methodTypeEncoding cStringUsingEncoding:NSUTF8StringEncoding]);
            
            SEL targetSelectorInvoker = NSSelectorFromString(replacementMethod);
            
            Swizzle(obj.class,
                    NSSelectorFromString( m.methodName ),
                    targetSelectorInvoker
                    );
        }
    }
}



id voidMethodWithInvoker(id objId, SEL _cmd, ...)
{
    
    XFAMethod *method =  methodForSelector(_cmd);
    
    NSString *r = replacementMethod(method.methodName);
    
    NSObject * obj = objId;
    
    Swizzle(obj.class, NSSelectorFromString( r ), _cmd );
    
//    NSLog(@"newMethodWithInvoker :%@",NSStringFromSelector(_cmd));
    
    NSMethodSignature * mySignature = [[obj class] instanceMethodSignatureForSelector:_cmd];
    
    NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:mySignature];
    
    [myInvocation setTarget:obj];
    
    [myInvocation setSelector:_cmd];
    
    NSInteger a = 10;
    
    int32_t arg = 123456;
    
    [myInvocation setArgument:&arg atIndex:2];
    
    [myInvocation setArgument:&a atIndex:2];
    
    NSUInteger returnLength = [[myInvocation methodSignature] methodReturnLength];
    
    NSLog(@"%@ returnLength:%d",NSStringFromSelector(_cmd),returnLength);
    //    id result = (__bridge id)((void *)CFBridgingRelease(malloc(returnLength)));
    
    
    [myInvocation invoke];
    
//    if (method.isScalarWithScalars) {
//        void* result = malloc(returnLength);
//        [myInvocation getReturnValue:result];
//    }
    
    Swizzle(obj.class, _cmd, NSSelectorFromString( r ) );
    
    return nil;
    
}


-(NSString*)replacementMethod:(NSString*)methodName
{
    return replacementMethod(methodName);
}


NSString* replacementMethod(NSString* methodName)
{
    NSString *replacementMethodName = [NSString stringWithFormat:@"replacement%@",methodName];
    return replacementMethodName;
}


-(void)swizzleSalarWithScalars:(NSObject*)obj
{
    MTMethodsList *ml = [[MTMethodsList alloc] init];
    NSArray * arr = [ml methods:obj];
    NSLog(@"all methods:%@",arr);
    
    for (XFAMethod *m in arr) {
        if ( m.isScalarWithScalars ||
            m.isObjectWithAnything
            ) {
            
            NSLog(@"• isScalarWithScalars: %@",m);
            
            [self.methodsMap setValue:m forKey:m.methodName];
            
            NSString *replacementMethod = [self replacementMethod:m.methodName];
            
            class_addMethod(obj.class ,
                            NSSelectorFromString(replacementMethod),
                            (IMP) scalarMethodWithInvoker ,
                            [m.methodTypeEncoding cStringUsingEncoding:NSUTF8StringEncoding]);
            
            SEL targetSelectorInvoker = NSSelectorFromString(replacementMethod);
            
            Swizzle(obj.class,
                    NSSelectorFromString( m.methodName ),
                    targetSelectorInvoker
                    );
        }
    }
}


void * scalarMethodWithInvoker(id objId, SEL _cmd, ...)
{
    
    XFAMethod *method =  methodForSelector(_cmd);
    
    NSString *r = replacementMethod(method.methodName);
    
    NSObject * obj = objId;
    
    Swizzle(obj.class, NSSelectorFromString( r ), _cmd );
    
//    NSLog(@"newMethodWithInvoker :%@",NSStringFromSelector(_cmd));
    
    NSMethodSignature * mySignature = [[obj class] instanceMethodSignatureForSelector:_cmd];
    
    NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:mySignature];
    
    [myInvocation setTarget:obj];
    
    [myInvocation setSelector:_cmd];
    
    NSLog(@"method.methodArguments:%@",method.methodArguments);
    va_list args;
    va_start(args,0); // try _cmd instead
    for (int i = 2; i < method.methodArguments.count ; i++) {
        MTMethodArgument *marg = [method.methodArguments objectAtIndex:i];
        NSLog(@"margs:%@",marg);
        if (marg.argumentType == MTMethodArgumentTypeObject) {
            id val = va_arg(args,id);
            [myInvocation setArgument:&val atIndex:i];
        } else {
            int val = va_arg(args,int);
            [myInvocation setArgument:&val atIndex:i];
            
        }
        
    }
    
    va_end(args);
    
    NSUInteger returnLength = [[myInvocation methodSignature] methodReturnLength];
    
    NSLog(@"scalarMethodWithInvoker:%@ returnLength:%d",NSStringFromSelector(_cmd),returnLength);
    
    [myInvocation invoke];
    
    Swizzle( obj.class, _cmd, NSSelectorFromString( r ) );
    
    
    if (method.isScalar) {
        void* result = malloc(returnLength);
        [myInvocation getReturnValue:result];
        return result;
        
    } else {
        __unsafe_unretained id result;
        [myInvocation getReturnValue:&result];
        return (__bridge void *)(result);
    }
    
    //    NSLog(@"%d",result);
    
    //    Swizzle( obj.class, _cmd, NSSelectorFromString( r ) );
    
    //    return result;
    
}


id callGetObject(NSObject *obj , NSString* originalMethod , NSObject* obj1, NSObject* obj2 )
{
    
//    NSLog(@"NOTIF_METHOD,notif:%@,object:%@",notif.object,notif.userInfo);
//    NSString *originalMethod = [notif.userInfo objectForKey:@"CALLED_METHOD"];
    
    NSString *replacementMethod = [globalSelf.methodsNamesMap objectForKey:originalMethod];
    
    Swizzle(obj.class,
            NSSelectorFromString( replacementMethod ),
            NSSelectorFromString( originalMethod )
            );
    
    SEL sel = NSSelectorFromString( originalMethod );
    
    id output = [obj performSelector:sel withObject:obj1 withObject:obj2];
    
    Swizzle(obj.class,
            NSSelectorFromString( originalMethod ),
            NSSelectorFromString( replacementMethod )
            );
    
    return output;
}




id newMethodWithVarArgs(id firstArg, SEL _cmd, ...)
{
    
    
    NSString *s =  NSStringFromSelector(_cmd);
    
//    MTMethod *method = [Sm.methodsMap valueForKey:s];
//    MTMethod *method = [[MTSwizzleManager sharedInstance].methodsMap valueForKey:s];
    
    XFAMethod * method = [globalSelf.methodsMap valueForKey:s];
    assert(method != nil);
    NSLog(@" • newMethodWithVarArgs %@ \n %@" ,NSStringFromSelector(_cmd) , method );
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_METHOD
                                                        object:method
                                                      userInfo:nil];
    
    if (method.isVoidAndNoArguments) {
        voidCallObject(firstArg, NSStringFromSelector(_cmd) ,nil,nil);
    }
    
    if (method.isObjectAndNoArguments) {
        return callGetObject(firstArg, NSStringFromSelector(_cmd) ,nil,nil);
    }
    
    
    if (method.isObjectAndOneArgument) {
        va_list args;
        va_start(args,_cmd);
        id val = va_arg(args,id);
        va_end(args);
        return callGetObject(firstArg,NSStringFromSelector(_cmd) ,val,nil);
    }
    
    if (method.isVoidWithOneObject) {
        va_list args;
        va_start(args,_cmd);
        id val = va_arg(args,id);
        va_end(args);
        voidCallObject(firstArg,NSStringFromSelector(_cmd) ,val,nil);
    }
    
    if (method.isObjectAndTwoArguments) {
        va_list args;
        va_start(args,_cmd);
        id val1 = va_arg(args,id);
        id val2 = va_arg(args,id);
        va_end(args);
        return callGetObject(firstArg,NSStringFromSelector(_cmd) ,val1,val2);
    }
    
    if (method.isVoidWithTwoObjects) {
        va_list args;
        va_start(args,_cmd);
        id val1 = va_arg(args,id);
        id val2 = va_arg(args,id);
        va_end(args);
        voidCallObject(firstArg,NSStringFromSelector(_cmd) ,val1,val2);
    }
    
    
    return nil;
    
}




XFAMethod* methodForSelector(SEL sel)
{
    
    NSString *s =  NSStringFromSelector(sel);
    
    XFAMethod *method = [globalSelf.methodsMap valueForKey:s];
    
    return method;
}


void voidCallObject(NSObject *obj , NSString* originalMethod , NSObject* obj1, NSObject* obj2 )
{
    
    //    NSLog(@"NOTIF_METHOD,notif:%@,object:%@",notif.object,notif.userInfo);
    //    NSString *originalMethod = [notif.userInfo objectForKey:@"CALLED_METHOD"];
    
    NSString *replacementMethod = [globalSelf.methodsNamesMap objectForKey:originalMethod];
    
    Swizzle(obj.class,
            NSSelectorFromString( replacementMethod ),
            NSSelectorFromString( originalMethod )
            );
    
    SEL sel = NSSelectorFromString( originalMethod );
    
    [obj performSelector:sel withObject:obj1 withObject:obj2];
    
    Swizzle(obj.class,
            NSSelectorFromString( originalMethod ),
            NSSelectorFromString( replacementMethod )
            );
    
}


@end



