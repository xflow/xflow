//
//  XFARun.h
//  Pods
//
//  Created by Mohammed Tillawy on 1/24/15.
//
//

typedef NS_ENUM(NSInteger, XFARunMode) {
    XFARunModeUnknown         = 0,
    XFARunModeOff             = 1,
    XFARunModeCapture         = 2,
    XFARunModeCruiseControl   = 3,
    XFARunModeTest            = 4
};

#import <Mantle/Mantle.h>

@interface XFARun : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString * runId;
@property (nonatomic, assign) XFARunMode runMode;

@end
