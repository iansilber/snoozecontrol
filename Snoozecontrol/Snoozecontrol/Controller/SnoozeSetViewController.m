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
    self.alarm.date = date;
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

        self.timeSelectController.date = self.alarm.date;
        
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

- (IBAction)sliderChanged:(UISlider *)sender {
    
}

- (IBAction)timeTapped:(UIButton *)sender {
    [self toggleTimeSelect];
}

#pragma mark UIViewController Lifecycle

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
