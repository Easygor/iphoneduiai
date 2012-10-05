//
//  SliderView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-4.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderDataSource <NSObject>

- (int)numberOfPages;
- (UIView *)viewAtIndex:(int)index;

@end

@interface SliderView : UIView <UIScrollViewDelegate>
{
	UIScrollView *scrollView;
	UIPageControl *pageControl;
	
	// To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
}

@property (nonatomic, assign) IBOutlet id<SliderDataSource> dataSource;

@property (strong, nonatomic) UIPageControl *pageControl;
- (IBAction)changePage:(id)sender;
- (IBAction)changePageCycle:(id)sender;
- (void)selectPageAtIndex:(NSInteger)index;

- (id)initWithFrame:(CGRect)frame withDataSource:(id<SliderDataSource>)_dataSource;

@end
