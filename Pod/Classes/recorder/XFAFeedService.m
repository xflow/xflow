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
#import "MTVcMethodInvocation.h"

#import "UIViewController+XFAProperties.h"
//#import "MTMethod.h"
//#import "MTMethodArgument.h"
#import "TXAction.h"
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




-(AFHTTPRequestOperation *)getRunModeWithURL:(NSString*)urlString
                          withSuccess:(void (^)(AFHTTPRequestOperation *,XFARun * obj))success
                          withFailure:(void(^)(AFHTTPRequestOperation *,NSError * error))failure{
    
    
    NSMutableURLRequest * req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:@{} error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:req];
    
    operation.responseSerializer = [AFJSONResponseSerializer new];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary * dic) {
        
        NSLog(@"success: %@", operation.responseString);
        
        NSError * error = nil;
        
//        NSLog(@"JSON: %@, error:%@", responseObject,error);
        
        XFARun * run = [MTLJSONAdapter modelOfClass:[XFARun class] fromJSONDictionary:dic error:&error];
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
    
    NSMutableURLRequest * req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:parameters error:nil];
    
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


-(AFHTTPRequestOperation*)feedStepSequence:(NSArray*)arr
                                    withUrl:(NSString*)urlString
                                  onSuccess:(void (^)(AFHTTPRequestOperation *op,id obj))success
                                  onFailure:(void(^)(AFHTTPRequestOperation *op,NSError * error))failure{
    
    NSError * reqError = nil;
    
    NSArray * jsonArr = [MTLJSONAdapter JSONArrayFromModels:arr];
    
    NSDictionary * stepDic = @{@"sequence":jsonArr};
    
    NSMutableURLRequest * req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:stepDic error:&reqError];
    NSAssert(!reqError, @"%@",reqError);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:req];
    
    operation.responseSerializer = [AFJSONResponseSerializer new];
    
    [operation setCompletionBlockWithSuccess:success failure:failure];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
    
    return operation;
    
}

/*
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
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
        [[[UIAlertView alloc] initWithTitle:@"FEED ACTION ERROR" message:error.localizedDescription delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil, nil] show];
        NSLog(@"Error: operation.responseString: %@", operation.responseString);
        NSLog(@"Error: %@", error);
        
        failure(error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
    
    return operation;
    

}
*/

/*
-(AFHTTPRequestOperation *)feedInvocation:(MTVcMethodInvocation *)invocation
                                  withUrl:(NSString*)urlString
                                onSuccess:(void (^)(AFHTTPRequestOperation *op,id obj))success
                                onFailure:(void(^)(AFHTTPRequestOperation *op,NSError * error))failure{
    

    NSDictionary *invocationJSONDictionary = [MTLJSONAdapter JSONDictionaryFromModel:invocation];
//    NSLog(@"invocationJSONDictionary:%@",invocationJSONDictionary);

    NSDictionary * parameters = @{ @"invocation": invocationJSONDictionary };

    NSMutableURLRequest * req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:parameters error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:req];
   
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, id responseObject) {

//        NSString * reqBody = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
//        NSLog(@"reqBody: %@",reqBody );
//        NSLog(@"success: %@", operation.responseString);
//        NSError * error = nil;
//        NSLog(@"JSON: %@, error:%@", responseObject,error);
//        NSAssert(!error, @"MTLJSONAdapter error");
        
        success(op,responseObject);
        
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        
        NSLog(@"error: %@", operation.responseString);
        NSLog(@"Error: %@", error);
        [[[UIAlertView alloc] initWithTitle:@"FEED ACTION ERROR" message:error.localizedDescription delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil, nil] show];
        failure(op,error);
    }];
 
    [[NSOperationQueue mainQueue] addOperation:operation];

    return operation;
    
}

*/


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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"FEED ACTION ERROR" message:error.localizedDescription delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil, nil] show];
        NSLog(@"requestForVC %@, Failure:%@",urlString,operation.responseString);
        NSLog(@"Error: %@", error);
        failure(operation,error);
        
    }];
    
    
    return op;
}

@end
