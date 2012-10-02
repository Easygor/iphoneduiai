//
//  HZTimePickerView.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-2.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//


#import "HZTimePickerView.h"
#import "NSDate-Utilities.h"

@implementation HZTimePickerView

@synthesize datePicker=_datePicker;
@synthesize delegate=_delegate;

- (void)dealloc
{
    self.delegate = nil;
    [_datePicker release];
    [super dealloc];
}

-(id)initWithDelegate:(id<HZTimePickerDelegate>)delegate
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
        [self.delegate timePickerDidChangeStatus:self withDate:sender.date];
    }
}
#pragma mark - PickerView lifecycle

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}
@end
