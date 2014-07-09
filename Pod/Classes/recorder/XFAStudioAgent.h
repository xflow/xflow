//
//  XFAStudioAgent.h
//  POC2
//
//  Created by Mohammed Tillawy on 3/9/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XFAStudioAgentVCResponse;
@class AFHTTPRequestOperation;


@interface XFAStudioAgent : NSObject

-(void)listenToMethodInvocations;

@property (nonatomic,strong) NSString * studioHost;
@property (nonatomic,strong) NSString * studioPort;

@property (nonatomic, strong) NSString * feedUrl;


-(AFHTTPRequestOperation *)startFreshStudioXSessionToUrl:(NSString*)urlString
                                             withSuccess:(void (^)(void))success
                                             withFailure:(void(^)(NSError * error))failure;
    

-(AFHTTPRequestOperation *)requestForVC:(UIViewController*)vc
                          onSuccess:(void(^)(XFAStudioAgentVCResponse * resp))success
                          onFailure:(void(^)(NSError * error))failure;


-(AFHTTPRequestOperation *)requestXActionsWithURL:(NSString *)urlString
                                       onSuccess:(void (^)(NSArray * xactions))success
                                       onFailure:(void (^)(NSError * error))failure;


@end
