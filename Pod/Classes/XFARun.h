//
//  XFARun.h
//  Pods
//
//  Created by Mohammed Tillawy on 2/23/15.
//
//

#import <Mantle/Mantle.h>

@interface XFARun : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSArray * steps;

@property (nonatomic, strong) NSNumber * portalProjectId;
@property (nonatomic, strong) NSNumber * portalUserId;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSNumber * isActive;
@property (nonatomic, strong) NSNumber * isKept;

@end
