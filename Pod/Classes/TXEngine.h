//
//  TXEngine.h
//  POC2
//
//  Created by Mohammed Tillawy on 1/2/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXEngine : NSObject

+(instancetype)sharedInstance;

-(void)on;

@end


#define Txe ( (TXEngine *) [TXEngine sharedInstance] )


