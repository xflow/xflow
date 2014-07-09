//
//  Swizzle.c
//  AutoSwizzler
//
//  Created by Mohammed Tillawy on 10/3/13.
//  Copyright (c) 2013 Mohammed Tillawy. All rights reserved.
//

#include <stdio.h>


#import <objc/runtime.h>
#import <objc/message.h>
//....

void Swizzle(Class class, SEL original, SEL replacement)
{
    Method origMethod = class_getInstanceMethod(class, original);
    Method newMethod = class_getInstanceMethod(class, replacement);
    method_exchangeImplementations(origMethod, newMethod);

    /*
    if(class_addMethod(class, original , method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(class, replacement, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, newMethod);
    }*/
    
}

