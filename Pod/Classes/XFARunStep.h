//
//  XFARunStep.h
//  Pods
//
//  Created by Mohammed Tillawy on 2/26/15.
//
//

#import <Mantle/Mantle.h>

@interface XFARunStep : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSArray * invocations;

@end
