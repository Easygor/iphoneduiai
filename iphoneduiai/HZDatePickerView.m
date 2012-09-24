//
//  HZDatePickerView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-15.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "HZDatePickerView.h"
#import "NSDate-Utilities.h"

@implementation HZDatePickerView

@synthesize datePicker=_datePicker;
@synthesize delegate=_delegate;

- (void)dealloc
{
    self.delegate = nil;
    [_datePicker release];
    [super dealloc];
}

-(id)initWithDelegate:(id<HZDatePickerDelegate>)delegate
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:1] retain];
    if (self) {
        self.delegate = delegate;
        self.datePicker.maximumDate = [NSDate dateYesterday];
        self.datePicker.date = [NSDate dateWithDaysBeforeNow:24*365];
    }

    return self;
    
}

-(IBAction)pickerChangeStatus:(UIDatePicker*)sender;
{
    if ([self.delegate respondsToSelector:@selector(datePickerDidChangeStatus:withDate:)]) {
        [self.delegate datePickerDidChangeStatus:self withDate:sender.date];
    }
}

@end
