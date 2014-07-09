//
//  UIViewController+XFAProperties.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/20/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "UIViewController+XFAProperties.h"
#import <objc/runtime.h>


static char * const XFAPropertiesKey = "XFAProperties";


@implementation UIViewController (XFAProperties)


- (void)setXfaProperties:(NSMutableArray *)dic
{
	objc_setAssociatedObject(self, XFAPropertiesKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)xfaProperties
{
	return objc_getAssociatedObject(self, XFAPropertiesKey);
}


@end
