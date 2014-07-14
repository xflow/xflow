//
//  xflowappTests.m
//  xflowappTests
//
//  Created by Mohammed O. Tillawy on 07/07/2014.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

SPEC_BEGIN(InitialTests)

describe(@"My initial tests", ^{

  context(@"will fail", ^{

      it(@"can do maths", ^{
          [[theValue(1) should] equal:theValue(1)];
      });

      it(@"can read", ^{
          [[@"string" should] equal:@"string"];
      });
    
      it(@"will wait and fail", ^{
          NSObject *object = [[NSObject alloc] init];
          [[object shouldEventually] receive:@selector(autoContentAccessingProxy)];
          [object autoContentAccessingProxy];
      });
  });

  context(@"will pass", ^{
    
      it(@"can do maths", ^{
        [[theValue(1) should] beLessThan:theValue(23)];
      });
    
      it(@"can read", ^{
          [[@"team" shouldNot] containString:@"I"];
      });  
  });
  
});

SPEC_END
