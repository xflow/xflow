//
//  TXTestViewController.m
//  POC2
//
//  Created by Mohammed Tillawy on 3/11/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "TXTestViewController.h"

@implementation TXTestViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.string = @"TEXT1";
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.label = UILabel.new;
    self.label.text = self.string;
    
    self.button1 = UIButton.new;
    [self.button1 addTarget:self
                    action:@selector(actionButton1:)
           forControlEvents:UIControlEventTouchUpInside];
    
    self.button2 = UIButton.new;
    [self.button2 addTarget:self
                     action:@selector(actionButton2:event:)
           forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)actionButton2:(id)sender event:(UIEvent*)event{
    NSLog(@"event:%@",event);
    self.label.text = self.string;
}

-(IBAction)actionButton1:(id)sender
{
    self.label.text = self.string;
}

@end
