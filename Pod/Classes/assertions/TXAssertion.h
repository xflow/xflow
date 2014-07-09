//
//  TXAssertion.h
//  POC2
//
//  Created by Mohammed Tillawy on 4/16/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <Mantle.h>

@interface TXAssertion : MTLModel <MTLJSONSerializing>

@property (nonatomic,strong) NSString * assertionType;       // type: "not_nil",
@property (nonatomic,strong) NSString * assertionSeverity;   // severity: "feed-breaker"

@property (nonatomic,assign) NSInteger assertionIndex;
@property (nonatomic,strong) NSNumber * assertionValue;
@property (nonatomic,assign) NSInteger assertionLevel;

@property (nonatomic,strong) NSString * message;

@property (nonatomic,assign) BOOL failed;

-(void)evaluate:(NSValue*)value;

-(void)reportFailure;

@end
