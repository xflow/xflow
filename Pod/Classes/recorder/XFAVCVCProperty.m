//
//  XFAVCVCProperty.m
//  Pods
//
//  Created by Mohammed Tillawy on 2/13/15.
//
//

#import "XFAVCVCProperty.h"
#import "XFAViewControllerState.h"

@implementation XFAVCVCProperty

-(NSDictionary *)loadValuesFromVC:(UIViewController*)vc
{
    UIViewController * propertyValue = (UIViewController*)[self objectFromVC:vc];
//    XFAViewControllerState * vcState = [XFAViewControllerState new];
    NSArray * vcObjectsPath = [XFAViewControllerState viewControllerObjectsPathToWindow:propertyValue];
    NSArray * vcClassesPath = [XFAViewControllerState viewControllerClassesPathToWindow:propertyValue];
    
    NSDictionary * dic = @{
                           @"classesPath" : vcClassesPath,
                           @"objectsPath" : vcObjectsPath,
                           @"objHash"     : @( vc.hash )
                           };
    
    return dic;
}


@end
