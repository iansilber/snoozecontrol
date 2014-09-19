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
#import "TimeSelectViewController.h"

@interface SnoozeSetViewController ()<TimeSelectViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISlider *countSlider;
@property (weak, nonatomic) IBOutlet UISlider *lengthSlider;

@property (weak, nonatomic) IBOutlet UIButton *alarmTimeButton;
@property (weak, nonatomic) IBOutlet UILabel *firstAlarmText;
@property (weak, nonatomic) IBOutlet UILabel *fromNowText;
@property (weak, nonatomic) IBOutlet UILabel *snoozeCountMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *snoozeCountMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *snoozeLengthMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *snoozeLengthMaxLabel;

@property (nonatomic, strong) Alarm *alarm;
@property (nonatomic, assign) BOOL showingTimeSelect;
@property (nonatomic, strong) TimeSelectViewController *timeSelectController;

- (IBAction)sliderChanged:(UISlider *)sender;
- (IBAction)timeTapped:(UIButton *)sender;

@end

@implementation SnoozeSetViewController

#pragma mark Instance Methods

- (void)timeChanged:(NSDate *)date {
    [self updateAlarmFromDate:date];
    [self updateUIForAlarm];
}

- (void)updateAlarmFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitTimeZone fromDate:date];
    self.alarm.hour = components.hour;
    self.alarm.minute = components.minute;
}

- (void)toggleTimeSelect {
    if (!self.showingTimeSelect) {
        if (!self.timeSelectController) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.timeSelectController = [storyboard instantiateViewControllerWithIdentifier:@"timeSelect"];
            self.timeSelectController.delegate = self;
            
            //Some hacked together UI Code
            //Replace with better more versatile stuff
            int width = self.view.bounds.size.width;
            int height = self.view.bounds.size.height;
            self.timeSelectController.view.alpha = 0;
            
            CGRect frame = CGRectMake(0, height - (height/4), width, height/4);
            [self.timeSelectController willMoveToParentViewController:self];
            [self.timeSelectController.view setFrame:frame];
            [self.view addSubview:self.timeSelectController.view];
            [self.timeSelectController didMoveToParentViewController:self];
        }
        self.showingTimeSelect = YES;

        [self.timeSelectController setDate:[self.alarm dateFromAlarm]];
        
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.timeSelectController.view.alpha = 1;
        } completion:^(BOOL finished) {
            }];
        
    } else {
        if (self.timeSelectController) {
            self.showingTimeSelect = NO;
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.timeSelectController.view.alpha = 0;
            } completion:^(BOOL finished) {
            }];
        }
    }
}

- (void)updateUIForAlarm {
    
    [self.alarmTimeButton setTitle:[self.alarm timeString] forState:UIControlStateNormal];
    
    NSString *hoursFromNow = [self.alarm hoursFromNowTimeString];
    NSString *firstAlarm = [self.alarm firstAlarmTimeString];
    
    NSString *hoursFromNowString = [NSString stringWithFormat:@"%@ from now",hoursFromNow];
    NSString *firstAlarmString = [NSString stringWithFormat:@"First alarm will ring at %@",firstAlarm];

    self.fromNowText.text = hoursFromNowString;
    self.firstAlarmText.text = firstAlarmString;
    
    self.countSlider.value = self.alarm.snoozeCount;
    self.lengthSlider.value = self.alarm.snoozeLength;
}

- (IBAction)sliderChanged:(UISlider *)sender {
    if(sender == self.countSlider) {
        self.alarm.snoozeCount = (int)floor(sender.value);
    } else if (sender == self.lengthSlider) {
        self.alarm.snoozeLength = (int)floor(sender.value);
    }
    [self updateUIForAlarm];
}

- (IBAction)timeTapped:(UIButton *)sender {
    [self toggleTimeSelect];
}

#pragma mark UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.alarm = [[AlarmManager sharedManager] fetchAlarm];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUIForAlarm];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
