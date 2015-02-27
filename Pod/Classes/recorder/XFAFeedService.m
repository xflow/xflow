//
//  XFAStudioAgent.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/9/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAFeedService.h"
#import "XFAConstants.h"
#import <AFNetworking/AFNetworking.h>
#import <Mantle/Mantle.h>
#import "XFObjcVcClass.h"
#import "XFAVcMethodInvocation.h"

#import "UIViewController+XFAProperties.h"
#import "XFARunMode.h"
#import "XFARun.h"


@interface XFAFeedService (){
    
}

@end


@implementation XFAFeedService

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(AFHTTPRequestOperation *)getRunWithURL:(NSString*)urlString
                                 withSuccess:(void (^)(AFHTTPRequestOperation *,XFARun * obj))success
                                 withFailure:(void(^)(AFHTTPRequestOperation *,NSError * error))failure
{
    
    NSError * reqError = nil;
    NSMutableURLRequest * req = [[AFJSONRequestSerializer serializer] requestWithMethod:GET URLString:urlString parameters:@{} error:&reqError];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:req];
    operation.responseSerializer = [AFJSONResponseSerializer new];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary * dic) {
        NSHTTPURLResponse * httpResp = operation.response;
        NSAssert(httpResp.statusCode == 200, @"responses not 200");
        NSLog(@"success: %@", operation.responseString);
        NSError * error = nil;
//        NSLog(@"JSON: %@, error:%@", responseObject,error);
        XFARun * run = [MTLJSONAdapter modelOfClass:[XFARun class] fromJSONDictionary:dic error:&error];
        NSAssert(!error, @"MTLJSONAdapter error %@",error);
        success(operation,run);
    } failure:failure];
    [[NSOperationQueue mainQueue] addOperation:operation];
    return operation;
    
}



-(AFHTTPRequestOperation *)getRunModeWithURL:(NSString*)urlString
                          withSuccess:(void (^)(AFHTTPRequestOperation *,XFARunMode * obj))success
                          withFailure:(void(^)(AFHTTPRequestOperation *,NSError * error))failure{
    
    
    NSMutableURLRequest * req = [[AFJSONRequestSerializer serializer] requestWithMethod:GET URLString:urlString parameters:@{} error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:req];
    
    operation.responseSerializer = [AFJSONResponseSerializer new];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary * dic) {
        
        NSLog(@"success: %@", operation.responseString);
        
        NSError * error = nil;
        
//        NSLog(@"JSON: %@, error:%@", responseObject,error);
        
        XFARunMode * run = [MTLJSONAdapter modelOfClass:[XFARunMode class] fromJSONDictionary:dic error:&error];
        NSAssert(!error, @"MTLJSONAdapter error");
        
        success(operation,run);
        
    } failure:failure];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
    
    return operation;
    
}

-(AFHTTPRequestOperation *)startRunWithURL:(NSString*)urlString
                               withSuccess:(void (^)(AFHTTPRequestOperation *, id obj))success
                               withFailure:(void(^)(AFHTTPRequestOperation *,NSError * error))failure{
    
    NSDictionary * parameters = @{};
    
    NSMutableURLRequest * req = [[AFJSONRequestSerializer serializer] requestWithMethod:POST URLString:urlString parameters:parameters error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:req];

    operation.responseSerializer = [AFJSONResponseSerializer new];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success: %@", operation.responseString);
        
        NSError * error = nil;
        
//        NSLog(@"JSON: %@, error:%@", responseObject,error);
        
        NSAssert(!error, @"MTLJSONAdapter error");
        
        success(operation,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"operation.responseString: %@", operation.responseString);
        NSLog(@"Error: %@", error);

        [[[UIAlertView alloc] initWithTitle:@"FEED ACTION ERROR" message:error.localizedDescription delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil, nil] show];
        failure(operation,error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
    
    return operation;
    
}



-(AFHTTPRequestOperation*)feedStepInvocations:(NSArray*)arr
                           withReferenceRunId:(NSString*)refRunId
                                  withRunMode:(XFARunMode*)runMode
                                      withUrl:(NSString*)urlString
                                    onSuccess:(void (^)(AFHTTPRequestOperation *op,id obj))success
                                    onFailure:(void (^)(AFHTTPRequestOperation *op,NSError * error))failure
{
    NSError * reqError = nil;
    NSArray * jsonArr = [MTLJSONAdapter JSONArrayFromModels:arr];
    NSDictionary * stepDic = @{@"invocations" : jsonArr};
    NSMutableURLRequest * req = [[AFJSONRequestSerializer serializer] requestWithMethod:POST URLString:urlString parameters:stepDic error:&reqError];
    NSAssert(!reqError, @"%@",reqError);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:req];
    operation.responseSerializer = [AFJSONResponseSerializer new];
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [[NSOperationQueue mainQueue] addOperation:operation];
    return operation;
}


-(AFHTTPRequestOperation *)requestSetupForVC:(UIViewController*)vc
                                     withUrl:(NSString*)urlString
                                   onSuccess:(void(^)(AFHTTPRequestOperation * op,XFObjcVcClass * vcClass))success
                                   onFailure:(void(^)(AFHTTPRequestOperation * op, NSError * error))failure{
    

    
//    NSLog(@"requestSetupForVC %@ urlString:%@",vc.class,urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFHTTPRequestOperation * op = [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError * error = nil;
        
        XFObjcVcClass * vcResp = [MTLJSONAdapter modelOfClass:[XFObjcVcClass class] fromJSONDictionary:responseObject error:&error];
        
//        NSLog(@"JSON: %@, error:%@", responseObject,error);
        
        NSAssert(!error, @"MTLJSONAdapter error");
        
        success(operation,vcResp);
    } failure:failure];
    
    return op;
}

@end
