//
//  TXEngine.m
//  POC2
//
//  Created by Mohammed Tillawy on 1/2/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "TXEngine.h"

#import "MTSwizzleManager.h"
#import "XFACrawler.h"
#import "XFAStudioAgent.h"
#import "XFAStudioAgentVCResponse.h"
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

@interface TXEngine (){
    
}

@property (nonatomic, strong) UIWindow      * mainWindow;
@property (nonatomic, strong) XFAStudioAgent * studioAgent;
@property (nonatomic, assign) TXEngineMode engineMode;

@end


@implementation TXEngine

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


-(void)on{
    NSLog(@"TXEngine on");
    
    UIViewController * vc = self.mainWindow.rootViewController;
    self.studioAgent = XFAStudioAgent.new;

    self.engineMode = [self figureOutEngineMode];
        
//    self.engineMode = TXEngineModeCruiseControl;
    
    NSString * newSessionUrl = nil;
    NSString * feedUrl = nil;
    if (self.engineMode == TXEngineModeCapture)
    {
        feedUrl = [NSString stringWithFormat:@"http://%@:%@/%@", @"localhost", @"3000", @"v1/feed/invocations"];
        newSessionUrl = [NSString stringWithFormat:@"http://%@:%@/%@", @"localhost", @"3000", @"v1/feed/xsessions"];
    }
    else if (self.engineMode == TXEngineModeCruiseControl)
    {
        feedUrl = [NSString stringWithFormat:@"http://%@:%@/%@", @"localhost", @"3000", @"v1/play/invocations"];
        newSessionUrl = [NSString stringWithFormat:@"http://%@:%@/%@", @"localhost", @"3000", @"v1/play/xsessions"];
    }
    
    self.studioAgent.feedUrl = feedUrl;
    [self.studioAgent listenToMethodInvocations];
    
    [self.studioAgent startFreshStudioXSessionToUrl:newSessionUrl withSuccess:^{
        [self doVC:vc];
    } withFailure:^(NSError *error) {
        NSAssert(FALSE, @"can't start new studio x session ");
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vcDetectedWithNotif:) name:NOTIF_VC object:nil];
    
    if (self.engineMode == TXEngineModeCruiseControl)
    {

//        http://localhost:3000/v1/plans/534e3b81019fad09d740bc24
        NSString * planUrl = @"http://localhost:3000/v1/plans/534e3b81019fad09d740bc24/xactions";
        [self.studioAgent requestXActionsWithURL:planUrl onSuccess:^(NSArray *xactions) {
            
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
    
    
    [self.studioAgent requestForVC:vc onSuccess:^(XFAStudioAgentVCResponse * vcresp){
        
        NSString * childrenKey = vcresp.childrenKey;
        
        NSAssert(childrenKey, @"doVC no childrenKey");

        NSArray * methods = vcresp.methods;
        
        NSAssert(methods, @"doVC no methods at all");
//        NSAssert(methods.count > 0, @"doVC no methods %@",vc.class);
        
        for (MTMethod * method in methods) {
            NSLog(@"doVc: %@, method:%@",[vc class],method);
            if (method.isMonitored) {
                [method monitorForObject:vc];
            }
            
        }
        
        NSString * assertMsg = [NSString stringWithFormat:@"TXEngine doVC:%@ no vcresp.properties",[vc class]];
        
        NSAssert(vcresp.properties, assertMsg);
        
        vc.xfaProperties = NSMutableArray.new;
        
        for (XFAVCProperty * prop in vcresp.properties) {
            [vc.xfaProperties addObject:prop];
        }
        
        NSAssert(vc.xfaProperties, @"TXEngine doVC vc.xfaProperties");
        
        NSArray * childVCs = [vc valueForKey:childrenKey];
        
        
        for (UIViewController * childVc in childVCs) {
            [self doVC:childVc];
        }
//        if (childVCs.count == 0) {}
        
    } onFailure:^(NSError *error) {
        NSAssert(FALSE, @"doVC onFailure: %@",error.localizedDescription);
    }];

//TODO: do something
//    [self loadUI];
    
}



-(UIWindow*)mainWindow{
    return [[UIApplication sharedApplication].windows objectAtIndex:0];
}



@end


