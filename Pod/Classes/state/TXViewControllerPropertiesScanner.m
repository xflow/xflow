//
//  TXViewControllerPropertiesScanner.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/20/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "TXViewControllerPropertiesScanner.h"
#import "UIViewController+XFAProperties.h"
//#import "XFAVCProperty.h"

#import <XFAVCProperty.h>

@implementation TXViewControllerPropertiesScanner




+(NSDictionary *)propertiesOfVC:(UIViewController*)vc{
    NSAssert(vc.xfaProperties, @"TXViewControllerPropertiesScanner no vc.xfaProperties");
    NSMutableDictionary * propertiesDic = @{}.mutableCopy;
    for (XFAVCProperty * prop in vc.xfaProperties) {
        NSDictionary * dic = [prop loadValuesFromVC:vc];
        [propertiesDic setObject:dic forKey:prop.propertyName];
    }
    return propertiesDic;
}



@end
