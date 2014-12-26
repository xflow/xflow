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
#import "XFAConstants.h"
#import "MTMethodArgumentValue.h"
#import "TXAssertion.h"
#import "XFAInvocationAOP.h"


static NSMutableDictionary * methodsMap;
static NSMutableDictionary * classMethodNamesDic;


@interface MTMethod () {

}

@end

@implementation MTMethod
- (id)init
{
    self = [super init];
    if (self) {
        self.methodArguments = [NSArray new];
    }
    return self;
}

-(NSString*)description{
    NSObject *obj = (NSObject*)self.classTypeInstance;
    NSString *className = NSStringFromClass(obj.class);
    return [NSString stringWithFormat:@"signature:%@, typeEncoding:%@, returnType:%@,class: %@, isMonitored:%d", self.signature,self.methodTypeEncoding,self.methodReturnType, className , self.isMonitored ];
}

-(BOOL)isVoid{
    BOOL iv = [self.methodReturnType isEqualToString:@"v"];
    return iv;
}


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
    BOOL iv = [self.methodTypeEncoding isEqualToString:@"v16@0:8"];
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
    self.methodArguments = [self.methodArguments arrayByAddingObject:arg];
}

-(BOOL)isApplicable{
    // object is in context
    return @TRUE.boolValue;
}


-(void)applyTo:(NSObject*)obj{
    [MTMethod applyMethod:self toObject:obj];
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


+(void*)applyMethod:(MTMethod*)method toObject:(NSObject*)obj{
    
    SEL sel = NSSelectorFromString(method.methodName);
    BOOL respondsToSelector = [obj respondsToSelector:sel];
    NSString * errorMsg = [NSString stringWithFormat:@"%@ instance doesn't respond to:%@",NSStringFromClass(obj.class ),method.methodName];
    NSAssert(respondsToSelector, errorMsg);
    
    if( method.isVoidWithTwoObjects ){
        MTMethodArgument * arg0 = [method.methodArguments objectAtIndex:0];
        MTMethodArgument * arg1 = [method.methodArguments objectAtIndex:1];
        
        NSValue * arg0Value = arg0.argumentValue;
        NSObject * argObj0 = arg0Value.nonretainedObjectValue;
        
        NSValue * arg1Value = arg1.argumentValue;
        NSObject * argObj1 = arg1Value.nonretainedObjectValue;
        
        [obj performSelector:sel
                  withObject:argObj0
                  withObject:argObj1];
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

/*
+(MTMethod *)methodWithTypeEncoding:(NSString*)typeEncoding{
    MTMethod * method = MTMethod.new;
    method.methodTypeEncoding = typeEncoding;
    method.methodReturnType = @"v";
    method.methodName = @"actionButton2:event:";
    
    return method;
}*/

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

/*
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"methodName"          : @"methodName",
             @"methodReturnType"    : @"returnType",
             @"methodTypeEncoding"  : @"typeEncoding",
             @"isMonitored"         : @"isMonitored",
             @"methodArguments"     : @"methodArguments",
             @"isUserDefined"       : @"isUserDefined",
             };
}*/


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


-(BOOL)isMonitored{
    return self.isInterceptable;
}

-(SEL)selector{
    NSAssert(self.signature, @"no signature found");
    return NSSelectorFromString(self.signature);
}



@end


