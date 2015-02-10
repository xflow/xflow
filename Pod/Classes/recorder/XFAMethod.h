//
//  Method.h
//  AutoSwizzler
//
//  Created by Mohammed Tillawy on 10/3/13.
//  Copyright (c) 2013 Mohammed Tillawy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTClassTypeInstance;

#import <xflowparser/XFPObjcMethod.h>


@interface XFAMethod : XFPObjcMethod


@property(nonatomic,strong) NSString * methodReturnType;
@property(nonatomic,strong) NSString * methodTypeEncoding;
@property(nonatomic,strong) NSNumber * isUserDefined;
//@property(nonatomic,assign) BOOL isMonitored;
@property(nonatomic,strong) NSNumber * isChildVcEntryPoint;
@property(nonatomic,strong) NSNumber * childVcArgumentIndex;


@property (nonatomic,readonly) BOOL isVoid;
@property (nonatomic,readonly) BOOL isVoidAndNoArguments;
@property (nonatomic,readonly) BOOL isVoidWithOneObject;
@property (nonatomic,readonly) BOOL isVoidWithTwoObjects;
@property (nonatomic,readonly) BOOL isObjectAndNoArguments;
@property (nonatomic,readonly) BOOL isObjectAndOneArgument;
@property (nonatomic,readonly) BOOL isObjectAndTwoArguments;
@property (nonatomic,readonly) BOOL isVoidWithScalars;

@property (nonatomic,readonly) BOOL isScalarWithScalars;

@property (nonatomic,readonly) BOOL isScalar;
@property (nonatomic,readonly) BOOL isObject;

@property (nonatomic,readonly) BOOL isObjectWithAnything;

@property (nonatomic,readonly) BOOL isApplicable;

@property (nonatomic,readonly) SEL selector;


@property (nonatomic,strong) NSMutableArray * methodPreAssertions;
@property (nonatomic,strong) NSMutableArray * methodPostAssertions;
@property (nonatomic,strong) NSMutableArray * methodArgumentsAssertions;

-(void)addArgument:(NSString *)t atIndex:(NSInteger)index;

@property(nonatomic,strong) id classTypeInstance;

-(void)applyTo:(NSObject*)obj;

+(BOOL)isVcClassProcessed:(Class)vcClass;
+(void)setVcClassAsProcessed:(Class)vcClass;



//-(void)aopOn;
//-(void)aopOff;

@end
