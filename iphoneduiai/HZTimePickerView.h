//
//  HZTimePickerView.h
//  iphoneduiai
//
//  Created by yinliping on 12-10-2.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomPopView.h"

@class HZTimePickerView;

@protocol HZTimePickerDelegate <NSObject>

@optional
- (void)timePickerDidChangeStatus:(HZTimePickerView *)picker withDate:(NSDate *)date;

@end


@interface HZTimePickerView : BottomPopView

@property (assign, nonatomic) id <HZTimePickerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (id)initWithDelegate:(id <HZTimePickerDelegate>)delegate;

@end
