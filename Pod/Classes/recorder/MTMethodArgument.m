//
//  MTMethodArgument.m
//  AutoSwizzler
//
//  Created by Mohammed Tillawy on 10/5/13.
//  Copyright (c) 2013 Mohammed Tillawy. All rights reserved.
//
//   https://developer.apple.com/library/mac/documentation/cocoa/conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html


#import "MTMethodArgument.h"
#import "MTMethodArgumentValue.h"
#import "XFAViewControllerState.h"

@implementation MTMethodArgument

+(MTMethodArgument*)argumentForType:(NSString*)type{
//    NSLog(@" • argumentForType:%@",type);
    MTMethodArgument* arg = MTMethodArgument.new;
    arg.stringType = type;
    return arg;
}

-(void)setStringType:(NSString *)stringType
{
//    MTMethodArgumentType type = [MTMethodArgument argumentTypeForStringType:stringType];
//    self.argumentType = type;
    _stringType = stringType;
}

/* to be done later, not done on server */

+(MTMethodArgumentType)argumentTypeForStringType:(NSString *)stringType
{
    MTMethodArgumentType type = MTMethodArgumentTypeUnknownType;
    if ([stringType  isEqualToString:@"c"]){
        type = MTMethodArgumentTypeChar;
        
    } else if ([stringType  isEqualToString:@"i"]){
        type = MTMethodArgumentTypeInt;
        
    } else if ([stringType  isEqualToString:@"s"]){
        type = MTMethodArgumentTypeShort;
        
    } else if ([stringType  isEqualToString:@"l"]){
        type = MTMethodArgumentTypeLong;
        
    } else if ([stringType  isEqualToString:@"q"]){
        type = MTMethodArgumentTypeLongLong;
        
    } else if ([stringType  isEqualToString:@"C"]){
        type = MTMethodArgumentTypeUnsignedChar;
        
    } else if ([stringType  isEqualToString:@"I"]){
        type = MTMethodArgumentTypeUnsignedInt;
        
    } else if ([stringType  isEqualToString:@"S"]){
        type = MTMethodArgumentTypeUnsignedShort;
        
    } else if ([stringType  isEqualToString:@"L"]){
        type = MTMethodArgumentTypeUnsignedLong;
        
    } else if ([stringType  isEqualToString:@"Q"]){
        type = MTMethodArgumentTypeUnsignedLongLong;
        
    } else if ([stringType  isEqualToString:@"f"]){
        type = MTMethodArgumentTypeFloat;
        
    } else if ([stringType  isEqualToString:@"d"]){
        type = MTMethodArgumentTypeDouble;
        
    } else if ([stringType  isEqualToString:@"B"]){
        type = MTMethodArgumentTypeCppBool;
        
    } else if ([stringType  isEqualToString:@"v"]){
        type = MTMethodArgumentTypeVoid;
        
    } else if ([stringType  isEqualToString:@"*"]){
        type = MTMethodArgumentTypeCharacterString;
        
    } else if ([stringType  isEqualToString:@"@"]){
        type = MTMethodArgumentTypeObject;
        
    } else if ([stringType  isEqualToString:@"#"]){
        type = MTMethodArgumentTypeClassObject;
        
    } else if ([stringType  isEqualToString:@":"]){
        type = MTMethodArgumentTypeMethodSelector;
        
    } else if ([stringType  hasPrefix:@"["]){
        type = MTMethodArgumentTypeArray;
        
    } else if ([stringType  hasPrefix:@"{"]){
        type = MTMethodArgumentTypeStructure;
//        {name=type...}
        
    } else if ([stringType  hasPrefix:@"("]){
        type = MTMethodArgumentTypeUnion;
//        (name=type...)
        
    } else if ([stringType  hasPrefix:@"b"]){
        type = MTMethodArgumentTypeBitFieldOfNumBits;
//#TBD capture num of bits
//        bnum MTMethodArgumentTypeBitFieldOfNumBits;
        
    } else if ([stringType  hasPrefix:@"^"]){
        type = MTMethodArgumentTypePointerToType;
//        #TBD capture the type
//        ^type
        
    } else if ([stringType  isEqualToString:@"?"]) {
        type = MTMethodArgumentTypeUnknownType;
        
    } else if ([stringType  isEqualToString:@"@?"]) {
        type = MTMethodArgumentTypeUnknownType;
        
    } else {
        NSString *failMsg = [NSString stringWithFormat:@"unrecognized: %@",stringType];
//        NSLog(@"%@ %@",self,self.argumentName);
        NSAssert(FALSE, failMsg );
    }

    return type;
}


-(NSString*)description{
    return [NSString stringWithFormat:@"Argument type :%@ %d" ,
            self.stringType,
            self.argumentType];
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
//             @"argumentName" : @"argumentName",
//             @"variableName" : @"variableName",
//             @"stringType"   : @"stringType",
//             @"isMonitored"  : @"isMonitored",
//             @"objcType"     : @"objcType",
//             @"argumentValue" : @"argumentValue",
             };
}




+ (NSValueTransformer *)argumentValueJSONTransformer {
 
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary * dic) {

        NSError  * error = nil;
        MTMethodArgumentValue * argValue = [MTLJSONAdapter modelOfClass:MTMethodArgumentValue.class fromJSONDictionary:dic error:&error];
        NSAssert(! error, @"argumentValueJSONTransformer ForwardBlock");
        return argValue;
        
    } reverseBlock:^(NSValue * obj) {
        
        /*
         @"value"           : @"value",
         @"objcType"        : @"objcType",
         @"argumentType"    : @"argumentType",
         @"isNil"           : @"isNil",
         @"objectsPath"     : @"objectsPath",
         @"classesPath"     : @"classesPath",
         */
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:NSStringFromClass(obj.class) forKey:@"objcType"];
        [dic setValue:[NSString stringWithFormat:@"%d", obj.hash] forKey:@"objHash"];
        [dic setValue:@(obj == nil) forKey:@"isNil"];

        if (! obj) {
            [dic setObject:@"null" forKey:@"value"];
        } else if ([obj isKindOfClass:[UIViewController class]]) {
            XFAViewControllerState * vcState = [XFAViewControllerState new];
            UIViewController * vc = (UIViewController*)obj;
            [dic setObject:[vcState viewControllerClassesPathToWindow:vc] forKey:@"classesPath"];
            [dic setObject:[vcState viewControllerObjectsPathToWindow:vc] forKey:@"objectsPath"];
            [dic setObject:@"UIViewController" forKey:@"argumentType"];
        } else if ([obj isKindOfClass:[UIView class]]) {
            [dic setObject:@"UIView" forKey:@"argumentType"];
        } else if ([obj isKindOfClass:[NSObject class]]) {
            [dic setObject:@"NSObject" forKey:@"argumentType"];
            [dic setObject:[NSString stringWithFormat:@"%@",obj] forKey:@"value"];
        } else {
            [dic setObject:[NSString stringWithFormat:@"%@",obj] forKey:@"value"];
        }
        
        return dic;
    }];
    

}






@end
