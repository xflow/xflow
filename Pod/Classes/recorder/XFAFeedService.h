//
//  XFAStudioAgent.h
//  POC2
//
//  Created by Mohammed Tillawy on 3/9/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XFObjcVcClass;
@class AFHTTPRequestOperation;
@class XFARunMode;
@class XFARun;
@class XFAVcMethodInvocation;

@interface XFAFeedService : NSObject



-(AFHTTPRequestOperation *)getRunModeWithURL:(NSString*)urlString
                                 withSuccess:(void (^)(AFHTTPRequestOperation *,XFARunMode * obj))success
                                 withFailure:(void(^)(AFHTTPRequestOperation *,NSError * error))failure;


-(AFHTTPRequestOperation *)startRunWithURL:(NSString*)urlString
                               withSuccess:(void (^)(AFHTTPRequestOperation *, id obj))success
                               withFailure:(void(^)(AFHTTPRequestOperation *,NSError * error))failure;
    
-(AFHTTPRequestOperation *)requestSetupForVC:(UIViewController*)vc
                                     withUrl:(NSString*)urlString
                        onSuccess:(void(^)(AFHTTPRequestOperation * op,XFObjcVcClass * resp))success
                        onFailure:(void(^)(AFHTTPRequestOperation * op,NSError * error))failure;


-(AFHTTPRequestOperation *)getRunWithURL:(NSString*)urlString
                             withSuccess:(void (^)(AFHTTPRequestOperation * , XFARun * obj))success
                             withFailure:(void(^)(AFHTTPRequestOperation *,NSError * error))failure;


-(AFHTTPRequestOperation*)feedStepInvocations:(NSArray*)arr
                           withReferenceRunId:(NSString*)refRunId
                                  withRunMode:(XFARunMode*)runMode
                                   withUrl:(NSString*)urlString
                                 onSuccess:(void (^)(AFHTTPRequestOperation *op,id obj))success
                                 onFailure:(void (^)(AFHTTPRequestOperation *op,NSError * error))failure;

@end
