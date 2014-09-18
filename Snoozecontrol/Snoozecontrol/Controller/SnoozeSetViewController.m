//
//  SnoozeSetViewController.m
//  Snoozecontrol
//
//  Created by Matthew Kuhlke on 9/17/14.
//  Copyright (c) 2014 Silbertown. All rights reserved.
//

#import "SnoozeSetViewController.h"

#import "Alarm.h"
#import "AlarmManager.h"

@interface SnoozeSetViewController ()

@property (weak, nonatomic) IBOutlet UISlider *countSlider;
@property (weak, nonatomic) IBOutlet UISlider *lengthSlider;

@property (weak, nonatomic) IBOutlet UILabel *fromNowText;
@property (weak, nonatomic) IBOutlet UILabel *snoozeCountMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *snoozeCountMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *snoozeLengthMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *snoozeLengthMaxLabel;

- (IBAction)sliderChanged:(UISlider *)sender;
- (IBAction)timeTapped:(UIButton *)sender;

@end

@implementation SnoozeSetViewController

#pragma mark Instance Methods

#pragma mark UIViewController Lifecycle

- (IBAction)sliderChanged:(UISlider *)sender {
    
}

- (IBAction)timeTapped:(UIButton *)sender {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AlarmManager sharedManager] fetchAlarm];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
