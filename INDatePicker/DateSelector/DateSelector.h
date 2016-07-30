//
//  DateSelector.h
//  Playo
//
//  Created by Prateek Roy on 07/12/15.
//  Copyright © 2015 techmash. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateSelectorDelegate

@optional
- (void)onSelectedDateChange:(NSDate *)selectedDate;
@end


@interface DateSelector : UIView
@property (nonatomic, assign) id<DateSelectorDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *dateSelector;

- (void)fillDatesFromDate:(NSDate *)fromDate numberOfDays:(NSInteger)numberOfDays;

@end
