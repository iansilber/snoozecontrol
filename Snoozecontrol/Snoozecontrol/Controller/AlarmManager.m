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

#pragma mark - Ugly overriding all setters



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

//Hack for now to work w/ notifications
- (void)updateAlarm {
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if (self.alarm.enabled) {
        
        NSDate *finalAlarmTime = self.alarm.nextAlarm;
        NSDate *now = [NSDate date];
        
        
        for (int i = 0; i<= self.alarm.snoozeCount; i++) {
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.minute = -i * self.alarm.snoozeLength;
            NSDate *alarmTime = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:finalAlarmTime options:0];
            
            NSComparisonResult compare = [alarmTime compare:now];
            if (compare == NSOrderedAscending) {
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                
                int ringCount;
                NSString *notificationBody;
                
                if (i == 0) {
                    ringCount = -1;
                    notificationBody = @"Time to wake up!";
                } else {
                    ringCount = self.alarm.snoozeCount + 1 - i;
                    
                    if (i == 1) {
                        notificationBody = @"Oh man, you only have 1 snooze left!";
                    } else {
                        notificationBody = [NSString stringWithFormat:@"Nudge nuge, you've got %i snoozes left.", i];
                    }
                }
                
                NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: ringCount], @"ringCount", nil];
                
                [localNotification setFireDate:alarmTime];
                [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
                [localNotification setAlertBody: notificationBody];
                [localNotification setAlertAction:@"Open App"];
                [localNotification setHasAction:YES];
                [localNotification setUserInfo:info];
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                NSLog(@"Scheduled Alarm for %@ with %i rings",alarmTime, ringCount);
            } else {
                break;
            }
            
        }
        
        
        
        
    }
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
