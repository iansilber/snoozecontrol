//
//  Alarm.h
//  Snoozecontrol
//
//  Created by Matthew Kuhlke on 9/17/14.
//  Copyright (c) 2014 Silbertown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject <NSCoding>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) int snoozeCount;
@property (nonatomic, assign) int snoozeLength;

- (NSString *)firstAlarmTimeString;
- (NSString *)hoursFromNowTimeString;

- (id)initWithDate:(NSDate *)date snoozeCount:(int)count snoozeLength:(int)length enabled:(BOOL)enabled;

+ (id)defaultAlarm;

@end
