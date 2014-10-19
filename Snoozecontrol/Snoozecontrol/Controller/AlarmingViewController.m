//
//  AlarmingViewController.m
//  Snoozecontrol
//
//  Created by Matthew Kuhlke on 10/12/14.
//  Copyright (c) 2014 Silbertown. All rights reserved.
//

#import "AlarmingViewController.h"
@import AVFoundation;


@interface AlarmingViewController ()

@property (assign) SystemSoundID foghornSound;
@property (nonatomic, strong) NSTimer *ringTimer;
@property (nonatomic, assign) int ringCount;


- (IBAction)shutupThisRing:(UIButton *)sender;
- (IBAction)totallyShutupThisAlarm:(UIButton *)sender;

@end

@implementation AlarmingViewController

- (void)setAlarmInfo:(NSDictionary *)alarmInfo {
    _alarmInfo = alarmInfo;
    
    self.ringCount = [(NSNumber *)[alarmInfo objectForKey:@"ringCount"] intValue];
    
    self.ringTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(makeNoise) userInfo:nil repeats:YES];
}

- (IBAction)shutupThisRing:(UIButton *)sender {
    [self.ringTimer invalidate];
    self.ringTimer = nil;
}

- (IBAction)totallyShutupThisAlarm:(UIButton *)sender {
    [self.ringTimer invalidate];
    [self.delegate totallyShutUpClicked:self];
}

- (void)makeNoise {
    NSString *fogPath = [[NSBundle mainBundle]
                            pathForResource:@"foghorn" ofType:@"wav"];
    NSURL *foghornURL = [NSURL fileURLWithPath:fogPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)foghornURL, &_foghornSound);
    
    self.ringCount--;
    
    if (self.ringCount == 0) {
        [self.ringTimer invalidate];
        self.ringTimer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
