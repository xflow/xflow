//
//  TXTestViewController.h
//  POC2
//
//  Created by Mohammed Tillawy on 3/11/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXTestViewController : UIViewController


@property (nonatomic, strong) UIButton * button1;
@property (nonatomic, strong) UIButton * button2;

@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) NSString * string;


-(IBAction)actionButton1:(id)sender;
-(IBAction)actionButton2:(id)sender event:(UIEvent*)event;

@end
