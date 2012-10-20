//
//  HZSectionPickerView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-15.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "BottomPopView.h"


@class HZSectionPickerView;

@protocol HZSectionPickerDelegate <NSObject>

@optional
- (void)sectionPickerDidChange:(HZSectionPickerView*)picker;

@end

@interface HZSectionPickerView : BottomPopView

@property (nonatomic) NSInteger minNum, maxNum, curMinNum, curMaxNum;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) IBOutlet id <HZSectionPickerDelegate> delegate;
-(id)initWithMinNum:(NSInteger)minNum maxNum:(NSInteger)maxNum;

@end
