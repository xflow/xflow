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
#import "TXViewControllerState.h"

@implementation MTMethodArgument

+(MTMethodArgument*)argumentForType:(NSString*)type{
//    NSLog(@" • argumentForType:%@",type);
    MTMethodArgument* arg = MTMethodArgument.new;
    arg.stringType = type;
    return arg;
}

-(void)setStringType:(NSString *)stringType{
    MTMethodArgument * arg = self;
    if ([stringType  isEqualToString:@"c"]){
        arg.type = MTMethodArgumentTypeChar;
        
    } else if ([stringType  isEqualToString:@"i"]){
        arg.type = MTMethodArgumentTypeInt;
        
    } else if ([stringType  isEqualToString:@"s"]){
        arg.type = MTMethodArgumentTypeShort;
        
    } else if ([stringType  isEqualToString:@"l"]){
        arg.type = MTMethodArgumentTypeLong;
        
    } else if ([stringType  isEqualToString:@"q"]){
        arg.type = MTMethodArgumentTypeLongLong;
        
    } else if ([stringType  isEqualToString:@"C"]){
        arg.type = MTMethodArgumentTypeUnsignedChar;
        
    } else if ([stringType  isEqualToString:@"I"]){
        arg.type = MTMethodArgumentTypeUnsignedInt;
        
    } else if ([stringType  isEqualToString:@"S"]){
        arg.type = MTMethodArgumentTypeUnsignedShort;
        
    } else if ([stringType  isEqualToString:@"L"]){
        arg.type = MTMethodArgumentTypeUnsignedLong;
        
    } else if ([stringType  isEqualToString:@"Q"]){
        arg.type = MTMethodArgumentTypeUnsignedLongLong;
        
    } else if ([stringType  isEqualToString:@"f"]){
        arg.type = MTMethodArgumentTypeFloat;
        
    } else if ([stringType  isEqualToString:@"d"]){
        arg.type = MTMethodArgumentTypeDouble;
        
    } else if ([stringType  isEqualToString:@"B"]){
        arg.type = MTMethodArgumentTypeCppBool;
        
    } else if ([stringType  isEqualToString:@"v"]){
        arg.type = MTMethodArgumentTypeVoid;
        
    } else if ([stringType  isEqualToString:@"*"]){
        arg.type = MTMethodArgumentTypeCharacterString;
        
    } else if ([stringType  isEqualToString:@"@"]){
        arg.type = MTMethodArgumentTypeObject;
        
    } else if ([stringType  isEqualToString:@"#"]){
        arg.type = MTMethodArgumentTypeClassObject;
        
    } else if ([stringType  isEqualToString:@":"]){
        arg.type = MTMethodArgumentTypeMethodSelector;
        
    } else if ([stringType  hasPrefix:@"["]){
        arg.type = MTMethodArgumentTypeArray;
        
    } else if ([stringType  hasPrefix:@"{"]){
        arg.type = MTMethodArgumentTypeStructure;
//        {name=type...}
        
    } else if ([stringType  hasPrefix:@"("]){
        arg.type = MTMethodArgumentTypeUnion;
//        (name=type...)
        
    } else if ([stringType  hasPrefix:@"b"]){
        arg.type = MTMethodArgumentTypeBitFieldOfNumBits;
//#TBD capture num of bits
//        bnum MTMethodArgumentTypeBitFieldOfNumBits;
        
    } else if ([stringType  hasPrefix:@"^"]){
        arg.type = MTMethodArgumentTypePointerToType;
//        #TBD capture the type
//        ^type
        
    } else if ([stringType  isEqualToString:@"?"]) {
        arg.type = MTMethodArgumentTypeUnknownType;
        
    } else if ([stringType  isEqualToString:@"@?"]) {
        arg.type = MTMethodArgumentTypeUnknownType;
        
    } else {
        NSString *failMsg = [NSString stringWithFormat:@"unrecognized: %@",stringType];
        NSAssert(FALSE, failMsg );
    }
    _stringType = stringType;
}


-(NSString*)description{
    return [NSString stringWithFormat:@"Argument type :%@ %d" ,
            self.stringType,
            self.type];
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"argumentName" : @"argumentName",
             @"variableName" : @"variableName",
             @"stringType"   : @"stringType",
             @"isMonitored"  : @"isMonitored",
             @"objcType"     : @"objcType",
             @"argumentValue" : @"argumentValue",
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
            TXViewControllerState * vcState = TXViewControllerState.new;
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
