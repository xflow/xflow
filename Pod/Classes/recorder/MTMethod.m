//
//  Method.m
//  AutoSwizzler
//
//  Created by Mohammed Tillawy on 10/3/13.
//  Copyright (c) 2013 Mohammed Tillawy. All rights reserved.
//

#import "MTMethod.h"
#import "MTMethodArgument.h"
#import <objc/runtime.h>
#import "Swizzle.h"
#import "MTVcMethodInvocation.h"
#import "XFAConstants.h"
#import "MTMethodArgumentValue.h"
#import "TXAssertion.h"


static NSMutableDictionary * methodsMap;
static NSMutableDictionary * classMethodNamesDic;

static BOOL isFirstInVirtualStack;
static NSInteger sessionGroupIndex;
static NSInteger sessionGroupInvocationIndex;

@implementation MTMethod
- (id)init
{
    self = [super init];
    if (self) {
        self.methodArguments = NSMutableArray.new;
        isFirstInVirtualStack = TRUE;
        sessionGroupIndex = 0;
        sessionGroupInvocationIndex = 0;
    }
    return self;
}

-(NSString*)description{
    NSObject *obj = (NSObject*)self.classTypeInstance;
    NSString *className = NSStringFromClass(obj.class);
    return [NSString stringWithFormat:@"name:%@, typeEncoding:%@, returnType:%@,class: %@, isMonitored:%d", self.methodName,self.methodTypeEncoding,self.methodReturnType, className , self.isMonitored ];
}

-(BOOL)isVoid{
    BOOL iv = [self.methodReturnType isEqualToString:@"v"];
    return iv;
}

/*
 name:anObject, typeEncoding:@8@0:4, returnType:@",
 "name:anObjectWith:, typeEncoding:@12@0:4@8, returnType:@",
 "name:anObjectWithOne:two:, typeEncoding:@16@0:4@8@12, returnType:@",
 */

-(BOOL)isObjectAndNoArguments{
    BOOL iv = [self.methodTypeEncoding isEqualToString:@"@8@0:4"];
    return iv;
}


-(BOOL)isObjectAndOneArgument{
    BOOL iv = [self.methodTypeEncoding isEqualToString:@"@12@0:4@8"];
    return iv;
}


-(BOOL)isObjectAndTwoArguments{
    BOOL iv = [self.methodTypeEncoding isEqualToString:@"@16@0:4@8@12"];
    return iv;
}


-(BOOL)isVoidAndNoArguments{
    BOOL iv = [self.methodTypeEncoding isEqualToString:@"v8@0:4"];
    return iv;
}

-(BOOL)isVoidWithOneObject{
    BOOL iv = [self.methodTypeEncoding isEqualToString:@"v12@0:4@8"];
    return iv;
}

-(BOOL)isVoidWithTwoObjects{
    BOOL iv = [self.methodTypeEncoding isEqualToString:@"v16@0:4@8@12"];
    return iv;
}

-(BOOL)isObjectWithAnything{
    BOOL o = self.isObject && self.methodArguments.count > 4;
    return o;
}

-(BOOL)isScalar{
    
    BOOL isScalar = NO;
    
    NSArray *arr = [NSArray arrayWithObjects:@"i",@"f",@"c", nil];
    for (NSString *s in arr)
    {
        if ([self.methodReturnType rangeOfString:s].location != NSNotFound) {
            isScalar = YES;
            break;
        }
    }
    return isScalar;
}

-(BOOL)isScalarWithScalars{
    
    BOOL isScalar = NO;
    
    NSArray *arr = [NSArray arrayWithObjects:@"i",@"f", nil];
    for (NSString *s in arr)
    {
        if ([self.methodReturnType rangeOfString:s].location != NSNotFound) {
            isScalar = YES;
            break;
        }
    }
    
    
    BOOL hasScalar = NO;
    //    NSArray *arr = [NSArray arrayWithObjects:@"i",@"f", nil];
    for (NSString *s in arr)
    {
        if ([self.methodTypeEncoding rangeOfString:s].location != NSNotFound) {
            hasScalar = YES;
            break;
        }
    }
//    NSLog(@"methodTypeEncoding:%@, isVoid:%d, hasScalar:%d", self.methodTypeEncoding ,isVoid , hasScalar);
    return isScalar && hasScalar;
}



