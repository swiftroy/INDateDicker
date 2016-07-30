//
//  ViewController.h
//  INDatePicker
//
//  Created by Prateek Roy on 29/07/16.
//  Copyright © 2016 Prateek Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateSelector/DateSelector.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet DateSelector *datePickerView;
@property (weak, nonatomic) IBOutlet UILabel *currentSelectedDate;

@end

