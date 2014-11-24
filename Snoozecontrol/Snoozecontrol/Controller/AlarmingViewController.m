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

@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (nonatomic, strong) NSTimer *ringTimer;
@property (nonatomic, assign) int ringCount;
@property (weak, nonatomic) IBOutlet UIButton *wordButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wordButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wordButtonLeftConstraint;
@property (nonatomic, strong) NSString *phrase;
@property (nonatomic, assign) int wordIndex;


- (IBAction)shutupThisRing:(UIButton *)sender;
- (IBAction)totallyShutupThisAlarm:(UIButton *)sender;

@end

@implementation AlarmingViewController

- (void)setAlarmInfo:(NSDictionary *)alarmInfo {
    NSLog(@"setting alarm info");

    _alarmInfo = alarmInfo;

    [self.ringTimer invalidate];
    self.ringTimer = nil;
    self.ringCount = [(NSNumber *)[alarmInfo objectForKey:@"ringCount"] intValue];
    [self.backgroundMusicPlayer prepareToPlay];
    self.ringTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(makeNoise) userInfo:nil repeats:YES];
}

- (IBAction)shutupThisRing:(UIButton *)sender {
    [self.ringTimer invalidate];
    self.ringTimer = nil;
}

- (IBAction)nextWord:(id)sender {
    [self randomizeWordLocation];
}

- (void)randomizeWordLocation {
    
    NSArray *words = [self.phrase componentsSeparatedByString:@" "];
    
    if (self.wordIndex == words.count) {
        self.wordIndex = 0;
        [self totallyShutupThisAlarm];
    } else {
        
        [self.wordButton setTitle:words[self.wordIndex] forState:UIControlStateNormal];

        CGRect screenRect = [[UIScreen mainScreen] bounds];
        self.wordButtonLeftConstraint.constant = (rand() % ((int)screenRect.size.width - 120)) + 60;
        self.wordButtonTopConstraint.constant = (rand() % ((int)screenRect.size.height - 240)) + 120;
        
        
        [UIView animateWithDuration:.2 animations:^{
            [self.view layoutIfNeeded];
        }];
        self.wordIndex++;
        
    }
    
}

- (void)totallyShutupThisAlarm {
    [self.ringTimer invalidate];
    [self.delegate totallyShutUpClicked:self];
}

- (void)makeNoise {
    NSLog(@"trying to make noise");

    [self.backgroundMusicPlayer play];
    NSLog(@"noising at ring count %i", self.ringCount);
    self.ringCount--;
    
    if (self.ringCount == 0) {
        [self.ringTimer invalidate];
        self.ringTimer = nil;
    } else {
        [self.backgroundMusicPlayer prepareToPlay];
    }
}


- (void)configureAudioPlayer {
    // Create audio player with background music
    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"foghorn" ofType:@"wav"];
    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
    self.backgroundMusicPlayer.numberOfLoops = 0;	// Negative number means loop forever
    self.backgroundMusicPlayer.volume = 1;
}

- (void)viewDidLoad {
    [self.wordButton setTitle:@"" forState:UIControlStateNormal];
    self.phrase = @"Today is going to be great";
    self.wordIndex = 0;
    [super viewDidLoad];
    [self configureAudioPlayer];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [self randomizeWordLocation];
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
