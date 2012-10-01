//
//  HZTimePickerView.h
//  iphoneduiai
//
//  Created by yinliping on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "BottomPopView.h"
@class HZTimePickerView;

@protocol HZDegreePickerDatasource <NSObject>

- (NSArray *)timePickerData:(HZTimePickerView *)picker;

@end

@protocol HZTimePickerDelegate <NSObject>

@optional
- (void)timePickerDidChangeStatus:(HZTimePickerView*)picker withNum:(NSString*)num withDesc:(NSString *)desc;

@end


@interface HZTimePickerView : BottomPopView<UIPickerViewDataSource, UIPickerViewDelegate>
@property (assign, nonatomic) id <HZTimePickerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *degreePicker;

-(id)initWithDelegate:(id <HZTimePickerDelegate>)delegate;


@end
