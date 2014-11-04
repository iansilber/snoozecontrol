//
//  AlarmManager.h
//  Snoozecontrol
//
//  Created by Matthew Kuhlke on 9/17/14.
//  Copyright (c) 2014 Silbertown. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Alarm;

@interface AlarmManager : NSObject

- (Alarm *)fetchAlarm;
- (void)saveAlarm:(Alarm *)alarm;
- (void)saveState;

+ (AlarmManager *)sharedManager;

//Hack for now to work w/ notifications
- (void)updateAlarm;

- (void)disableAlarm;

@end
