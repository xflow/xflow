//
//  TXEngine.m
//  POC2
//
//  Created by Mohammed Tillawy on 1/2/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFEngine.h"

#import "MTSwizzleManager.h"
#import "XFACrawler.h"
#import "XFAFeedService.h"
#import "XFObjcVcClass.h"
#import "MTVcMethodInvocation.h"
#import "MTMethodArgument.h"
#import "MTMethod.h"
#import "XFAVCProperty.h"
#import "UIViewController+XFAProperties.h"
#import "XFAConstants.h"
#import "TXAction.h"
#import "MTMethod.h"
#import "XFAInvocationAOP.h"
#import "XFARun.h"
#import <Bolts/Bolts.h>

typedef NS_ENUM(NSInteger, TXEngineMode) {
    TXEngineModeUnknown         = 0,
    TXEngineModeOff             = 1,
    TXEngineModeCapture         = 2,
    TXEngineModeCruiseControl   = 3,
    TXEngineModeTest            = 4
};

@interface XFEngine (){
    
}

@property (nonatomic, strong) UIWindow      * mainWindow;
//@property (nonatomic, assign) TXEngineMode engineMode;
@property (nonatomic, strong) XFAInvocationAOP * aop;

@property (nonatomic, strong) NSString * feedServerUrl;
@property (nonatomic, strong) NSString * playServerUrl;
@property (nonatomic, strong) NSString * apiToken;
@property (nonatomic, strong) XFAFeedService * feedService;

@end


@implementation XFEngine

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = self.new;
    });
    return sharedInstance;
}


NSString * const ENV_PLAN_K = @"XX";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.aop = [XFAInvocationAOP new];
        self.feedService = [XFAFeedService new];
    }
    return self;
}
/*
-(TXEngineMode)figureOutEngineMode{
    
    const char * K_ENV_PLAN = [ENV_PLAN_K cStringUsingEncoding:NSUTF8StringEncoding];
    const char * ENV_PLAN = getenv(K_ENV_PLAN);
    TXEngineMode mode = TXEngineModeUnknown;
    if ( ENV_PLAN ) {
        mode = TXEngineModeCruiseControl;
    } else {
        mode = TXEngineModeCapture;
    }
    return mode;
}*/
/*
-(NSString*)feedUrl{
    
    const char * K_ENV_PLAN = [ENV_PLAN_K cStringUsingEncoding:NSUTF8StringEncoding];
    const char * ENV_PLAN = getenv(K_ENV_PLAN);
    NSString * p = nil;
    if ( ENV_PLAN ) {
        p =  [NSString stringWithCString:ENV_PLAN encoding:NSUTF8StringEncoding];
        NSLog(@"self.xsequenceId: %@" , p );
    }
    return p;
}
*/
-(BFTask*)getRunModeTask{
    BFTaskCompletionSource * tcs = [BFTaskCompletionSource taskCompletionSource];
    NSString * urlString = [NSString stringWithFormat:@"%@/%@/%@" ,self.feedServerUrl , @"v1/pod/runMode/token",self.apiToken];
    XFAFeedService * feedService = [XFAFeedService new];
    [feedService getRunModeWithURL:urlString withSuccess:^(AFHTTPRequestOperation *op, XFARun *obj) {
        [tcs setResult:obj];
    } withFailure:^(AFHTTPRequestOperation *op, NSError *error) {
        [tcs setError:error];
    }];
    return tcs.task;
}


-(BFTask*)startCaptureTask{
    return [[self startFreshRunOnServer] continueWithBlock:^id(BFTask *task) {
        [self listenToMethodInvocations];
        return nil;
    }];
}


-(void)listenToMethodInvocations
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(waitForNewVCsByNotif:)
                                                 name:NOTIF_METHOD_POST_INVOCATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(capturePreMethodByNotif:)
                                                 name:NOTIF_METHOD_PRE_INVOCATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(capturePostMethodByNotif:)
                                                 name:NOTIF_METHOD_POST_INVOCATION
                                               object:nil];
}


