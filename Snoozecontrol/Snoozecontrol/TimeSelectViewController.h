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

@property (nonatomic, assign) id<TimeSelectViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewVerticalSpaceConstraint;

- (void)setDate:(NSDate *)date;

@end


@protocol TimeSelectViewControllerDelegate <NSObject>
@optional
- (void)timeChanged:(NSDate *)date;
- (void)dismissTapped:(TimeSelectViewController *)controller;
@end
