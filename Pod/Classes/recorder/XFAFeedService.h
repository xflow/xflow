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

@interface XFAFeedService : NSObject

-(void)listenToMethodInvocations;

@property (nonatomic, strong) NSString * feedServer;
@property (nonatomic, strong) NSString * apiToken;

-(AFHTTPRequestOperation *)startFreshStudioXSessionToUrl:(NSString*)urlString
                                             withSuccess:(void (^)(void))success
                                             withFailure:(void(^)(NSError * error))failure;
    
-(AFHTTPRequestOperation *)feedVC:(UIViewController*)vc
                        onSuccess:(void(^)(XFAStudioAgentVCResponse * resp))success
                        onFailure:(void(^)(NSError * error))failure;



-(AFHTTPRequestOperation *)requestXActionsWithURL:(NSString *)urlString
                                       onSuccess:(void (^)(NSArray * xactions))success
                                       onFailure:(void (^)(NSError * error))failure;


@end
