//
//  TXEngine.m
//  POC2
//
//  Created by Mohammed Tillawy on 1/2/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFEngine.h"

#import <Bolts/Bolts.h>
#import "XFACrawler.h"
#import "XFAFeedService.h"
#import "XFObjcVcClass.h"
#import "XFAVcMethodInvocation.h"
#import "XFAMethodArgument.h"
#import "XFAMethod.h"
#import "XFAVCProperty.h"
#import "UIViewController+XFAProperties.h"
#import "XFAConstants.h"
#import "TXAction.h"
#import "XFAMethod.h"
#import "XFAVCPropertySetterMethod.h"
#import "XFAInvocationAOP.h"
#import "XFARunMode.h"
#import "XFARun.h"
#import "XFARunStep.h"
#import "XFAViewControllerState.h"
#import <MRProgress/MRProgress.h>
#import <ObjectiveSugar/NSArray+ObjectiveSugar.h>
#import <ObjectiveSugar/NSMutableArray+ObjectiveSugar.h>
#import <CocoaLumberjack/DDLog.h>


static const int ddLogLevel = DDLogLevelError;


@interface XFEngine (){
    
}

+(UIWindow*)mainWindow;

@property (nonatomic, strong) XFAInvocationAOP * aop;

@property (nonatomic, strong) NSString * feedServerUrl;
@property (nonatomic, strong) NSString * playServerUrl;
@property (nonatomic, strong) NSString * apiToken;
@property (nonatomic, strong) XFAFeedService * feedService;
@property (nonatomic, strong) NSString * captureRunId;
@property (nonatomic, strong) XFARunMode * runMode;
@property (nonatomic, strong) XFARun * run;


@end


@implementation XFEngine

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [XFEngine new];
    });
    return sharedInstance;
}


//NSString * const ENV_PLAN_K = @"XX";

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
-(BFTask*)taskGetRunMode{
    BFTaskCompletionSource * tcs = [BFTaskCompletionSource taskCompletionSource];
    NSString * urlString = [NSString stringWithFormat:@"%@/%@/%@" ,self.feedServerUrl , @"v1/pod/run-mode/token",self.apiToken];
    XFAFeedService * feedService = [XFAFeedService new];
    [feedService getRunModeWithURL:urlString withSuccess:^(AFHTTPRequestOperation *op, XFARunMode *obj) {
        [tcs setResult:obj];
    } withFailure:^(AFHTTPRequestOperation *op, NSError *error) {
        [tcs setError:error];
    }];
    return tcs.task;
}


-(BFTask*)taskStartCapture
{
    return [[self taskStartFreshRunOnServer] continueWithBlock:^id(BFTask *task) {
        NSDictionary * runDic = task.result;
        NSString * newRunId = [runDic objectForKey:@"id"];
        self.captureRunId = newRunId;
        [self doVC:[XFEngine mainWindow].rootViewController];
        [self listenToMethodInvocations];
        return task;
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sequenceStartedByNotif:)
                                                 name:NOTIF_SEQUENCE_STARTED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sequenceEndedByNotif:)
                                                 name:NOTIF_SEQUENCE_ENDED
                                               object:nil];
}


-(void)unlisten{
    NSArray * notifNames = @[NOTIF_METHOD_PRE_INVOCATION, NOTIF_METHOD_POST_INVOCATION,NOTIF_SEQUENCE_STARTED,NOTIF_SEQUENCE_ENDED];
    for (NSString * notifName in notifNames) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:notifName object:nil];
    };
}


-(void)waitForNewVCsByNotif:(NSNotification*)notif
{
    XFAVcMethodInvocation * invoc = (XFAVcMethodInvocation *) notif.object;
    
    if ( invoc.method.isChildVcEntryPoint)
    {
        XFAMethodArgument * arg = [invoc.method.methodArguments objectAtIndex:invoc.method.childVcArgumentIndex.integerValue];
        NSAssert([arg.argumentValue isKindOfClass:[UIViewController class]], @"argument is not a UIViewContoller");
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_VC object:arg.argumentValue userInfo:nil];
        [self doVC:(UIViewController*)arg.argumentValue];
    }
    
}


-(void)capturePreMethodByNotif:(NSNotification*)notif{
//    MTVcMethodInvocation * mthInvo = notif.object;
}

-(void)capturePostMethodByNotif:(NSNotification*)notif{
//    MTVcMethodInvocation * mthInvo = notif.object;
}


-(void)sequenceStartedByNotif:(NSNotification*)note{

}

-(void)sequenceEndedByNotif:(NSNotification*)note{
    NSArray * sequence = note.object;
    [self feedSequence:sequence];
}

