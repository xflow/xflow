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

@property (nonatomic,strong) NSDictionary * vcStateBefore;
@property (nonatomic,strong) NSDictionary * vcStateAfter;

@end

@implementation XFAVcMethodInvocation


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"method" : @"method",
             @"invocationIndexWithStack" : @"invocationIndexWithStack",
             };
}

-(void)saveVcStateBefore
{
    NSAssert(self.invocationTarget, @"%s no invocation target",__PRETTY_FUNCTION__);
    self.vcStateBefore = [XFAVcMethodInvocation dicStateOfViewController:self.invocationTarget];
}


-(void)saveVcStateAfter
{
    NSAssert(self.invocationTarget, @"%s no invocation target",__PRETTY_FUNCTION__);
    self.vcStateAfter = [XFAVcMethodInvocation dicStateOfViewController:self.invocationTarget];
}


+(NSDictionary*)dicStateOfViewController:(UIViewController*)vc{
    
    XFAViewControllerState * vcState = [XFAViewControllerState new];
    NSArray * vcObjectsPath = [vcState viewControllerObjectsPathToWindow:vc];
    NSArray * vcClassesPath = [vcState viewControllerClassesPathToWindow:vc];
    NSDictionary * vcProperties = [TXViewControllerPropertiesScanner propertiesOfVC:vc];
    
    NSDictionary * dic = @{
                           @"classesPath" : vcClassesPath,
                           @"objectsPath" : vcObjectsPath,
                           @"properties"  : vcProperties,
                           @"objHash"     : @( vc.hash )
                           };
    
    return dic;
    
}


@end
