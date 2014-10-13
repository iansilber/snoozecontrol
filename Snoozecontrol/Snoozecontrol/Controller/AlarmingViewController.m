//
//  AlarmingViewController.m
//  Snoozecontrol
//
//  Created by Matthew Kuhlke on 10/12/14.
//  Copyright (c) 2014 Silbertown. All rights reserved.
//

#import "AlarmingViewController.h"

@interface AlarmingViewController ()

- (IBAction)closeTapped:(UIButton *)sender;
@end

@implementation AlarmingViewController


- (IBAction)closeTapped:(UIButton *)sender {
    [self.delegate closeClicked:self];
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
