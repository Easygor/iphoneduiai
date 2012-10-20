//
//  BottomPopView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-15.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomPopView : UIView
- (void)showInView:(UIView *)view;
- (void)cancelPicker;
- (void)show;
- (void)dismiss;
@end
