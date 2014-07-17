//
//  MTViewController.h
//  Contexter
//
//  Created by Mohammed Tillawy on 11/6/13.
//  Copyright (c) 2013 Mohammed Tillawy. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface XFAViewController : UIViewController


@property (nonatomic,weak) IBOutlet UILabel *labelConnected;
@property (nonatomic,weak) IBOutlet UILabel *labelCustomConnected;
@property (nonatomic,weak) IBOutlet UILabel *labelNotConnected;
@property (nonatomic,strong) UILabel *labelNil;
@property (nonatomic,weak) IBOutlet UILabel *labelNilAlways;

@property (nonatomic,weak) IBOutlet UIButton *buttonConnected;
@property (nonatomic,weak) IBOutlet UIButton *buttonCustomConnected;
@property (nonatomic,weak) IBOutlet UIButton *buttonNotConnected;

@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentedControlWithAction;
@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentedControlNoAction;

@property (nonatomic,weak) IBOutlet UIProgressView *progressView;

@property (nonatomic,weak) IBOutlet UISlider *sliderWithAction;
@property (nonatomic,weak) IBOutlet UISlider *sliderNoAction;

@property (nonatomic,weak) IBOutlet UISwitch * switchWithAction;
@property (nonatomic,weak) IBOutlet UISwitch * switchNoAction;

@property (nonatomic,weak) IBOutlet UITextField *textFieldNoDelegate;
@property (nonatomic,weak) IBOutlet UITextField *textFieldConnectedDelegate;

@property (nonatomic,weak) IBOutlet UITextView *textViewNoDelegate;
@property (nonatomic,weak) IBOutlet UITextView *textViewConnectedDelegate;


- (IBAction)actionSwitch:(id)sender;

- (IBAction)actionSlider:(id)sender;

-(IBAction)actionButton:(id)sender event:(UIEvent*)event;

-(void)dislayText;

@end
