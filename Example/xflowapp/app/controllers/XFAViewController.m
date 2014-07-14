//
//  MTViewController.m
//  Contexter
//
//  Created by Mohammed Tillawy on 11/6/13.
//  Copyright (c) 2013 Mohammed Tillawy. All rights reserved.
//

#import "XFAViewController.h"
#import <TXEngine.h>
@interface XFAViewController ()

@end

@implementation XFAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"MTViewController viewDidLoad");
    self.labelConnected.text = @"AAAAA";
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"MTViewController viewDidAppear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionSwitch:(id)sender {
    NSLog(@"MTViewController actionSwitch");
}


- (IBAction)actionSlider:(id)sender {
    NSLog(@"MTViewController actionSlider");
}

- (IBAction)actionButton:(id)sender {
    NSLog(@"MTViewController actionButton %@",sender);
    self.labelConnected.text = @"BBBBBB";

    self.labelNil = UILabel.new;
    self.labelNil.backgroundColor = [UIColor blueColor];
    self.labelNil.frame = CGRectMake(100, 100, 50, 50);
    [self.view addSubview:self.labelNil];
    self.labelNil.text = @"HIHIHIH";
    
    [self displayText];
    NSLog(@"MTViewController isFirstResponder:%d",self.isFirstResponder);
}

-(void)displayText{
    self.labelConnected.text = @"CCCCCC";
    [self displayText2];
}

-(void)displayText2{
    self.labelConnected.text = @"NNNNNN";
    [self displayText3];
}


-(void)displayText3{
    self.labelConnected.text = @"MMMMM";
}

@end
