//
//  MTVcMethodInvocation.m
//  POC2
//
//  Created by Mohammed Tillawy on 4/1/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "MTVcMethodInvocation.h"

#import "TXViewControllerState.h"
#import "TXViewControllerPropertiesScanner.h"


@interface MTVcMethodInvocation ()

@property (nonatomic,strong) NSDictionary * vcStateBefore;
@property (nonatomic,strong) NSDictionary * vcStateAfter;

@end

@implementation MTVcMethodInvocation


-(void)saveVcStateBefore
{
    self.vcStateBefore = [MTVcMethodInvocation dicStateOfViewController:self.invocationTarget];
}


-(void)saveVcStateAfter
{
    self.vcStateAfter = [MTVcMethodInvocation dicStateOfViewController:self.invocationTarget];

}


+(NSDictionary*)dicStateOfViewController:(UIViewController*)vc{
    
    TXViewControllerState * vcState = TXViewControllerState.new;
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
