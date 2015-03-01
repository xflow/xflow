//
//  Method.m
//  AutoSwizzler
//
//  Created by Mohammed Tillawy on 10/3/13.
//  Copyright (c) 2013 Mohammed Tillawy. All rights reserved.
//

#import "XFAMethod.h"
#import "XFAMethodArgument.h"
#import <objc/runtime.h>
#import "Swizzle.h"
#import "XFAConstants.h"
#import "XFAMethodArgumentValue.h"
#import "TXAssertion.h"
#import "XFAInvocationAOP.h"


static NSMutableDictionary * methodsMap;
static NSMutableDictionary * classMethodNamesDic;


@interface XFAMethod () {

}

@end

@implementation XFAMethod
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
    return [NSString stringWithFormat:@"signature:%@, typeEncoding:%@, returnType:%@,class: %@", self.signature,self.encoding,self.returnObjcType, className ];
}

-(BOOL)isVoid{
    BOOL iv = [self.returnObjcType isEqualToString:@"v"];
    return iv;
}


-(BOOL)isObjectAndNoArguments{
    BOOL iv = [self.encoding isEqualToString:@"@8@0:4"];
    return iv;
}


-(BOOL)isObjectAndOneArgument{
    BOOL iv = [self.encoding isEqualToString:@"@12@0:4@8"];
    return iv;
}


-(BOOL)isObjectAndTwoArguments{
    BOOL iv = [self.encoding isEqualToString:@"@16@0:4@8@12"];
    return iv;
}


-(BOOL)isVoidAndNoArguments{
    BOOL iv = [self.encoding isEqualToString:@"v16@0:8"];
    return iv;
}

-(BOOL)isVoidWithOneObject{
    BOOL iv = [self.encoding isEqualToString:@"v12@0:4@8"];
    return iv;
}

-(BOOL)isVoidWithTwoObjects{
    BOOL iv = [self.encoding isEqualToString:@"v16@0:4@8@12"];
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
        if ([self.returnObjcType rangeOfString:s].location != NSNotFound) {
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
        if ([self.returnObjcType rangeOfString:s].location != NSNotFound) {
            isScalar = YES;
            break;
        }
    }
    
    
    BOOL hasScalar = NO;
    //    NSArray *arr = [NSArray arrayWithObjects:@"i",@"f", nil];
    for (NSString *s in arr)
    {
        if ([self.encoding rangeOfString:s].location != NSNotFound) {
            hasScalar = YES;
            break;
        }
    }
//    NSLog(@"methodTypeEncoding:%@, isVoid:%d, hasScalar:%d", self.methodTypeEncoding ,isVoid , hasScalar);
    return isScalar && hasScalar;
}



-(BOOL)isVoidWithScalars{
    
    BOOL isVoid = [self.encoding hasPrefix:@"v"];
    
    BOOL hasScalar=NO;
    NSArray *arr = [NSArray arrayWithObjects:@"i",@"f", nil];
    for (NSString *s in arr)
    {
        if ([self.encoding rangeOfString:s].location != NSNotFound) {
            hasScalar = YES;
            break;
        }
    }
//    NSLog(@"methodTypeEncoding:%@, isVoid:%d, hasScalar:%d", self.methodTypeEncoding ,isVoid , hasScalar);
    return isVoid && hasScalar;
}


-(BOOL)isObject {
    BOOL isObject = [self.encoding hasPrefix:@"@"];
    return isObject;
}

-(BOOL)isObjectWithScalars{
    
    BOOL hasScalar=NO;
    NSArray *arr = [NSArray arrayWithObjects:@"i",@"f", nil];
    for (NSString *s in arr)
    {
        if ([self.encoding rangeOfString:s].location != NSNotFound) {
            hasScalar = YES;
            break;
        }
    }
//    NSLog(@"methodTypeEncoding:%@, isVoid:%d, hasScalar:%d", self.methodTypeEncoding ,isVoid , hasScalar);
    return self.isObject && hasScalar;
}

-(void)addArgument:(NSString *)t atIndex:(NSInteger)index{
    XFAMethodArgument *arg = [XFAMethodArgument argumentForType:t];
    arg.index = index;
    self.methodArguments = [self.methodArguments arrayByAddingObject:arg];
}

-(BOOL)isApplicable{
    // object is in context
    return @TRUE.boolValue;
}


-(void)applyTo:(NSObject*)obj{
    [XFAMethod applyMethod:self toObject:obj];
}


+(void)setVcClassAsProcessed:(Class)vcClass{
    if (! [[XFAMethod classMethodNamesDic] valueForKey:NSStringFromClass(vcClass)] ) {
        [[XFAMethod classMethodNamesDic]setValue:[NSMutableArray array] forKey:NSStringFromClass(vcClass)];
    }
}

+(void)addMethodName:(NSString *)method forClassName:(NSString*)className {
    
    if (! [[XFAMethod classMethodNamesDic] valueForKey:className] ) {
        [[XFAMethod classMethodNamesDic]setValue:[NSMutableArray array] forKey:className];
    }
    
    NSMutableArray * array = [[XFAMethod classMethodNamesDic]valueForKey:className];
    
    [array addObject:method];

}

+(BOOL)isVcClassProcessed:(Class)vcClass{
    
    NSLog(@"%@: %@",vcClass  ,[[XFAMethod classMethodNamesDic] objectForKey:NSStringFromClass(vcClass)]);
    return [[XFAMethod classMethodNamesDic] objectForKey:NSStringFromClass(vcClass)] != nil;

}


+(void)swizzleMethod:(XFAMethod*)method ofObject:(NSObject*)obj{
    NSAssert(FALSE, @"calling old mehtod");
}


+(void*)applyMethod:(XFAMethod*)method toObject:(NSObject*)obj{
    
    SEL sel = NSSelectorFromString(method.signature);
    BOOL respondsToSelector = [obj respondsToSelector:sel];
    NSString * errorMsg = [NSString stringWithFormat:@"%@ instance doesn't respond to:%@",NSStringFromClass(obj.class ),method.methodName];
    NSAssert(respondsToSelector, errorMsg);
    
    if( method.isVoidWithTwoObjects ){
        XFAMethodArgument * arg0 = [method.methodArguments objectAtIndex:0];
        XFAMethodArgument * arg1 = [method.methodArguments objectAtIndex:1];
        
        NSValue * arg0Value = arg0.argumentValue;
        NSObject * argObj0 = arg0Value.nonretainedObjectValue;
        
        NSValue * arg1Value = arg1.argumentValue;
        NSObject * argObj1 = arg1Value.nonretainedObjectValue;
        
        [obj performSelector:sel
                  withObject:argObj0
                  withObject:argObj1];
    }
    
    if(  method.isVoidWithOneObject ){
        XFAMethodArgument * arg0 = [method.methodArguments objectAtIndex:0];
        NSValue * arg0Value = [arg0 loadArgumentMappedValueFromObject:obj];
//        NSObject * argObj = arg0Value.nonretainedObjectValue;
        [obj performSelector:sel withObject:arg0Value];
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
    NSAssert(self.encoding, @"no methodTypeEncoding to generate methodArgumentsCount");
    return 2;
}

-(void)runArgumentsAssertions{
    for (TXAssertion * as in self.methodArgumentsAssertions) {
        XFAMethodArgument * arg = [self.methodArguments objectAtIndex:as.assertionIndex];
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
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:XFAMethodArgument.class];
    
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

/*
-(BOOL)isMonitored{
    return self.isInterceptable;
}*/

-(SEL)selector{
    NSAssert(self.signature, @"no signature found");
    return NSSelectorFromString(self.signature);
}



@end


