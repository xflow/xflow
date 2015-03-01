//
//  XFAMethodArgumentMappedValue.h
//  Pods
//
//  Created by Mohammed Tillawy on 2/28/15.
//
//

#import <Mantle/Mantle.h>

typedef enum : NSUInteger {
    XFAMethodArgumentMappedValueTypeUnknown,
    XFAMethodArgumentMappedValueTypeVCUIViewProperty,
    XFAMethodArgumentMappedValueTypeVCSomethingProperty
} XFAMethodArgumentMappedValueType;

@interface XFAMethodArgumentMappedValue : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) XFAMethodArgumentMappedValueType mappedValueType;

+(XFAMethodArgumentMappedValue *)virtualArgumentValue:(NSValue*)value ofViewController:(UIViewController*)vc;

-(NSValue*)loadValueOfObject:(NSObject*)obj;

@end