-(void)feedSequence:(NSArray*)seq
{
    NSString * path = [NSString stringWithFormat:@"v1/pod/runs/%@/steps/token/%@",self.captureRunId ,self.apiToken];
    NSString * urlString = [NSString stringWithFormat:@"%@/%@", self.feedServerUrl , path];
    
    XFAFeedService * ser = [XFAFeedService new];
    
    [ser feedStepInvocations:seq
          withReferenceRunId:self.captureRunId
                    withRunMode:self.runMode
                     withUrl:urlString
                   onSuccess:^(AFHTTPRequestOperation *op, id obj) {
        
    } onFailure:^(AFHTTPRequestOperation *op, NSError *error) {
        NSString * msg = [NSString stringWithFormat:@"%@ %@",error.domain,urlString];
        DDLogError(@"%s %@",__PRETTY_FUNCTION__,error);
        [[[UIAlertView alloc] initWithTitle:@"FEED ACTION ERROR" message:msg delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil, nil] show];
    }];
    
}



-(BFTask*)taskStartFreshRunOnServer
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

-(BFTask*)taskGetFromServerRunWithId:(NSString*)runId
{
    BFTaskCompletionSource * tcs = [BFTaskCompletionSource taskCompletionSource];
    NSString * urlString = [NSString stringWithFormat:@"%@/v1/pod/runs/%@/token/%@" ,self.playServerUrl ,runId,self.apiToken];
    XFAFeedService * feedService = [XFAFeedService new];
    [feedService getRunWithURL:urlString withSuccess:^(AFHTTPRequestOperation *op, XFARun *obj) {
        [tcs setResult:obj];
    } withFailure:^(AFHTTPRequestOperation *ope, NSError *error) {
        [tcs setError:error];
    }];
    
    return tcs.task;
}

+(BFTask*)taskCruiseControlRun:(XFARun*)cruiseRun
{
    BFTaskCompletionSource * tcs = [BFTaskCompletionSource taskCompletionSource];
    
    for ( XFARunStep * step in cruiseRun.steps) {
        XFAVcMethodInvocation * invo = [step.invocations lastObject];
        XFAViewControllerState * vcStateBefore = invo.vcStateBefore;
//            XFAViewControllerState * vcStateAfter = invo.vcStateAfter;
        
//            NSDictionary * dic1Root = vcStateBefore.vcPath[0];
        
//        NSMutableArray * marr = vcStateBefore.vcPath.mutableCopy;
        UIViewController * invocationTarget = [XFAViewControllerState viewControllerForPath:vcStateBefore.vcPath
                                                                                 withWindow:[XFEngine mainWindow]];
        
        /*NSDictionary * dic1Root = [marr first];
        [marr removeObjectAtIndex:0];
        dic1Root[@"vcRoot"];
        dic1Root[@"vcParentChildrenKey"];
        dic1Root[@"vcChildrenKey"];
        dic1Root[@"vcInParentChildIndex"];
        dic1Root[@"vcHash"];
        NSString * rootVcClassString = dic1Root[@"vcClass"];
        
        UIViewController * rootVC = [XFEngine mainWindow].rootViewController;
        NSAssert([rootVC isMemberOfClass:NSClassFromString(rootVcClassString)], @"root vc shold be %@",rootVcClassString);
        
        __block id vcA = rootVC;
        [marr eachWithIndex:^(NSDictionary * dic, NSUInteger index) {
            
            NSString * vcParentChildrenKey = dic[@"vcParentChildrenKey"];
//                NSString * vcChildrenKey =  dic[@"vcChildrenKey"];
            NSNumber * vcInParentChildIndex =  dic[@"vcInParentChildIndex"];
            NSArray * children = [vcA valueForKey:vcParentChildrenKey];
            NSString * vcClassStr = dic[@"vcClass"];
            Class vcClass  = NSClassFromString(vcClassStr);
            id vcB = children[vcInParentChildIndex.integerValue];
            NSAssert([vcB isMemberOfClass:vcClass], @"expeted class to be: %@",vcClassStr);
            vcA = vcB;
        }];
        NSLog(@"vcA:%@",vcA);
        UIViewController * invocationTarget = vcA;*/
        [invo.method applyTo:invocationTarget];
        
    }
    
    return tcs.task;
    
}

