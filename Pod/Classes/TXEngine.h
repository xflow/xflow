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

-(void)startWithFeedServer:(NSString*)feedServer withPlayServer:(NSString*)playServer withApiToken:(NSString*)apiToken;

@end


#define Txe ( (TXEngine *) [TXEngine sharedInstance] )


