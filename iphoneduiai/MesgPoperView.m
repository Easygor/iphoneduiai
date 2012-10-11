//
//  MesgPoperView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-10.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "MesgPoperView.h"

@interface MesgPoperView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *containerView;

@end

@implementation MesgPoperView

- (void)showMeAtView:(UIView*)view atPoint:(CGPoint)pos
{
    
    if (self.containerView == nil) {
        self.containerView = [[[UIView alloc] initWithFrame:view.window.frame] autorelease];
        self.containerView.backgroundColor = [UIColor clearColor];
        self.containerView.opaque = YES;
        self.containerView.clipsToBounds = NO;
        UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)] autorelease];
        tap.delegate = self;
        [self.containerView addGestureRecognizer:tap];
    }
    
    [view.window addSubview:self.containerView];
    CGRect selfFrame = self.frame;
    selfFrame.origin.x = pos.x;
    selfFrame.origin.y = pos.y;
    

    self.frame = selfFrame;
    [self.containerView addSubview:self];
    
       
}

- (void)removeMe
{
    
        [self removeFromSuperview];
        [self.containerView removeFromSuperview];
}

- (void)tapGestureAction:(UITapGestureRecognizer*)gesture
{
    
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {

        [self removeMe];
    
    }
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
