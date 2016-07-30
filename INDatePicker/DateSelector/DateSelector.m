//
//  DateSelector.m
//  Playo
//
//  Created by Prateek Roy on 07/12/15.
//  Copyright © 2015 techmash. All rights reserved.
//

#import "DateSelector.h"

const CGFloat DatepickerItemHeight = 85.;
const CGFloat DatepickerItemWidth = 65;

#define UnSelectedColor         [UIColor greenColor]
#define SelectedColor           [UIColor orangeColor]

@interface DateSelector() <UIScrollViewDelegate> {
    int paddingDate;
    int numDays;
    
    NSMutableArray *viewArray;
    NSMutableArray *labelArray;
    
    NSDateFormatter *dateFormatter;
    
    int selectedIndexPath;
    
}

@property NSDate *selectedDate;
@property NSArray *dates;

@end

@implementation DateSelector

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    dateFormatter = [[NSDateFormatter alloc] init];    
}

- (void)setupDateScrollView
{
    paddingDate = [[UIScreen mainScreen] bounds].size.width/2 - DatepickerItemWidth/2;
    viewArray = [[NSMutableArray alloc] initWithCapacity:numDays];
    labelArray = [[NSMutableArray alloc] initWithCapacity:numDays];
    //self.mainScroll.scrollEnabled = YES;
    
    self.dateSelector.contentInset = UIEdgeInsetsZero;
    self.dateSelector.scrollIndicatorInsets = UIEdgeInsetsZero;
    self.dateSelector.scrollEnabled = YES;
    self.dateSelector.backgroundColor = [UIColor whiteColor];
    self.dateSelector.contentSize = CGSizeMake(DatepickerItemWidth*numDays + 2*paddingDate, DatepickerItemHeight);
    self.dateSelector.showsHorizontalScrollIndicator = NO;
    self.dateSelector.showsVerticalScrollIndicator = NO;
    self.dateSelector.delegate = self;
    
    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    dateTap.cancelsTouchesInView = NO;
    [_dateSelector addGestureRecognizer:dateTap];
}

- (void) setupDateSubview:(NSArray *)dates {
    
    //+++++++++++++++++++++++++++ DATE SUBVIEW ++++++++++++++++++++++++++++
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingDate, DatepickerItemHeight)];
    leftView1.backgroundColor = [UIColor clearColor];
    leftView1.userInteractionEnabled = NO;
    [_dateSelector addSubview:leftView1];
    unsigned i;
    
    
    for(i = 0; i< numDays; i++) {
        UIView *dateView;
        UILabel *dateLabel;
        dateView = [[UIView alloc] initWithFrame:CGRectMake(paddingDate+i*DatepickerItemWidth, 0, DatepickerItemWidth, DatepickerItemHeight)];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 10, DatepickerItemWidth - 6, DatepickerItemHeight - 20)];
        dateLabel.numberOfLines = 3;
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [UIColor whiteColor];
        [dateLabel setBackgroundColor: UnSelectedColor];
        dateLabel.layer.cornerRadius = 2.0f;
        dateLabel.layer.masksToBounds = YES;
        dateLabel.attributedText = [self setDate:dates[i]];
        [dateView addSubview:dateLabel];
        
        dateView.backgroundColor = [UIColor whiteColor];
        dateView.contentMode = UIViewContentModeScaleToFill;
        [_dateSelector addSubview:dateView];
        [labelArray addObject:dateLabel];
        [viewArray addObject:dateView];
    }
    UIView *rightView1 = [[UIView alloc] initWithFrame:CGRectMake(paddingDate+i*DatepickerItemWidth, 0, paddingDate, DatepickerItemHeight)];
    rightView1.backgroundColor = [UIColor clearColor];
    rightView1.userInteractionEnabled = NO;
    [_dateSelector addSubview:rightView1];
    
    //+++++++++++++++++++++++++++ DATE SUBVIEW ++++++++++++++++++++++++++++
    
}


- (void)fillDatesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSAssert([fromDate compare:toDate] == NSOrderedAscending, @"toDate must be after fromDate");
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    NSDateComponents *days = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger dayCount = 0;
    while(YES){
        [days setDay:dayCount++];
        NSDate *date = [calendar dateByAddingComponents:days toDate:fromDate options:0];
        if([date compare:toDate] == NSOrderedDescending) break;
        [dates addObject:date];
    }
    self.dates = dates;
}

- (void)fillDatesFromDate:(NSDate *)fromDate numberOfDays:(NSInteger)numberOfDays
{
    numDays = (int)numberOfDays;
    NSDateComponents *days = [[NSDateComponents alloc] init];
    [days setDay:numberOfDays];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [self fillDatesFromDate:fromDate toDate:[calendar dateByAddingComponents:days toDate:fromDate options:0]];
    [self setupDateScrollView];
    [self setupDateSubview:self.dates];
    self.selectedDate = [self.dates objectAtIndex:0];
    [self animateCellsAtIndex:0];
}


