//
//  HZNumberPickerView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-16.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "BottomPopView.h"

@class HZNumberPickerView;

@protocol HZNumberPickerDelegate <NSObject>

@optional
- (void)numberPickerDidChange:(HZNumberPickerView*)picker;

@end

@interface HZNumberPickerView : BottomPopView

@property (nonatomic) NSInteger minNum, maxNum, curNum;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) IBOutlet id <HZNumberPickerDelegate> delegate;
-(id)initWithMinNum:(NSInteger)minNum maxNum:(NSInteger)maxNum;

@end
