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

@property (strong, nonatomic) AVAudioSession *audioSession;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
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
    [self.backgroundMusicPlayer play];
    self.ringCount--;
    
    if (self.ringCount == 0) {
        [self.ringTimer invalidate];
        self.ringTimer = nil;
    }
}

- (void) configureAudioSession {
    // Implicit initialization of audio session
    self.audioSession = [AVAudioSession sharedInstance];
    
    // Set category of audio session
    // See handy chart on pg. 46 of the Audio Session Programming Guide for what the categories mean
    // Not absolutely required in this example, but good to get into the habit of doing
    // See pg. 10 of Audio Session Programming Guide for "Why a Default Session Usually Isn't What You Want"
    
    NSError *setCategoryError = nil;
    if ([self.audioSession isOtherAudioPlaying]) { // mix sound effects with music already playing
        [self.audioSession setCategory:AVAudioSessionCategorySoloAmbient error:&setCategoryError];
    } else {
        [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    }
    if (setCategoryError) {
        NSLog(@"Error setting category! %ld", (long)[setCategoryError code]);
    }
}

- (void)configureAudioPlayer {
    // Create audio player with background music
    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"foghorn" ofType:@"wav"];
    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
    self.backgroundMusicPlayer.numberOfLoops = 0;	// Negative number means loop forever
    [self.backgroundMusicPlayer prepareToPlay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureAudioSession];
    [self configureAudioPlayer];
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
