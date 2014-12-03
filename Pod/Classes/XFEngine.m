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
#import "MTMethod.h"
#import "XFAVCProperty.h"
#import "UIViewController+XFAProperties.h"
#import "XFAConstants.h"
#import "TXAction.h"
#import "MTMethod.h"

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
@property (nonatomic, strong) XFAFeedService * feedService;
@property (nonatomic, assign) TXEngineMode engineMode;
@property (nonatomic, strong) NSString * apiToken;

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
}

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


-(void)startWithFeedServer:(NSString*)feedServer withPlayServer:(NSString*)playServer withApiToken:(NSString*)apiToken{
    NSLog(@"TXEngine on");
    self.apiToken = apiToken;
    UIViewController * vc = self.mainWindow.rootViewController;
    self.feedService = [XFAFeedService new];

    self.engineMode = [self figureOutEngineMode];
        
//    self.engineMode = TXEngineModeCruiseControl;
    
    NSString * newSessionUrl = nil;
    NSString * feedUrl = nil;
    if (self.engineMode == TXEngineModeCapture)
    {
//        feedUrl = [NSString stringWithFormat:@"%@/%@", feedServer , @"v"];
        newSessionUrl = [NSString stringWithFormat:@"%@/%@", feedServer, @"v1/feed/xsessions"];
    }
    else if (self.engineMode == TXEngineModeCruiseControl)
    {
        feedUrl = [NSString stringWithFormat:@"%@/%@",playServer, @"v1/play/invocations"];
        newSessionUrl = [NSString stringWithFormat:@"%@/%@", playServer , @"v1/play/xsessions"];
    }
    
    self.feedService.feedServer = feedServer;
    self.feedService.apiToken = apiToken;
    [self.feedService listenToMethodInvocations];
    
    [self.feedService startFreshStudioXSessionToUrl:newSessionUrl withSuccess:^{
        [self doVC:vc];
    } withFailure:^(NSError *error) {
        
        NSAssert(FALSE, @"%s can't start new studio x session %@",__FUNCTION__,error);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vcDetectedWithNotif:) name:NOTIF_VC object:nil];
    
    if (self.engineMode == TXEngineModeCruiseControl)
    {

//        http://localhost:3000/v1/plans/534e3b81019fad09d740bc24
        NSString * planUrl = @"http://localhost:3000/v1/plans/534e3b81019fad09d740bc24/xactions";
        [self.feedService requestXActionsWithURL:planUrl onSuccess:^(NSArray *xactions) {
            
            for (TXAction * xaction in xactions) {
                NSLog(@"xactions:%@",xaction);
                UIWindow * window = [UIApplication sharedApplication].windows.firstObject;
                UIViewController * rootVC = window.rootViewController;
                NSAssert(rootVC, @"no root vc found");
                NSAssert([xaction.invocationMethod isMemberOfClass:[MTMethod class]], @"");
                MTMethod * method = xaction.invocationMethod;
                [method applyTo:rootVC];
                break;
            }
        } onFailure:^(NSError *error) {
            UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"ERROR" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
            NSAssert(FALSE, @"no xactions there");
        }];
        
    }
    
}

-(void)vcDetectedWithNotif:(NSNotification*)notif{
    id obj = notif.object;
    NSAssert([obj isKindOfClass:[UIViewController class]], @"we don't have a vc");
    UIViewController * vc = (UIViewController*)obj;
    [self doVC:vc];
}

-(void)doVC:(UIViewController*)vc{
    
//    NSAssert(vc, @"doVC no vc");
    
    if ([MTMethod isVcClassProcessed:vc.class]) {
        NSLog(@"%@ allready processed",vc.class);
        return;
    } else {
        [MTMethod setVcClassAsProcessed:vc.class];
    }
    
    [self.feedService feedVC:vc onSuccess:^(XFObjcVcClass * vcresp){
        
        NSLog(@"vcresp:%@",vcresp);
        
        NSArray * methods = vcresp.methods;
        
//        NSAssert(methods, @"doVC:'%@' no methods at all", vc.class);
//        NSAssert(methods.count > 0, @"doVC no methods %@",vc.class);
        
        for (MTMethod * method in methods) {
            NSLog(@"doVc: %@, method:%@",[vc class],method);
            if (method.isMonitored) {
//                [method monitorForObject:vc];
            }
        }
        
        NSString * assertMsg = [NSString stringWithFormat:@"TXEngine doVC:%@ no vcresp.properties", [vc class]];
        
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
        
    } onFailure:^(NSError *error) {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"xflow launch failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
        NSAssert(FALSE, @"doVC onFailure: %@",error.localizedDescription);
    }];

    
}



-(UIWindow*)mainWindow{
    return [[UIApplication sharedApplication].windows objectAtIndex:0];
}



@end


