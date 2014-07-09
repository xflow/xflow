//
//  TXMethodArgumentValue.h
//  POC2
//
//  Created by Mohammed Tillawy on 4/16/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <Mantle.h>

@interface MTMethodArgumentValue : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) id value;
@property (nonatomic, strong) NSString * objcType;
@property (nonatomic, strong) NSString * argumentType;
@property (nonatomic, assign) BOOL isNil;
@property (nonatomic, strong) NSArray * objectsPath;
@property (nonatomic, strong) NSArray * classesPath;

@end
