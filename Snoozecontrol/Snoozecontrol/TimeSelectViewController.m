//
//  TimeSelectViewController.m
//  Snoozecontrol
//
//  Created by Matthew Kuhlke on 9/18/14.
//  Copyright (c) 2014 Silbertown. All rights reserved.
//

#import "TimeSelectViewController.h"

@interface TimeSelectViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)dateChanged:(id)sender;

@end

@implementation TimeSelectViewController

#pragma mark Instance Methods

- (IBAction)dateChanged:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(timeChanged:)]) {
        [self.delegate timeChanged:self.datePicker.date];
    }
}

- (void)setDate:(NSDate *)date {
    self.datePicker.date = date;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
