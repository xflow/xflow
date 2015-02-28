//
//  MTMethodArgument.h
//  AutoSwizzler
//
//  Created by Mohammed Tillawy on 10/5/13.
//  Copyright (c) 2013 Mohammed Tillawy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    MTMethodArgumentTypeChar = 0,
    MTMethodArgumentTypeInt = 1,
    MTMethodArgumentTypeShort = 2,
    MTMethodArgumentTypeLong = 3,
    MTMethodArgumentTypeLongLong = 4,
    MTMethodArgumentTypeUnsignedChar = 5,
    MTMethodArgumentTypeUnsignedInt = 6,
    MTMethodArgumentTypeUnsignedShort = 7,
    MTMethodArgumentTypeUnsignedLong = 8,
    MTMethodArgumentTypeUnsignedLongLong = 9,
    MTMethodArgumentTypeFloat = 10,
    MTMethodArgumentTypeDouble = 11,
    MTMethodArgumentTypeCppBool = 12,
    MTMethodArgumentTypeVoid = 13,
    MTMethodArgumentTypeCharacterString = 14,
    MTMethodArgumentTypeObject = 15,
    MTMethodArgumentTypeClassObject ,
    MTMethodArgumentTypeMethodSelector ,
    MTMethodArgumentTypeArray,
    MTMethodArgumentTypeStructure,
    MTMethodArgumentTypeUnion,
    MTMethodArgumentTypeBitFieldOfNumBits,
    MTMethodArgumentTypePointerToType,
    MTMethodArgumentTypeUnknownType
} MTMethodArgumentType;


#import <Mantle/Mantle.h>

@interface XFAMethodArgument : MTLModel <MTLJSONSerializing>

+(XFAMethodArgument*)argumentForType:(NSString*)type;

@property(nonatomic,assign) MTMethodArgumentType argumentType;
@property(nonatomic,strong) NSString *stringType;
@property(nonatomic,assign) NSInteger index;


@property(nonatomic,strong) NSString * argumentName;
@property(nonatomic,strong) NSString * variableName;
@property(nonatomic,strong) NSValue * argumentValue;
@property(nonatomic,strong) NSString * objcType;

@property(nonatomic,assign) BOOL isMonitored;

@end
