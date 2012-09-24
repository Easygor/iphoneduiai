//
//  HZDatePickerView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-15.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomPopView.h"

@class HZDatePickerView;

@protocol HZDatePickerDelegate <NSObject>

@optional
- (void)datePickerDidChangeStatus:(HZDatePickerView *)picker withDate:(NSDate *)date;

@end


@interface HZDatePickerView : BottomPopView

@property (assign, nonatomic) id <HZDatePickerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (id)initWithDelegate:(id <HZDatePickerDelegate>)delegate;

@end