-(BOOL)isVoidWithScalars{
    
    BOOL isVoid = [self.methodTypeEncoding hasPrefix:@"v"];
    
    BOOL hasScalar=NO;
    NSArray *arr = [NSArray arrayWithObjects:@"i",@"f", nil];
    for (NSString *s in arr)
    {
        if ([self.methodTypeEncoding rangeOfString:s].location != NSNotFound) {
            hasScalar = YES;
            break;
        }
    }
//    NSLog(@"methodTypeEncoding:%@, isVoid:%d, hasScalar:%d", self.methodTypeEncoding ,isVoid , hasScalar);
    return isVoid && hasScalar;
}


-(BOOL)isObject {
    BOOL isObject = [self.methodTypeEncoding hasPrefix:@"@"];
    return isObject;
}

-(BOOL)isObjectWithScalars{
    
    BOOL hasScalar=NO;
    NSArray *arr = [NSArray arrayWithObjects:@"i",@"f", nil];
    for (NSString *s in arr)
    {
        if ([self.methodTypeEncoding rangeOfString:s].location != NSNotFound) {
            hasScalar = YES;
            break;
        }
    }
//    NSLog(@"methodTypeEncoding:%@, isVoid:%d, hasScalar:%d", self.methodTypeEncoding ,isVoid , hasScalar);
    return self.isObject && hasScalar;
}

-(void)addArgument:(NSString *)t atIndex:(NSInteger)index{
    MTMethodArgument *arg = [MTMethodArgument argumentForType:t];
    arg.index = index;
    [self.methodArguments addObject:arg];
}

-(BOOL)isApplicable{
    // object is in context
    return @TRUE.boolValue;
}


-(void)applyTo:(NSObject*)obj{
    [MTMethod applyMethod:self toObject:obj];
}

-(void)monitorForObject:(NSObject*)obj
{
    NSAssert([obj respondsToSelector:NSSelectorFromString(self.methodName)], @"%@ does not respond to: %@",obj.class, self.methodName);
    
    NSLog(@"[%@ %@] - monitorForObject", obj.class, self.methodName);
    
    SEL replacementSel = NSSelectorFromString(replacement(self.methodName));

    if ([obj respondsToSelector:replacementSel]) {
        NSLog(@"allready respondsToSelector  monitorForObject %@ %@",
              replacement( self.methodName ),
              [obj class]);
//        NSAssert(FALSE , @"calling twice [%@ %@]",obj.class,self.methodName);
//        return;
    }
    
    if ([[MTMethod methodsMap] valueForKeyPath:self.methodName]) {
//        NSAssert(FALSE , @"twice htiu");
//        return;
    }
    
    [MTMethod swizzleMethod:self forClass:obj.class];
    [MTMethod addMethodName:self.methodName forClassName:NSStringFromClass(obj.class)];
}

+(void)setVcClassAsProcessed:(Class)vcClass{
    if (! [[MTMethod classMethodNamesDic] valueForKey:NSStringFromClass(vcClass)] ) {
        [[MTMethod classMethodNamesDic]setValue:[NSMutableArray array] forKey:NSStringFromClass(vcClass)];
    }
}

+(void)addMethodName:(NSString *)method forClassName:(NSString*)className {
    
    if (! [[MTMethod classMethodNamesDic] valueForKey:className] ) {
        [[MTMethod classMethodNamesDic]setValue:[NSMutableArray array] forKey:className];
    }
    
    NSMutableArray * array = [[MTMethod classMethodNamesDic]valueForKey:className];
    
    [array addObject:method];

}

+(BOOL)isVcClassProcessed:(Class)vcClass{
    
    NSLog(@"%@: %@",vcClass  ,[[MTMethod classMethodNamesDic] objectForKey:NSStringFromClass(vcClass)]);
    return [[MTMethod classMethodNamesDic] objectForKey:NSStringFromClass(vcClass)] != nil;

}


+(void)swizzleMethod:(MTMethod*)method ofObject:(NSObject*)obj{
    NSAssert(FALSE, @"calling old mehtod");
}