-(void)waitForNewVCsByNotif:(NSNotification*)notif
{
    MTVcMethodInvocation * invoc = (MTVcMethodInvocation *) notif.object;
    
    if ( invoc.method.isChildVcEntryPoint)
    {
        MTMethodArgument * arg = [invoc.method.methodArguments objectAtIndex:invoc.method.childVcArgumentIndex.integerValue];
        NSAssert([arg.argumentValue isKindOfClass:[UIViewController class]], @"argument is not a UIViewContoller");
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_VC object:arg.argumentValue userInfo:nil];
        [self doVC:arg.argumentValue];
    }
    
}


-(void)capturePreMethodByNotif:(NSNotification*)notif{
    MTVcMethodInvocation * mthInvo = notif.object;
}

-(void)capturePostMethodByNotif:(NSNotification*)notif{
    MTVcMethodInvocation * mthInvo = notif.object;
    
    NSString * path = [NSString stringWithFormat:@"v1/pod/feed/xinvocations/token/%@", self.apiToken];
    NSString * urlString = [NSString stringWithFormat:@"%@/%@", self.playServerUrl , path];
    
    XFAFeedService * ser = [XFAFeedService new];
    [ser feedInvocation:mthInvo withUrl:urlString onSuccess:^(AFHTTPRequestOperation *op, id obj) {
        
    } onFailure:^(AFHTTPRequestOperation *op, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"FEED ACTION ERROR" message:error.localizedDescription delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil, nil] show];
    }];
    
}



-(BFTask*)startFreshRunOnServer
{
    BFTaskCompletionSource * tcs = [BFTaskCompletionSource taskCompletionSource];
    NSString * urlString = [NSString stringWithFormat:@"%@/v1/pod/runs/token/%@" ,self.feedServerUrl ,self.apiToken];
    XFAFeedService * feedService = [XFAFeedService new];
    [feedService startRunWithURL:urlString withSuccess:^(AFHTTPRequestOperation *op, NSDictionary *obj) {
        [tcs setResult:obj];
    } withFailure:^(AFHTTPRequestOperation *op, NSError *error) {
        [tcs setError:error];
    }];
    return tcs.task;
}

-(BFTask*)getFromServerRunWithId:(NSString*)runId
{
    BFTaskCompletionSource * tcs = [BFTaskCompletionSource taskCompletionSource];
    NSString * urlString = [NSString stringWithFormat:@"%@/v1/pod/runs/%@/token/%@" ,self.playServerUrl ,runId,self.apiToken];
    XFAFeedService * feedService = [XFAFeedService new];
    [feedService getRunModeWithURL:urlString withSuccess:^(AFHTTPRequestOperation *op, XFARun *obj) {
        [tcs setResult:obj];
    } withFailure:^(AFHTTPRequestOperation *op, NSError *error) {
        [tcs setError:error];
    }];
    return tcs.task;
}

-(BFTask*)cruiseControlRunWithId:(NSString*)runId
{
    BFTaskCompletionSource * tcs = [BFTaskCompletionSource taskCompletionSource];
    
    return [[self getFromServerRunWithId:runId] continueWithBlock:^id(BFTask *task) {
//       XFARun * r = task.result;
//        [r run]
        return task;
    }];
    
    return tcs.task;
    
}

-(void)startWithFeedServer:(NSString*)feedServer withPlayServer:(NSString*)playServer withApiToken:(NSString*)apiToken {
    NSLog(@"TXEngine on");
    self.apiToken = apiToken;
    self.feedServerUrl = feedServer;
    self.playServerUrl = playServer;
    
    [[self getRunModeTask] continueWithBlock:^id(BFTask *task) {
        
        if (task.error) {
            UIAlertView * av = [[UIAlertView alloc] initWithTitle:task.error.domain message:task.error.localizedDescription delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil, nil];
            [av show];
            return nil;
        }
        
        XFARun * r = task.result;
        
        switch (r.runMode) {
            case XFARunModeUnknown:{
                NSString * title = @"xflow not running";
                NSString * message = @"MAKE_SURE_YOU_SET_RUN_MODE";
                UIAlertView * av = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
                [av show];
                return nil;
                break;
            }
            case XFARunModeCapture:{
                return [self startCaptureTask];
                break;
            }
            case XFARunModeCruiseControl:{
                return [self cruiseControlRunWithId:r.runId];
                break;
            }
            default:
                break;
        }
        return task;
    }];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vcDetectedWithNotif:) name:NOTIF_VC object:nil];
    
}

