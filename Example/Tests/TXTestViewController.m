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
        self.string1 = @"TEXT1";
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];


    
    self.button1 = UIButton.new;
    self.button1.tag = 1;
    [self.button1 addTarget:self
                    action:@selector(actionButton1:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button1];
    
    
    self.button2 = UIButton.new;
    self.button2.tag = 2;
    [self.button2 addTarget:self
                     action:@selector(actionButton2:event:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button2];
    
    self.button3 = UIButton.new;
    self.button3.tag = 3;
    [self.button3 addTarget:self
                     action:@selector(actionButton3:event:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button3];
    
}

-(IBAction)actionButton2:(id)sender event:(UIEvent*)event{
    NSLog(@"event:%@",event);
    NSAssert(sender, @"no sender");
    NSAssert([sender isEqual:self.button2], @"expected button2 !");
    _string2 = self.string1;
}

-(IBAction)actionButton1:(id)sender
{
    NSAssert(sender, @"no sender");
    NSAssert([sender isEqual:self.button1], @"expected  button1 not %@",sender);
    _string2 = self.string1;
}

-(IBAction)actionButton3:(id)sender event:(UIEvent*)event{
    NSAssert(sender, @"no sender");
    NSAssert([sender isEqual:self.button3], @"expected  button3");
    UIButton * btn = sender;
    _lastTag = btn.tag;
}

@end
