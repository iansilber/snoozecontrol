//
//  Alarm.m
//  Snoozecontrol
//
//  Created by Matthew Kuhlke on 9/17/14.
//  Copyright (c) 2014 Silbertown. All rights reserved.
//

#import "Alarm.h"

@interface Alarm()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation Alarm

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return _dateFormatter;
}

#pragma mark NSCoding

#define kDateKey       @"Date"
#define kEnabledKey @"Enabled"
#define kHourKey @"Hour"
#define kMinuteKey @"Minute"
#define kSnoozeCountKey  @"Count"
#define kSnoozeLengthKey @"Length"

- (NSDate *)dateWithAlarmComponents {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:self.hour];
    [comps setMinute:self.minute];
    [comps setTimeZone:[NSTimeZone localTimeZone]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateFromComponents:comps];
}

- (NSString *)timeString {
    return [self.dateFormatter stringFromDate:[self dateWithAlarmComponents]];
}

- (NSString *)firstAlarmTimeString {
    return @"";
}

- (NSString *)hoursFromNowTimeString {
    
//    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
//    NSDateComponents *components = [gregorianCalendar components:unitFlags
//                                                        fromDate:self.date
//                                                          toDate:[NSDate new]
//                                                         options:0];
//    
//    return [NSString stringWithFormat:@"%li:%02li", components.hour, (long)components.minute];
    return @"";
}

- (id)initWithHour:(NSInteger)hour minute:(NSInteger)minute snoozeCount:(int)count snoozeLength:(int)length enabled:(BOOL)enabled {
    
    if (self = [super init]) {
        self.hour = hour;
        self.minute = minute;
        self.enabled = enabled;
        self.snoozeCount = count;
        self.snoozeLength = length;
    }
    
    return self;
}


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeBool:self.enabled forKey:kEnabledKey];
    [encoder encodeInteger:self.hour forKey:kHourKey];
    [encoder encodeInteger:self.minute forKey:kMinuteKey];
    [encoder encodeInt:self.snoozeLength forKey:kSnoozeLengthKey];
    [encoder encodeInt:self.snoozeCount forKey:kSnoozeCountKey];
}


- (id)initWithCoder:(NSCoder *)decoder {
   
    NSInteger hour = [decoder decodeIntegerForKey:kHourKey];
    NSInteger minute = [decoder decodeIntegerForKey:kMinuteKey];
    BOOL enabled = [decoder decodeBoolForKey:kEnabledKey];
    int snoozeCount = [decoder decodeIntForKey:kSnoozeCountKey];
    int snoozeLength = [decoder decodeIntForKey:kSnoozeLengthKey];
    
    return [self initWithHour:hour minute:minute snoozeCount:snoozeCount snoozeLength:snoozeLength enabled:enabled];
}


#pragma mark Class Methods

+ (id)defaultAlarm {
    return [[Alarm alloc] initWithHour:8 minute:0 snoozeCount:3 snoozeLength:5 enabled:NO];
}


@end
