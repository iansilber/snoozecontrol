//
//  SnoozeSetViewController.m
//  Snoozecontrol
//
//  Created by Matthew Kuhlke on 9/17/14.
//  Copyright (c) 2014 Silbertown. All rights reserved.
//

#import "SnoozeSetViewController.h"

#import "Alarm.h"
#import "AlarmingViewController.h"
#import "AlarmManager.h"
#import "TimeSelectViewController.h"

@interface SnoozeSetViewController ()<AlarmingViewControllerDelegate, TimeSelectViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIStepper *countStepper;
@property (weak, nonatomic) IBOutlet UIStepper *lengthStepper;

@property (weak, nonatomic) IBOutlet UIButton *alarmTimeButton;
@property (weak, nonatomic) IBOutlet UILabel *firstAlarmText;
@property (weak, nonatomic) IBOutlet UILabel *fromNowText;
@property (weak, nonatomic) IBOutlet UISwitch *onOffSwitch;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;

@property (weak, nonatomic) IBOutlet UILabel *countTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthTitleLabel;

@property (nonatomic, strong) Alarm *alarm;
@property (nonatomic, strong) AlarmingViewController* alarmingVC;
@property (nonatomic, assign) BOOL showingTimeSelect;
@property (nonatomic, strong) TimeSelectViewController *timeSelectController;

- (IBAction)onOffSwitched:(UISwitch *)sender;
- (IBAction)timeTapped:(UIButton *)sender;
- (IBAction)stepperChanged:(id)sender;

@end

@implementation SnoozeSetViewController

#pragma mark Instance Methods

- (void)updateAlarmFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitTimeZone fromDate:date];
    self.alarm.hour = components.hour;
    self.alarm.minute = components.minute;
    [[AlarmManager sharedManager] updateAlarm];
}

- (void) showTimeSelector
{
    if (!self.showingTimeSelect) {
        
        if (!self.timeSelectController) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.timeSelectController = [storyboard instantiateViewControllerWithIdentifier:@"timeSelect"];
            self.timeSelectController.delegate = self;
            
        }
        [self addChildViewController:self.timeSelectController];
        [self.view addSubview:self.timeSelectController.view];
        [self.timeSelectController didMoveToParentViewController:self];
        
        self.timeSelectController.view.alpha = 0;
        self.timeSelectController.pickerViewVerticalSpaceConstraint.constant = -250;
        [self.view layoutIfNeeded];
        
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.timeSelectController.view.alpha = 1;
            self.timeSelectController.pickerViewVerticalSpaceConstraint.constant = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished) {
                self.showingTimeSelect = YES;
            }
        }];
    }
}

- (void) hideTimeSelector
{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.timeSelectController.view.alpha = 0;
        self.timeSelectController.pickerViewVerticalSpaceConstraint.constant = -250;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.timeSelectController willMoveToParentViewController:nil];
            [self.timeSelectController.view removeFromSuperview];
            [self.timeSelectController removeFromParentViewController];
            self.showingTimeSelect = NO;
        }
    }];
}

- (void)updateUIForAlarm {
    
    [self.alarmTimeButton setTitle:[self.alarm timeString] forState:UIControlStateNormal];
    
    NSString *hoursFromNow = [self.alarm hoursFromNowTimeString];
    NSString *firstAlarm = [self.alarm firstAlarmTimeString];
    
    NSString *hoursFromNowString = [NSString stringWithFormat:@"%@ from now",hoursFromNow];
    NSString *firstAlarmString = [NSString stringWithFormat:@"First alarm will ring at %@",firstAlarm];

    self.fromNowText.text = hoursFromNowString;
    self.firstAlarmText.text = firstAlarmString;
    
    self.countLabel.text = [NSString stringWithFormat:@"%d", self.alarm.snoozeCount];
    self.lengthLabel.text = [NSString stringWithFormat:@":%02d", self.alarm.snoozeLength];
    self.countStepper.value = self.alarm.snoozeCount;
    self.lengthStepper.value = self.alarm.snoozeLength;

    self.onOffSwitch.on = self.alarm.enabled;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (self.alarm.enabled) {
            self.alarmTimeButton.alpha = 1.0;
            self.countLabel.alpha = 1.0;
            self.lengthLabel.alpha = 1.0;
            self.countTitleLabel.alpha = 1.0;
            self.lengthTitleLabel.alpha = 1.0;
            self.firstAlarmText.alpha = 1.0;
        } else {
            self.alarmTimeButton.alpha = 0.3;
            self.countLabel.alpha = 0.3;
            self.lengthLabel.alpha = 0.3;
            self.countTitleLabel.alpha = 0.3;
            self.lengthTitleLabel.alpha = 0.3;
            self.firstAlarmText.alpha = 0.3;
            
        }

    }];
}

- (IBAction)onOffSwitched:(UISwitch *)sender {
    self.alarm.enabled = sender.on;
    [[AlarmManager sharedManager] updateAlarm];
    [self updateUIForAlarm];
}

- (IBAction)timeTapped:(UIButton *)sender {
    [self showTimeSelector];
}

- (IBAction)stepperChanged:(UIStepper *)sender {
    if (sender == self.countStepper) {
        self.alarm.snoozeCount = (int)sender.value;
    } else if (sender == self.lengthStepper) {
        self.alarm.snoozeLength = (int)sender.value;
    }
    [[AlarmManager sharedManager] updateAlarm];
    [self updateUIForAlarm];
}

- (void)startAlarming:(NSNotification *)notification {
    NSLog(@"snooze set start Alarming");

    if (!self.alarmingVC) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.alarmingVC  = [storyboard instantiateViewControllerWithIdentifier:@"alarmingVC"];
        self.alarmingVC.modalPresentationStyle = UIModalPresentationFullScreen;
        self.alarmingVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.alarmingVC.delegate = self;
    }
    self.alarmingVC.alarmInfo = notification.userInfo;
    if (!self.alarmingVC.presentingViewController) {
        [self presentViewController:self.alarmingVC animated:YES completion:nil];
    }
}

#pragma mark AlarmingViewControllerDelegate

- (void)totallyShutUpClicked:(AlarmingViewController *)viewcontroller {
    self.alarm.enabled = NO;
    [[AlarmManager sharedManager] updateAlarm];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TimeSelectViewControllerDelegate


- (void)timeChanged:(NSDate *)date {
    [self updateAlarmFromDate:date];
    [self updateUIForAlarm];
}

- (void)dismissTapped:(TimeSelectViewController *)controller {
    [self hideTimeSelector];
}

#pragma mark UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.alarm = [[AlarmManager sharedManager] fetchAlarm];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAlarming:) name:@"sctime" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.countStepper.tintColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    self.lengthStepper.tintColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    [self updateUIForAlarm];
    [[AlarmManager sharedManager] updateAlarm];
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
