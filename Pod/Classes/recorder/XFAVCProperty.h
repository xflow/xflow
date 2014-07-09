//
//  XFAVCProperty.h
//  POC2
//
//  Created by Mohammed Tillawy on 3/17/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <Mantle.h>

@interface XFAVCProperty : MTLModel <MTLJSONSerializing>

@property(nonatomic,strong) NSString * propertyName;

@property(nonatomic,strong) NSString * propertyObjcType;

@property(nonatomic,strong) NSString * propertyObjcClassName;

@property(nonatomic,assign) BOOL propertyIsNil;

-(NSDictionary *)loadValuesFromVC:(UIViewController*)vc;

@end
