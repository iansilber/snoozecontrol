//
//  TimeSelectViewController.h
//  Snoozecontrol
//
//  Created by Matthew Kuhlke on 9/18/14.
//  Copyright (c) 2014 Silbertown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeSelectViewControllerDelegate;


@interface TimeSelectViewController : UIViewController

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, assign) id<TimeSelectViewControllerDelegate> delegate;

@end


@protocol TimeSelectViewControllerDelegate <NSObject>
@optional
- (void)timeChanged:(NSDate *)date;
@end
