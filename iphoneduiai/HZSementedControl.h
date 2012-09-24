//
//  HZSementedControl.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-10.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZSementedControl;

@protocol HZSementdControlDelegate <NSObject>

@optional

-(void)didChange:(HZSementedControl *)segment atIndex:(NSInteger)index forValue:(NSString *)text;

@end

@interface HZSementedControl : UIView

@property (assign, nonatomic) IBOutlet id <HZSementdControlDelegate> delegate;

- (void)selectSegmentAtIndex:(NSInteger)index;

@end
