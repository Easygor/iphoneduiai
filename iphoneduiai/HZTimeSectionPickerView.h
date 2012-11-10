//
//  HZTimeSectionPickerView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-11-10.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "BottomPopView.h"

@class HZTimeSectionPickerView;

@protocol HZTimeSectionDelegate <NSObject>


@optional
- (void)timeSectionPickerDidChange:(HZTimeSectionPickerView*)picker;

@end

@interface HZTimeSectionPickerView : BottomPopView


@property (nonatomic) NSInteger minNum, maxNum, curMinNum, curMaxNum;
@property (strong, nonatomic) NSString *curMinDesc, *curMaxDesc;
@property (assign, nonatomic) id <HZTimeSectionDelegate> delegate;

-(id)initTimeSection;

@end
