//
//  MTDummy1VC.m
//  POCHostClient
//
//  Created by Mohammed Tillawy on 1/9/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFADummy1VC.h"
#import "XFADummy2VC.h"

@implementation XFADummy1VC

-(IBAction)actionHelloDummy1:(id)sender{
    self.labelDummy1.text = @"DUMMMMMY";
    [self.buttonDummy1 setTitle:@"HEHEHEHEHE" forState:UIControlStateNormal];
}

-(IBAction)actionModal:(id)sender{
    XFADummy2VC * vc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MTDummy2VC"];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}
@end
