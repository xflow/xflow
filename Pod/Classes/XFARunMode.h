//
//  XFARun.h
//  Pods
//
//  Created by Mohammed Tillawy on 1/24/15.
//
//


#import <Mantle/Mantle.h>
#import "XFARunModeValue.h"

@interface XFARunMode : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString * runId;
@property (nonatomic, assign) XFARunModeValue runModeValue;

@end
