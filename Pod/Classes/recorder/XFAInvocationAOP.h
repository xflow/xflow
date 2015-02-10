//
//  XFAInvocationAOP.h
//  Pods
//
//  Created by Mohammed Tillawy on 7/18/14.
//
//

#import <Foundation/Foundation.h>

@protocol AspectToken;
@class XFAMethod;
@class XFAVCProperty;

@interface XFAInvocationAOP : NSObject

-(id<AspectToken>)invoAopPre:(NSObject *)obj method:(XFAMethod*)method;
-(id<AspectToken>)invoAopPost:(NSObject *)obj method:(XFAMethod*)method;
-(void)removeAllHooks;
-(void)observeVC:(UIViewController *)vc property:(XFAVCProperty*)property;

@end
