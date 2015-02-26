//
//  MTVcMethodInvocation.m
//  POC2
//
//  Created by Mohammed Tillawy on 4/1/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAVcMethodInvocation.h"

#import "XFAViewControllerState.h"
#import "TXViewControllerPropertiesScanner.h"


@interface XFAVcMethodInvocation ()


@end

@implementation XFAVcMethodInvocation


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"method" : @"method",
             @"invocationIndexWithStack" : @"invocationIndexWithStack",
             };
}


+ (NSValueTransformer *)vcStateBeforeJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XFAViewControllerState class]];
}

+ (NSValueTransformer *)vcStateAfterJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XFAViewControllerState class]];
}


-(void)saveVcStateBefore
{
    NSAssert(self.invocationTarget, @"%s no invocation target",__PRETTY_FUNCTION__);
    self.vcStateBefore  = [XFAVcMethodInvocation vcStateForInvocationTarget:self.invocationTarget];
}

+(XFAViewControllerState*)vcStateForInvocationTarget:(UIViewController*)invocationTarget
{
    NSAssert(invocationTarget, @"%s no invocation target",__PRETTY_FUNCTION__);
    XFAViewControllerState * vcState = [XFAViewControllerState new];
    vcState.vcClassesPath = [XFAViewControllerState viewControllerClassesPathToWindow:invocationTarget];
    vcState.vcObjectsPath = [XFAViewControllerState viewControllerObjectsPathToWindow:invocationTarget];
    NSDictionary * vcProperties = [TXViewControllerPropertiesScanner propertiesOfVC:invocationTarget];;
    vcState.vcProperties = vcProperties;
    vcState.objHash = @( invocationTarget.hash );
    return vcState;
//    [XFAVcMethodInvocation dicStateOfViewController:self.invocationTarget];
}


-(void)saveVcStateAfter
{
    NSAssert(self.invocationTarget, @"%s no invocation target",__PRETTY_FUNCTION__);
    self.vcStateAfter = [XFAVcMethodInvocation vcStateForInvocationTarget:self.invocationTarget];
}

/*
+(NSDictionary*)dicStateOfViewController:(UIViewController*)vc{
    
//    XFAViewControllerState * vcState = [XFAViewControllerState new];
    NSArray * vcObjectsPath = [XFAViewControllerState viewControllerObjectsPathToWindow:vc];
    NSArray * vcClassesPath = [XFAViewControllerState viewControllerClassesPathToWindow:vc];
    NSDictionary * vcProperties = [TXViewControllerPropertiesScanner propertiesOfVC:vc];
    
    NSDictionary * dic = @{
                           @"classesPath" : vcClassesPath,
                           @"objectsPath" : vcObjectsPath,
                           @"properties"  : vcProperties,
                           @"objHash"     : @( vc.hash )
                           };
    
    return dic;
    
}*/


@end