/*
-(void)vcDetectedWithNotif:(NSNotification*)notif{
    id obj = notif.object;
    NSAssert([obj isKindOfClass:[UIViewController class]], @"we don't have a vc");
    UIViewController * vc = (UIViewController*)obj;
    [self doVC:vc];
}
*/

-(void)doVC:(UIViewController*)vc{
    NSAssert([vc isKindOfClass:[UIViewController class]], @"we don't have a vc");
    NSParameterAssert(vc);
    
    /*if ([MTMethod isVcClassProcessed:vc.class]) {
        NSLog(@"%@ allready processed",vc.class);
        return;
    } else {
        [MTMethod setVcClassAsProcessed:vc.class];
    }*/
    
    NSString * path = [NSString stringWithFormat:@"v1/pod/vcs/%@/token/%@",NSStringFromClass(vc.class), self.apiToken];
    NSString * urlString = [NSString stringWithFormat:@"%@/%@", self.playServerUrl , path];
    
    XFAFeedService * service = [XFAFeedService new];
    [service requestSetupForVC:vc withUrl:urlString onSuccess:^(AFHTTPRequestOperation * op, XFObjcVcClass * vcresp){
        
//        NSLog(@"vcresp:%@",vcresp);
        
        NSArray * methods = vcresp.methods;
//        NSLog(@"methods:%@",methods);
        
//        NSAssert(methods, @"doVC:'%@' no methods at all", vc.class);
//        NSAssert(methods.count > 0, @"doVC no methods %@",vc.class);
        
        for (MTMethod * method in methods) {
            if (method.isInterceptable) {
                NSLog(@"doVc: %@, method:%@",[vc class],method.signature);
                NSAssert([vc respondsToSelector:method.selector], @"%@ not found for %@",method.signature,vc);
                [self monitorMethod:method forViewController:vc];
            }
        }
        
//        NSString * assertMsg = [NSString stringWithFormat:@"TXEngine doVC:%@ no vcresp.properties", [vc class]];
//        NSAssert(vcresp.properties, assertMsg);
        
        vc.xfaProperties = NSMutableArray.new;
        
        for (XFAVCProperty * prop in vcresp.properties) {
            [vc.xfaProperties addObject:prop];
        }
        
//        NSAssert(vc.xfaProperties, @"TXEngine doVC vc.xfaProperties");
        
        NSString * childrenKey = [XFACrawler childrenKeyForObject:vc];
        NSAssert(childrenKey, @"doVC no childrenKey");
        NSArray * childVCs = [vc valueForKey:childrenKey];
        
        
        for (UIViewController * childVc in childVCs) {
            [self doVC:childVc];
        }
//        if (childVCs.count == 0) {}
        
    } onFailure:^(AFHTTPRequestOperation * op,NSError *error) {
        
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"xflow launch failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
//        NSAssert(FALSE, @"doVC onFailure: %@",error.localizedDescription);
    }];

    
}

-(void)monitorMethod:(MTMethod*)method forViewController:(UIViewController*)vc{
    NSAssert(self.aop, @"");
    NSParameterAssert(method);
    NSParameterAssert(vc);
    [self.aop invoAopPre:vc method:method];
    [self.aop invoAopPost:vc method:method];
}



-(UIWindow*)mainWindow{
    return [[UIApplication sharedApplication].windows objectAtIndex:0];
}



@end


