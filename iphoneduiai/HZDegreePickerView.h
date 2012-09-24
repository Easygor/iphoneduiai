//
//  HZDegreePickerView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-15.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "BottomPopView.h"

@class HZDegreePickerView;

@protocol HZDegreePickerDatasource <NSObject>

- (NSArray *)degreePickerData:(HZDegreePickerView *)picker;

@end

@protocol HZDegreePickerDelegate <NSObject>

@optional
- (void)dgreePickerDidChangeStatus:(HZDegreePickerView*)picker withNum:(NSString*)num withDesc:(NSString *)desc;

@end

@interface HZDegreePickerView : BottomPopView <UIPickerViewDataSource, UIPickerViewDelegate>
@property (assign, nonatomic) id <HZDegreePickerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *degreePicker;

-(id)initWithDelegate:(id <HZDegreePickerDelegate>)delegate;
@end