- (NSAttributedString *)setDate:(NSDate *)date
{
    [dateFormatter setDateFormat:@"dd"];
    NSString *dayFormattedString = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"EEE"];
    NSString *dayInWeekFormattedString = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"MMM"];
    NSString *monthFormattedString = [[dateFormatter stringFromDate:date] uppercaseString];
    
    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@\n%@", monthFormattedString, dayFormattedString, [dayInWeekFormattedString uppercaseString]]];
    
    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:14],
                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                } range:NSMakeRange(0, dayFormattedString.length)];
    
    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13],
                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                } range:NSMakeRange(0, dayInWeekFormattedString.length)];
    
    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13],
                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                } range:NSMakeRange(0, monthFormattedString.length)];
    
    
    return dateString;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint location=[gesture locationInView:self.dateSelector];
    location.x = location.x - paddingDate;
    //CGFloat val = fabsf(location.x/(DatepickerItemWidth));
    int index = location.x/DatepickerItemWidth;
    index = (index > 13)? 13:index;
    CGRect frame = CGRectMake((index)*DatepickerItemWidth , 0, [[UIScreen mainScreen] bounds].size.width, DatepickerItemHeight);
    [_dateSelector scrollRectToVisible:frame animated:YES];
    
    if (index != selectedIndexPath) {
        [self animateCellsAtIndex:index];
        if ([self deAnimateCellsAtIndex:selectedIndexPath forindex:index]) {
            selectedIndexPath = index;
        }
        
    }
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _dateSelector) {
        
        CGPoint location = CGPointMake((scrollView.frame.size.width / 2.0) - DatepickerItemWidth/2 , (scrollView.frame.size.height/2.0) + scrollView.contentOffset.y);
        
        location.x += (scrollView.contentOffset.x - paddingDate);
        
        
        CGFloat val = fabs(location.x/(DatepickerItemWidth));
        int index = roundf(val);
        CGRect frame = CGRectMake((index)*DatepickerItemWidth , 0, [[UIScreen mainScreen] bounds].size.width, DatepickerItemHeight);
        [scrollView scrollRectToVisible:frame animated:YES];
        
        
        [self animateCellsAtIndex:index];
        
        if (selectedIndexPath != index) {
            [self deAnimateCellsAtIndex:selectedIndexPath forindex:index];
            selectedIndexPath = index;
        }
    }
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _dateSelector) {
        if (decelerate) {
            return;
        }
        
        CGPoint location = CGPointMake((scrollView.frame.size.width / 2.0) - DatepickerItemWidth/2 , (scrollView.frame.size.height/2.0) + scrollView.contentOffset.y);
        
        location.x += (scrollView.contentOffset.x - paddingDate);
        
        
        CGFloat val = fabsf(location.x/(DatepickerItemWidth));
        int index = roundf(val);
        CGRect frame = CGRectMake((index)*DatepickerItemWidth , 0, [[UIScreen mainScreen] bounds].size.width, DatepickerItemHeight);
        [scrollView scrollRectToVisible:frame animated:YES];
        
        [self animateCellsAtIndex:index];
        
        if (selectedIndexPath != index) {
            [self deAnimateCellsAtIndex:selectedIndexPath forindex:index];
            selectedIndexPath = index;
        }
    }
}

- (BOOL)animateCellsAtIndex:(int)indexPath {
    
    if (indexPath < 0 || indexPath > numDays-1 ) {
        return NO;
    }
    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         UILabel *dateLabel = labelArray[indexPath];
                         UIView *dateView = viewArray[indexPath];
                         dateLabel.frame = CGRectMake(0, 0, dateView.frame.size.width, dateView.frame.size.height);
                         [dateLabel setBackgroundColor:SelectedColor];
                     }
                     completion:^(BOOL finished){
                         NSDate *date = self.dates[indexPath];
                         [self.delegate onSelectedDateChange:date];
                     }];
    
    return YES;
    
}

- (BOOL)deAnimateCellsAtIndex:(int)indexPath forindex:(int) index{
    
    if (indexPath < 0 || indexPath > numDays-1 ) {
        return NO;
    }
    if (index > numDays-1 || index < 0) {
        return NO;
    }
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         UILabel *dateLabel = labelArray[indexPath];
                         
                         dateLabel.frame = CGRectMake(3, 10, DatepickerItemWidth - 6, DatepickerItemHeight - 20);
                         [dateLabel setBackgroundColor:UnSelectedColor];
                     }
                     completion:^(BOOL finished){
                     }];
    
    return YES;
}

@end