-(void)startWithFeedServer:(NSString*)feedServer withPlayServer:(NSString*)playServer withApiToken:(NSString*)apiToken {
    NSLog(@"TXEngine on");
    self.apiToken = apiToken;
    self.feedServerUrl = feedServer;
    self.playServerUrl = playServer;
    
    [[self taskGetRunMode] continueWithBlock:^id(BFTask *task) {
        
        if (task.error) {
            DDLogError(@"%s %@",__PRETTY_FUNCTION__,task.error);
            UIAlertView * av = [[UIAlertView alloc] initWithTitle:task.error.domain message:task.error.localizedDescription delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil, nil];
            [av show];
            return nil;
        }
        
        self.runMode = task.result;
        
        switch (self.runMode.runModeValue) {
            case XFARunModeValueUnknown:{
                NSString * title = @"xflow not running";
                NSString * message = @"MAKE_SURE_YOU_SET_RUN_MODE";
                UIAlertView * av = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
                [av show];
                return nil;
                break;
            }
                
            case XFARunModeValueOff:{
                NSLog(@"***** XFLOW *****");
                NSLog(@"***** is off for this project *****");
                NSLog(@"****************");
                return nil;
                break;
            }
            case XFARunModeValueCapture:{
                [MRProgressOverlayView showOverlayAddedTo:[XFEngine mainWindow] title:@"LOADING_VC_SETUP" mode:MRProgressOverlayViewModeIndeterminate animated:YES];
                return [[self taskStartCapture] continueWithBlock:^id(BFTask *task) {
                    [MRProgressOverlayView dismissOverlayForView:[XFEngine mainWindow] animated:YES];
                    return nil;
                }];
                break;
            }
            case XFARunModeValueCruiseControl:{
                [MRProgressOverlayView showOverlayAddedTo:[XFEngine mainWindow] animated:YES];
                return [[self taskGetFromServerRunWithId:self.runMode.runId] continueWithBlock:^id(BFTask *task) {
                    if (task.error) {
                        DDLogError(@"%s %@",__PRETTY_FUNCTION__,task.error);
                        //NSLog(@"%s %@",__PRETTY_FUNCTION__,task.error);
                        [MRProgressOverlayView showOverlayAddedTo:[XFEngine mainWindow] title:task.error.description mode:MRProgressOverlayViewModeCross animated:YES];
                        return nil;
                    }
                    self.run = task.result;
                    return [[self taskStartCapture] continueWithBlock:^id(BFTask *task) {
                        if (task.error) {
                            [MRProgressOverlayView showOverlayAddedTo:[XFEngine mainWindow] title:task.error.description mode:MRProgressOverlayViewModeCross animated:YES];
                            return nil;
                        }
                        
                        [MRProgressOverlayView dismissOverlayForView:[XFEngine mainWindow] animated:YES];
                        return [[XFEngine taskCruiseControlRun:self.run] continueWithBlock:^id(BFTask *task) {
                            NSLog(@"");
                            return nil;
                        }];
                    }];
                }];
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
    NSLog(@"%@",vc);
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
        
        for (XFAMethod * method in methods) {
//            NSLog(@"doVc: %@, method:%@",[vc class],method.signature);
            if (! [vc respondsToSelector:method.selector]) {
                NSAssert([vc respondsToSelector:method.selector], @"%@ not found for %@",method.signature,vc);
            }
            [self monitorMethod:method forViewController:vc];
            
        }
        
        for (XFAVCProperty * property in vcresp.properties) {
//            NSLog(@"doVc: %@, property:%@",[vc class],property.propertyName);
            if (![vc respondsToSelector:NSSelectorFromString(property.propertyName)]) {
                NSAssert([vc respondsToSelector:NSSelectorFromString(property.propertyName)], @"property not found %@ for vc:%@",property, [vc class]);
            }

//            NSAssert([vc respondsToSelector:NSSelectorFromString(@"selectedViewController")], @"property not found %@",property.propertyName);
            [self monitorProperty:property forViewController:vc];
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
        
        DDLogError(@"%s %@",__PRETTY_FUNCTION__,error);
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"xflow launch failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
//        NSAssert(FALSE, @"doVC onFailure: %@",error.localizedDescription);
    }];

    
}

-(void)monitorProperty:(XFAVCProperty*)property forViewController:(UIViewController*)vc
{
    [self.aop observeVC:vc property:property];
}

-(void)monitorMethod:(XFAMethod*)method forViewController:(UIViewController*)vc{
    NSAssert(self.aop, @"");
    NSParameterAssert(method);
    NSParameterAssert(vc);
    [self.aop invoAopPre:vc method:method];
    [self.aop invoAopPost:vc method:method];
}




+(UIWindow*)mainWindow{
    return [[UIApplication sharedApplication].windows objectAtIndex:0];
}



@end


