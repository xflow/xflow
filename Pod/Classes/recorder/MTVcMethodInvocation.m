//
//  MTVcMethodInvocation.m
//  POC2
//
//  Created by Mohammed Tillawy on 4/1/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "MTVcMethodInvocation.h"

#import "XFAViewControllerState.h"
#import "TXViewControllerPropertiesScanner.h"


@interface MTVcMethodInvocation ()

@property (nonatomic,strong) NSDictionary * vcStateBefore;
@property (nonatomic,strong) NSDictionary * vcStateAfter;

@end

@implementation MTVcMethodInvocation


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"method" : @"method",
             @"invocationIndexWithStack" : @"invocationIndexWithStack",
             };
}

-(void)saveVcStateBefore
{
    NSAssert(self.invocationTarget, @"%s no invocation target",__PRETTY_FUNCTION__);
    self.vcStateBefore = [MTVcMethodInvocation dicStateOfViewController:self.invocationTarget];
}


-(void)saveVcStateAfter
{
    NSAssert(self.invocationTarget, @"%s no invocation target",__PRETTY_FUNCTION__);
    self.vcStateAfter = [MTVcMethodInvocation dicStateOfViewController:self.invocationTarget];
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
