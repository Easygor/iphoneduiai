//
//  HZPopPickerView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-15.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "BottomPopView.h"

@class HZPopPickerView;

@protocol HZPopPickerDatasource <NSObject>

- (NSArray *)popPickerData:(HZPopPickerView *)picker;
- (NSString *)titleForPopPicker:(HZPopPickerView *)picker;

@end

@protocol HZPopPickerDelegate <NSObject>

@optional
- (void)popPickerDidChangeStatus:(HZPopPickerView*)picker withLabel:(NSString*)label withDesc:(NSString *)desc;

@end

@interface HZPopPickerView : BottomPopView <UIPickerViewDataSource, UIPickerViewDelegate>
@property (assign, nonatomic) id <HZPopPickerDelegate> delegate;
@property (assign, nonatomic) id <HZPopPickerDatasource> dataSource;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

-(id)initWithDelegate:(id)delegate;

@end

