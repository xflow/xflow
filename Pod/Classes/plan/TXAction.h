//
//  TXAction.h
//  POC2
//
//  Created by Mohammed Tillawy on 3/1/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>
/*
 var dic = {
    objectsPath:[String],
    classesPath:[String],
    objHash: String,
    propertyStates: [propertyStateSchme],
    invocationMethod: methodSchema
 };
 */

@class MTMethod;

@interface TXAction : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSArray * objectsPath;
@property (nonatomic, strong) NSArray * classesPath;
@property (nonatomic, strong) NSString * objHash;

// propertyStates: [propertyStateSchme],

@property (nonatomic, strong) MTMethod * invocationMethod;


@end


