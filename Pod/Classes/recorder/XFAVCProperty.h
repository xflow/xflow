//
//  XFAVCProperty.h
//  POC2
//
//  Created by Mohammed Tillawy on 3/17/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <Mantle.h>
#import <xflowparser/XFPObjcProperty.h>
@interface XFAVCProperty : XFPObjcProperty

-(NSDictionary *)loadValuesFromVC:(UIViewController*)vc;

@end
