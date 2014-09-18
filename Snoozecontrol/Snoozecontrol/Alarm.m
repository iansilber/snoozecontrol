//
//  Alarm.m
//  Snoozecontrol
//
//  Created by Matthew Kuhlke on 9/17/14.
//  Copyright (c) 2014 Silbertown. All rights reserved.
//

#import "Alarm.h"

@implementation Alarm

#pragma mark NSCoding

#define kDateKey       @"Date"
#define kEnabledKey @"Enabled"
#define kSnoozeCountKey  @"Count"
#define kSnoozeLengthKey @"Length"

- (id)initWithDate:(NSDate *)date snoozeCount:(int)count snoozeLength:(int)length enabled:(BOOL)enabled {
    
    if (self = [super init]) {
        self.date = date;
        self.enabled = enabled;
        self.snoozeCount = count;
        self.snoozeLength = length;
    }
    
    return self;
}


- (void) encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.date forKey:kDateKey];
    [encoder encodeBool:self.enabled forKey:kEnabledKey];
    [encoder encodeInt:self.snoozeLength forKey:kSnoozeLengthKey];
    [encoder encodeInt:self.snoozeCount forKey:kSnoozeCountKey];
}


- (id)initWithCoder:(NSCoder *)decoder {
   
    NSDate *date = [decoder decodeObjectForKey:kDateKey];
    BOOL enabled = [decoder decodeBoolForKey:kEnabledKey];
    int snoozeCount = [decoder decodeIntForKey:kSnoozeCountKey];
    int snoozeLength = [decoder decodeIntForKey:kSnoozeLengthKey];
    
    return [self initWithDate:date snoozeCount:snoozeCount snoozeLength:snoozeLength enabled:enabled];
}

@end
