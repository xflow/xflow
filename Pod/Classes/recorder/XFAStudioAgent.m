//
//  XFAStudioAgent.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/9/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAStudioAgent.h"
#import "XFAConstants.h"
#import <AFNetworking/AFNetworking.h>
#import <Mantle.h>
#import "XFAStudioAgentVCResponse.h"
#import "MTVcMethodInvocation.h"

#import "UIViewController+XFAProperties.h"
#import "MTMethod.h"
#import "MTMethodArgument.h"
#import "TXAction.h"

@interface XFAStudioAgent (){
    
}

@end


@implementation XFAStudioAgent

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(NSString *)studioHost{
    return _studioHost ? _studioHost : @"127.0.0.1";
}



-(NSString *)studioPort{
    return _studioPort ? _studioPort : @"3000";
}


-(void)listenToMethodInvocations
{
    
    // just to make sure
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIF_METHOD_INVOCATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(feedInvocationToStudioByNotif:)
                                                 name:NOTIF_METHOD_INVOCATION
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(waitForNewVCsByNotif:)
                                                 name:NOTIF_METHOD_INVOCATION
                                               object:nil];
}


-(AFHTTPRequestOperation *)startFreshStudioXSessionToUrl:(NSString*)urlString
                                               withSuccess:(void (^)(void))success
                               withFailure:(void(^)(NSError * error))failure{
    
    NSDictionary * parameters = @{};
    
    NSMutableURLRequest * req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:parameters error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:req];
  
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success: %@", operation.responseString);
        
        NSError * error = nil;
        
//        NSLog(@"JSON: %@, error:%@", responseObject,error);
        
        NSAssert(!error, @"MTLJSONAdapter error");
        
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"operation.responseString: %@", operation.responseString);
        NSLog(@"Error: %@", error);
        
        failure(error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
    
    return operation;
    
}

-(void)waitForNewVCsByNotif:(NSNotification*)notif{
   
    MTVcMethodInvocation * invoc = (MTVcMethodInvocation *) notif.object;
    
    if ( invoc.method.isChildVcEntryPoint)
    {
        MTMethodArgument * arg = [invoc.method.methodArguments objectAtIndex:invoc.method.childVcArgumentIndex];
        NSAssert([arg.argumentValue isKindOfClass:[UIViewController class]], @"argument is not a UIViewContoller");
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_VC object:arg.argumentValue userInfo:nil];
    }

}

-(void)feedInvocationToStudioByNotif:(NSNotification*)notif{

//    NSLog(@"feedInvocationToStudioByNotif,notif:%@",notif.object);

    MTVcMethodInvocation * invoc = (MTVcMethodInvocation *) notif.object;
    
    
    [self feedAction:invoc toURL:self.feedUrl onSuccess:^{
        NSLog(@"feedInvocationToStudio %@",invoc.method);
    } onFailure:^(NSError *error) {
        NSLog(@"feedInvocationToStudio %@",error.localizedDescription);
    }];
    
}

-(void)unlisten{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIF_METHOD_INVOCATION
                                                  object:nil];
    
}


-(AFHTTPRequestOperation *)requestXActionsWithURL:(NSString *)urlString
                                       onSuccess:(void (^)(NSArray * xactions))success
                                       onFailure:(void (^)(NSError * error))failure
{
    
    NSError * reqError = nil;
    
    NSMutableDictionary * parameters = @{}.mutableCopy;
    
    NSMutableURLRequest * req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:parameters error:&reqError];
    NSAssert(! reqError, @"should not have an error");
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:req];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"success: %@", [responseObject class]);
        
        NSAssert([responseObject isKindOfClass:[NSArray class]], @"XActions responseObject is not an array");

//        NSLog(@"JSON: %@, error:%@", responseObject,error);
        
        NSArray * actionsArray = (NSArray*)responseObject;
        
        NSMutableArray * outputArray = [NSMutableArray array];
        
        for (NSDictionary * dic in actionsArray) {
            NSError * error = nil;
            TXAction * xAction = [MTLJSONAdapter modelOfClass:TXAction.class fromJSONDictionary:dic error:&error];
            NSAssert(! error, @"MTLJSONAdapter error");
            [outputArray addObject:xAction];
        }
        
        success(outputArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: operation.responseString: %@", operation.responseString);
        NSLog(@"Error: %@", error);
        
        failure(error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
    
    return operation;
    

}



-(AFHTTPRequestOperation *)feedAction:(MTVcMethodInvocation *)invocation
                               toURL:(NSString*)urlString
                              onSuccess:(void (^)(void))success
                              onFailure:(void(^)(NSError * error))failure{
    

    NSDictionary *invocationJSONDictionary = [MTLJSONAdapter JSONDictionaryFromModel:invocation];
//    NSLog(@"invocationJSONDictionary:%@",invocationJSONDictionary);

    
    NSDictionary * parameters = @{
                                  @"invocation": invocationJSONDictionary,
                                  @"vcStatePre":  invocation.vcStateBefore ,
                                  @"vcStatePost": invocation.vcStateAfter
                                  };
    
    
    NSMutableURLRequest * req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:parameters error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:req];
  
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString * reqBody = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
        NSLog(@"reqBody: %@",reqBody );
        NSLog(@"success: %@", operation.responseString);
        
        NSError * error = nil;
        
//        NSLog(@"JSON: %@, error:%@", responseObject,error);
        
        NSAssert(!error, @"MTLJSONAdapter error");
        
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@", operation.responseString);
        NSLog(@"Error: %@", error);
        
        failure(error);
    }];
 
    [[NSOperationQueue mainQueue] addOperation:operation];

    return operation;
    
}


-(AFHTTPRequestOperation *)requestForVC:(UIViewController*)vc
                              onSuccess:(void(^)(XFAStudioAgentVCResponse * resp))success
                              onFailure:(void(^)(NSError * error))failure{
    
    NSString * path = [NSString stringWithFormat:@"v1/vc/%@/",NSStringFromClass(vc.class) ];
    NSString * urlString = [NSString stringWithFormat:@"http://%@:%@/%@",
                            self.studioHost, self.studioPort, path];
    
    NSLog(@"requestForVC %@ urlString:%@",vc.class,urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFHTTPRequestOperation * op = [manager GET:urlString parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError * error = nil;
        
        XFAStudioAgentVCResponse * vcResp = [MTLJSONAdapter modelOfClass:XFAStudioAgentVCResponse.class fromJSONDictionary:responseObject error:&error];
        
//        NSLog(@"JSON: %@, error:%@", responseObject,error);
        
        NSAssert(!error, @"MTLJSONAdapter error");
        
        success(vcResp);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"requestForVC Failure:%@",operation.responseString);
        NSLog(@"Error: %@", error);
        failure(error);
        
    }];
    
    
    return op;
}

@end
