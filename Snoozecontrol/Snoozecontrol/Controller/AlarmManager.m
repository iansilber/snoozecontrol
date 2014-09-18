//
//  AlarmManager.m
//  Snoozecontrol
//
//  Created by Matthew Kuhlke on 9/17/14.
//  Copyright (c) 2014 Silbertown. All rights reserved.
//

#import "AlarmManager.h"
#import "AppDelegate.h"

#import "Alarm.h"

@interface AlarmManager()

@property (nonatomic, strong) Alarm *alarm;

@end

@implementation AlarmManager

#pragma mark - Initializers

- (id)init {
    
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    return self;
}



#pragma mark - Instance Methods
- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingString:@"/archive"];
}

- (Alarm *)fetchAlarm {
    Alarm * alarm = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
    
    if (alarm) {
        self.alarm = alarm;
    } else {
        self.alarm = [Alarm defaultAlarm];
    }
    
    return self.alarm;
}

- (void)saveAlarm:(Alarm *)alarm {
    [NSKeyedArchiver archiveRootObject:self.alarm toFile:[self filePath]];
}

- (void)saveState {
    [self saveAlarm:self.alarm];
}

#pragma mark - Singleton Pattern

+ (AlarmManager *)sharedManager {
    static dispatch_once_t once;
    static AlarmManager * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
