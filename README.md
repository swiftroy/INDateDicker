# INDateDicker
A lightweight, scrollable, fully customizable DatePicker

#SETUP

1. Copy the "INDatePicker" folder to your project.
2. Create a class property with just a line of code to your ViewCOntroller

   @property (weak, nonatomic) IBOutlet DateSelector *datePickerView;
   
3. Call function to fill the dates

   - (void)fillDatesFromDate:(NSDate *)fromDate numberOfDays:(NSInteger)numberOfDays;
   
4. Set the delegate in ViewController
   
   self.dateSelectorView.delegate = self

5. Use the delegate's method to interact with your view controller

   -(void) onSelectedDateChange:(NSDate *)newDate {
        // Do something when the user selects new date
   }
   