+(void)swizzleMethod:(MTMethod*)method forClass:(Class)objClass{

    NSString * replacementMethodName = replacement(method.methodName);
    
    [[MTMethod methodsMap] setValue:method forKey:method.methodName];
    
   BOOL added = class_addMethod(objClass ,
                    NSSelectorFromString(replacementMethodName),
                    (IMP) invokeMethodWithInvoker ,
                    [method.methodTypeEncoding cStringUsingEncoding:NSUTF8StringEncoding]);
    
    NSAssert(added, @"class_addMethod FAILED for: %@ %@",replacementMethodName , objClass );
    
    SEL targetSelector2 = NSSelectorFromString(replacementMethodName);
    
    NSLog(@" • swizzleMethod:%@ for object:%@", method.methodName, objClass);
    
    Swizzle(objClass,
            NSSelectorFromString( method.methodName ),
            targetSelector2 );
    
}


+(void*)applyMethod:(MTMethod*)method toObject:(NSObject*)obj{
    
    SEL sel = NSSelectorFromString(method.methodName);
    BOOL respondsToSelector = [obj respondsToSelector:sel];
    NSString * errorMsg = [NSString stringWithFormat:@"%@ instance doesn't respond to:%@",NSStringFromClass(obj.class ),method.methodName];
    NSAssert(respondsToSelector, errorMsg);
    
    if( method.isVoidWithTwoObjects ){
        MTMethodArgument * arg0 = [method.methodArguments objectAtIndex:0];
        MTMethodArgument * arg1 = [method.methodArguments objectAtIndex:1];
        [obj performSelector:sel
                  withObject:arg0.argumentValue
                  withObject:arg1.argumentValue];
    }
    
    if(  method.isVoidWithOneObject ){
        MTMethodArgument * arg0 = [method.methodArguments objectAtIndex:0];
        NSValue * arg0Value = arg0.argumentValue;
        NSObject * argObj = arg0Value.nonretainedObjectValue;
        [obj performSelector:sel withObject:argObj];
    }
    
    if (method.isVoidAndNoArguments ) {
        [obj performSelector:sel];
    }
    
    /*   method.isObjectAndNoArguments ||
       method.isObjectAndOneArgument ||
       method.isObjectAndTwoArguments  ){
     
    }*/
    return nil;

}


+(MTMethod *)methodWithTypeEncoding:(NSString*)typeEncoding{
    MTMethod * method = MTMethod.new;
    method.methodTypeEncoding = typeEncoding;
    method.methodReturnType = @"v";
    method.methodName = @"actionButton2:event:";
    
    return method;
}

-(NSInteger)methodArgumentsCount{
    NSAssert(self.methodTypeEncoding, @"no methodTypeEncoding to generate methodArgumentsCount");
    return 2;
}

-(void)runArgumentsAssertions{
    for (TXAssertion * as in self.methodArgumentsAssertions) {
        MTMethodArgument * arg = [self.methodArguments objectAtIndex:as.assertionIndex];
        [as evaluate:arg.argumentValue];
    }
}


- (NSString *)replacementMethod:(NSString*)methodName
{
    return replacement(methodName);
}


NSString * replacement(NSString* methodName)
{
    NSString *replacementMethodName = [NSString stringWithFormat:@"FXA%@",methodName];
    return replacementMethodName;
}

+(NSMutableDictionary*)classMethodNamesDic{
    if (classMethodNamesDic == nil) {
        classMethodNamesDic = NSMutableDictionary.new;
    }
    return classMethodNamesDic;
}


+(NSMutableDictionary *)methodsMap {
    if ( methodsMap == nil ){
        methodsMap = NSMutableDictionary.new;
    }
    return methodsMap;
}

