//
//  MethodsList.m
//  AutoSwizzler
//
//  Created by Mohammed Tillawy on 10/3/13.
//  Copyright (c) 2013 Mohammed Tillawy. All rights reserved.
//

#import "MTMethodsList.h"
#import <objc/runtime.h>
#import "XFAMethod.h"


@implementation MTMethodsList



-(void)scan:(NSObject*)obj  {
    
    int i=0;
    unsigned int mc = 0;
    Method * mlist = class_copyMethodList(object_getClass(obj), &mc);
    NSLog(@"%d methods", mc);
    for(i=0;i<mc;i++){
        const char* const type = method_copyReturnType(mlist[i]);
        NSLog(@"Method no #%d: name:%s, return:%s",
                     i,
                     sel_getName(method_getName(mlist[i])) ,
                     type
                     );
    }
}


-(NSMutableArray*)methods:(NSObject*)obj  {
    
    int i=0;
    
    unsigned int mc = 0;
    Method * mlist = class_copyMethodList(object_getClass(obj), &mc);
//    NSLog(@"%d methods", mc);
    NSMutableArray * arr = [[NSMutableArray alloc] initWithCapacity:mc];
    
//    char** list;
//    list = malloc(mc * sizeof(char*));
    for(i=0;i<mc;i++){
        
        XFAMethod * method = [[XFAMethod alloc] init];
        method.classTypeInstance = obj;
        
        const char * const type = method_copyReturnType(mlist[i]);
        const char * name = sel_getName(method_getName(mlist[i]));
        const char * encoding = method_getTypeEncoding(mlist[i]);
        
        NSString *n = [NSString stringWithFormat:@"%s",name];
        NSString *t = [NSString stringWithFormat:@"%s",type];
        NSString *e = [NSString stringWithFormat:@"%s",encoding];
        
        
        method.methodName = n;
        method.methodReturnType = t;
        method.methodTypeEncoding = e;
        
        NSLog(@"methodName:%@,methodReturnType:%@ ,methodTypeEncoding:%@",
              n,t,e );
        
        int argumentsCount = method_getNumberOfArguments(mlist[i]);
        
        for (int ar = 0; ar < argumentsCount; ar++) {
            size_t dst_len = 256;
            char dst[dst_len];
            method_getArgumentType(mlist[i],ar,dst,dst_len);
            
            NSString *argType = [NSString stringWithUTF8String:dst];
//            NSLog(@"method:%@",method);
            NSString *log = [NSString stringWithFormat:@" %@ name: %s %d -> %s",method.methodName,name,ar,dst];

//            NSLog(@"%@ argType:%@",log,argType);
            [method addArgument:argType atIndex:ar];
        }
        
        
        NSLog(@"Method no #%d: name:%s, return:%s",
                     i,
                     sel_getName(method_getName(mlist[i])) ,
                     type
                     );
        
//        char *bar = strdup(name);
        
//        list[i] = malloc((sizeof(name)+1) * sizeof(char)); // yeah, I know sizeof(char) is 1, but to make it clear...
//        list[i] = bar;

        
        [arr addObject:method];
    }
    
    return arr;
}


@end
