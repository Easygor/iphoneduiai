//
//  ShowPhotoView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ShowPhotoView.h"
#import "RoundThumbView.h"
#import <QuartzCore/QuartzCore.h>
#import "SliderView.h"
#import "Utils.h"

@interface ShowPhotoView () <SliderDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSMutableArray *rounds;
@property (strong, nonatomic) IBOutlet AsyncImageView *showImageView;
//@property (strong, nonatomic) IBOutlet CountView *viewCountView;
@property (strong, nonatomic) SliderView *slider;

@end

@implementation ShowPhotoView

- (void)dealloc
{
    self.slider.dataSource = nil;
    [_scrollView release];
    [_showImageView release];
    [_photos release];
//    [_viewCountView release];
    [_slider release];
    [_rounds release];
    [_containerView release];
    [_slider release];
    [super dealloc];
}

- (NSArray *)rounds
{
    if (_rounds == nil) {
        _rounds = [[NSMutableArray alloc] init];
    }
    
    return _rounds;
}

- (void)setPhotos:(NSMutableArray *)photos
{
    if (![_photos isEqualToArray:photos]) {
//        _photos = [photos retain];
         _photos = [[NSMutableArray alloc] init];
        // init the thumbs
        int i=0;
        for (NSDictionary *d in photos) {
            if ([[d objectForKey:@"class"] isEqualToString:@"show"] ||
                [[d objectForKey:@"class"] isEqualToString:@"show selected"]) {

                RoundThumbView *view = [[[RoundThumbView alloc] initWithFrame:CGRectMake(5+50*i, 3, 46, 46)
                                                                        image:[d objectForKey:@"icon"]
                                                                       target:self
                                                                  forSelector:@selector(gestureAction:)] autorelease];
                view.tag = i;
                [self.scrollView addSubview:view];
                [self.rounds addObject:view];
                [_photos addObject:d];
            }

            i++;
        }
        
        RoundThumbView *lastView = [self.rounds lastObject];

        self.scrollView.contentSize = CGSizeMake(lastView.frame.origin.x + lastView.frame.size.width+5, self.scrollView.contentSize.height);
        self.scrollView.scrollEnabled = YES;
        if (self.rounds.count > 0) {
            RoundThumbView *firstView = [self.rounds objectAtIndex:0];
            [self selectedRoundView:firstView];

        }
        
    }
}

- (void)doInitWork
{
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.containerView.layer.shadowRadius = 1.0f;
    self.containerView.layer.shadowOpacity = 0.30;
    self.containerView.layer.masksToBounds = NO;
    self.containerView.layer.shouldRasterize = YES;
    
    [self.showImageView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageGesture:)] autorelease]];
    self.showImageView.userInteractionEnabled = YES;
    self.showImageView.tag = -1;
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
}

- (void)awakeFromNib
{
    [self doInitWork];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self doInitWork];
    }
    return self;
}

- (void)selectedRoundView:(RoundThumbView*)tv
{
    int i = 0;
    for (RoundThumbView *view in self.rounds) {
        if ([view isEqual:tv]) {
            NSDictionary *d = [self.photos objectAtIndex:view.tag];
            
            view.selected = YES;
            NSString *iconUrl = [d objectForKey:@"icon"];
            [self.showImageView loadImage:/*iconUrl*/[iconUrl substringToIndex:iconUrl.length - [@".thumb.jpg" length]]];
            self.showImageView.tag = i;
        } else{
            view.selected = NO;
        }
        
        i++;
    }
}

- (void)gestureAction:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        RoundThumbView *tv = (RoundThumbView *)gesture.view;
        [self selectedRoundView:tv];
    }
}


#pragma mark - slider views
-(void)addSliderView
{
    // Do any additional setup after loading the view from its nib.
    SliderView *pageView = [[SliderView alloc] initWithFrame: self.window.frame
                                              withDataSource: self];
    pageView.backgroundColor = [UIColor blackColor];
    [self.window addSubview:pageView];
    self.slider = pageView;
    
}

-(void)clearSliderView
{
    [self.slider removeFromSuperview];
    self.slider = nil;
    
}

-(int)numberOfPages
{
    return self.photos.count;
}

-(UIView *)viewAtIndex:(int)index
{
    UIScrollView *view = [[[UIScrollView alloc] initWithFrame:self.window.frame] autorelease];
    view.backgroundColor = [UIColor clearColor];
    view.opaque = YES;
    view.maximumZoomScale = 5.0;
    view.zoomScale = 1.0;
    view.minimumZoomScale = 1.0;
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.delegate = self;
    view.tag = index+100;
    UITapGestureRecognizer *oneTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerView:)] autorelease];
    oneTap.numberOfTapsRequired = 1;
    oneTap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:oneTap];
    
    UITapGestureRecognizer *doubleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerView:)] autorelease];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:doubleTap];
    
    [oneTap requireGestureRecognizerToFail:doubleTap];
    
    CGRect viewFrame = [self convertRect:self.showImageView.frame toView:self.window];
    
    AsyncImageView *imView = [[[AsyncImageView alloc] initWithFrame:viewFrame] autorelease];
    NSDictionary *d = [self.photos objectAtIndex:index];
    
    imView.tag = index;
    
    [view addSubview:imView];
    NSString *iconUrl = [d objectForKey:@"icon"];

    CGSize size = view.frame.size;
    [imView loadImage:[iconUrl substringToIndex:iconUrl.length - [@".thumb.jpg" length]]
   withPlaceholdImage:self.showImageView.image withBlock:^{
        [UIView animateWithDuration:0.3 animations:^{
            CGSize imgsize = imView.image.size;
            CGFloat imgWidth = MIN(imgsize.width, size.width);
            CGFloat imgHeight = imgWidth*imgsize.height/imgsize.width;
            
            imView.frame = CGRectMake((size.width-imgWidth)/2, (size.height - imgHeight)/2, imgWidth, imgHeight);
        }];
    }];
    
    return view;
}

- (void)tapImageGesture:(UITapGestureRecognizer*)gesture
{
    
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        NSInteger index = gesture.view.tag;
        if (index >= 0) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            
            [self addSliderView];
            [self.slider selectPageAtIndex:index];
        }
 
    }
}

- (void)tapContainerView:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        if (gesture.numberOfTapsRequired == 1) {
            
            CGRect viewFrame = [self convertRect:self.showImageView.frame toView:gesture.view];
            
            AsyncImageView *imView = (AsyncImageView*)[gesture.view viewWithTag:gesture.view.tag-100];
            [self selectedRoundView:[self.rounds objectAtIndex:gesture.view.tag-100]];
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            self.slider.backgroundColor = [UIColor clearColor];
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 imView.frame = viewFrame;
                             }
                             completion:^(BOOL finshed){
                                 [gesture.view removeFromSuperview];
                                 [self clearSliderView];
                             }];
        } else{
            UIScrollView *view = (UIScrollView*)gesture.view;
            if (view.zoomScale <= 1.0) {
                [view setZoomScale:3.0 animated:YES];
            } else{
                [view setZoomScale:1.0 animated:YES];
            }
        }
        
    }
}

#pragma mark - scroll view delegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIView *view = [scrollView viewWithTag:scrollView.tag-100];
    
    return view;
}

@end
