//
//  AppDelegate.m
//  Snoozecontrol
//
//  Created by Matthew Kuhlke on 9/17/14.
//  Copyright (c) 2014 Silbertown. All rights reserved.
//

#import "AppDelegate.h"

#import "AlarmManager.h"
#import "SnoozeSetViewController.h"
@import AVFoundation;


@interface AppDelegate ()

@property (nonatomic, strong) NSTimer *base;
@property (strong, nonatomic) AVAudioPlayer *baser;


@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Avenir" size:13.0]];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
//    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
//    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
    NSLog(@"HI");
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"base"
                                                              ofType:@"wav"];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    
    self.baser = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
                                                          error:nil];
    
    [self.baser prepareToPlay];
    self.baser.volume = 0.1;
    self.baser.numberOfLoops = -1;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"resigning Active!");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits
    NSLog(@"resigning Entering background!");

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)startBase {
    
    if (!self.base || !self.base.valid) {
        self.base = [[NSTimer alloc] initWithFireDate:[NSDate date]
                                             interval:5.0
                                               target:self
                                             selector:@selector(doBase)
                                             userInfo:nil
                                              repeats:YES];

        [[NSRunLoop currentRunLoop] addTimer:self.base
                                     forMode:NSDefaultRunLoopMode];
    }
}

- (void)stopBase {
    if (self.base) {
        [self.base invalidate];
        self.base = nil;
    }
}

- (void)doBase {
    [self.baser play];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"resigning terminate!");
    [[AlarmManager sharedManager] disableAlarm];
    [self stopBase];
}

@end