void * invokeMethodWithInvoker(id objId, SEL _cmd, ...)
{
    
    NSString * originalMethodName =  NSStringFromSelector(_cmd);
    
    NSLog(@"%@ %@", objId, originalMethodName);
    
    NSLog(@"invokeMethodWithInvoker method key:%@", originalMethodName);
    
    MTMethod * method = [methodsMap valueForKey:originalMethodName];

    NSString * assertMsg = [NSString stringWithFormat:@"no method found: %@", originalMethodName];
    
    NSCAssert(method, assertMsg);
    
    NSString * r = replacement(method.methodName);
    
    NSObject * obj = objId;
    
    NSCAssert(obj, @"invokeMethodWithInvoker obj is not");
    
    NSLog(@"newMethodWithInvoker :%@",NSStringFromSelector(_cmd));
    
    SEL replacementSel = NSSelectorFromString(r);
    
    NSMethodSignature * mySignature = [[obj class] instanceMethodSignatureForSelector:_cmd];
    
    NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:mySignature];
    
    [myInvocation setTarget:obj];
    
    [myInvocation setSelector:replacementSel];
    
//    NSLog(@"method.methodArguments:%@",method.methodArguments);
    
    MTVcMethodInvocation * methodInvocation = MTVcMethodInvocation.new;
    
    methodInvocation.method = method;
    NSCAssert([obj isKindOfClass:[UIViewController class]], @"obj is not a UIViewController");
    methodInvocation.invocationTarget = (UIViewController *)obj;
    [methodInvocation saveVcStateBefore];
    va_list args;
    // va_start needs it to know where to start processing the variable-arguments.
    va_start(args,_cmd);
    for (int i = 0; i < method.methodArguments.count ; i++) {

        MTMethodArgument * mArg = [method.methodArguments objectAtIndex:i];
        if (mArg.type == MTMethodArgumentTypeObject) {
            id val = va_arg(args,id);
            [myInvocation setArgument:&val atIndex:i+2];
            mArg.argumentValue = val;
        } else {
            int val = va_arg(args,int);
            [myInvocation setArgument:&val atIndex:i+2];
        }
        
    }
    
    va_end(args);


    NSUInteger returnLength = [[myInvocation methodSignature] methodReturnLength];
    
    NSLog(@"invokeMethodWithInvoker:%@ returnLength:%d",NSStringFromSelector(_cmd),returnLength);
    
    
    methodInvocation.isFirstInVirtualStack = isFirstInVirtualStack;
    
    if (isFirstInVirtualStack){
        NSLog(@"invokeMethodWithInvoker:%@, isFirst:%d", NSStringFromSelector(_cmd), isFirstInVirtualStack );
        isFirstInVirtualStack = FALSE;
        sessionGroupInvocationIndex = 0;
    } else {
        sessionGroupInvocationIndex++;
    }

    methodInvocation.sessionGroupIndex = sessionGroupIndex;
    methodInvocation.sessionGroupInvocationIndex = sessionGroupInvocationIndex;
    
    [myInvocation invoke];
    
    [method runArgumentsAssertions];
    [methodInvocation saveVcStateAfter];
    
    isFirstInVirtualStack = TRUE;
    sessionGroupIndex = 0;
    sessionGroupInvocationIndex = 0;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIF_METHOD_INVOCATION object:methodInvocation userInfo:nil];
    
    NSCAssert(method.methodReturnType, @"no method return type set");
    
    if (method.isVoid) {
        return nil;
    } else if (method.isScalar) {
        void * result = malloc(returnLength);
        [myInvocation getReturnValue:result];
        return result;
    } else if (method.isObject){
        __unsafe_unretained id result;
        [myInvocation getReturnValue:&result];
        return (__bridge void *)(result);
    } else {
        NSCAssert(FALSE, @"unknowssss");
    }
    

    return nil;
    
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"methodName"          : @"methodName",
             @"methodReturnType"    : @"returnType",
             @"methodTypeEncoding"  : @"typeEncoding",
             @"isMonitored"         : @"isMonitored",
             @"methodArguments"     : @"methodArguments",
             @"isUserDefined"       : @"isUserDefined",
             @"methodAssertions"    : @"methodAssertions",
             };
}


+ (NSValueTransformer *)methodArgumentsJSONTransformer {
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:MTMethodArgument.class];
    
}



+ (NSValueTransformer *)methodPreAssertionsJSONTransformer {
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:TXAssertion.class];
    
}

+ (NSValueTransformer *)methodPostAssertionsJSONTransformer {
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:TXAssertion.class];
    
}

+ (NSValueTransformer *)methodArgumentsAssertionsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:TXAssertion.class];
}







@end


