//
//  SliderView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-4.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "SliderView.h"

@interface SliderView ()

@property (nonatomic, strong) NSMutableArray *views;

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation SliderView
@synthesize pageControl, scrollView;

- (void)dealloc
{
    self.dataSource = nil;
    [_views release];
    [pageControl release];
    [scrollView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame withDataSource:(id<SliderDataSource>)dataSource
{
    if ((self = [super initWithFrame:frame])) {
		self.dataSource = dataSource;
        // Initialization UIScrollView
		
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:scrollView];
        
        int kNumberOfPages = [dataSource numberOfPages];
        if (kNumberOfPages > 1) {
            int pageControlHeight = 15;
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - pageControlHeight, frame.size.width, pageControlHeight)];
            pageControl.numberOfPages = kNumberOfPages;
            pageControl.currentPage = 0;
            pageControl.backgroundColor = [UIColor clearColor];
            [self addSubview:pageControl];
        }
		
		// in the meantime, load the array with placeholders which will be replaced on demand
		NSMutableArray *views = [NSMutableArray array];
		for (unsigned i = 0; i < kNumberOfPages; i++) {
			[views addObject:[NSNull null]];
		}
		self.views = views;
		
		// a page is the width of the scroll view
		scrollView.pagingEnabled = YES;
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.scrollsToTop = NO;
		scrollView.delegate = self;
		
		// pages are created on demand
		// load the visible page
		// load the page on either side to avoid flashes when the user starts scrolling
		[self loadScrollViewWithPage:0];
		[self loadScrollViewWithPage:1];
		
    }
    return self;
}


- (void)loadScrollViewWithPage:(int)page
{
	int kNumberOfPages = [self.dataSource numberOfPages];
	
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
    // replace the placeholder if necessary
    UIView *smileView = [self.views objectAtIndex:page];
    
    if ((NSNull *)smileView == [NSNull null]) {
		smileView = [self.dataSource viewAtIndex:page];
        [self.views replaceObjectAtIndex:page withObject:smileView];
    } else {
        UIImageView *imageView = (UIImageView *)[smileView viewWithTag:page];
        if (imageView != nil && imageView.image == nil) {
            smileView = [self.dataSource viewAtIndex:page];
            [self.views replaceObjectAtIndex:page withObject:smileView];
        }
    }
	
    // add the controller's view to the scroll view
    if (nil == smileView.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        smileView.frame = frame;
        [scrollView addSubview:smileView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

- (void)selectPageAtIndex:(NSInteger)index
{
    int page = index;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:NO];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
    
}

- (IBAction)changePageCycle:(id)sender
{
    int page = pageControl.currentPage;
	int kNumberOfPages = [self.dataSource numberOfPages];
    if (page >= kNumberOfPages - 1) {
        page = 0;
    } else {
        page++;
    }
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
    
    pageControl.currentPage = page;
}


@end
