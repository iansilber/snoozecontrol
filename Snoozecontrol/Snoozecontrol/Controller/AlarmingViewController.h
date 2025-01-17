//
//  AlarmingViewController.h
//  Snoozecontrol
//
//  Created by Matthew Kuhlke on 10/12/14.
//  Copyright (c) 2014 Silbertown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlarmingViewControllerDelegate;

@interface AlarmingViewController : UIViewController

@property (nonatomic, strong) NSDictionary *alarmInfo;
@property (nonatomic, assign) id<AlarmingViewControllerDelegate> delegate;

@end

@protocol AlarmingViewControllerDelegate <NSObject>
- (void)totallyShutUpClicked:(AlarmingViewController *)viewcontroller;
@end
