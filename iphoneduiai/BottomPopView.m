//
//  BottomPopView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-15.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "BottomPopView.h"

@interface BottomPopView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *coverView;

@end

@implementation BottomPopView

- (void)dealloc
{
    [_coverView release];
    [super dealloc];
}

- (UIView *)coverView
{
    if (_coverView == nil) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        _coverView = [[UIView alloc] initWithFrame:w.bounds];
        _coverView.backgroundColor = RGBACOLOR(0, 0, 0, 0.35);
        UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)] autorelease];
        tap.delegate = self;
        [_coverView addGestureRecognizer:tap];

    }
    
    return _coverView;
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        [self cancelPicker];

    }
}

#pragma mark - animation

- (void)show
{
    UIWindow *w = [[UIApplication sharedApplication] keyWindow];
    [w addSubview:self.coverView];
    [self showInView:self.coverView];
}

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)dismiss
{
    [self cancelPicker];
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         [self.coverView removeFromSuperview];
                     }];
    
}

#pragma mark - getsture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(self.frame, point)) {
        return NO;
    }
    
    return YES;
}

@end
