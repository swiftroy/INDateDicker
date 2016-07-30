//
//  ViewController.m
//  INDatePicker
//
//  Created by Prateek Roy on 29/07/16.
//  Copyright © 2016 Prateek Roy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <DateSelectorDelegate>

@property NSDate *selectedDate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.datePickerView.delegate = self;
    [self.datePickerView fillDatesFromDate:NSDate.date numberOfDays:14];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma DateSelectorDelegate

-(void) onSelectedDateChange:(NSDate *)newDate {
    self.selectedDate = newDate;
    self.currentSelectedDate.text = [self getCurrentShortDate:newDate];
}

- (NSString *) getCurrentShortDate:(NSDate *)currentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    return [formatter stringFromDate:currentDate];
    
}

@end
