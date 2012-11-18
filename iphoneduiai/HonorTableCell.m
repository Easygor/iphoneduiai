//
//  HonorTableCell.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-7.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "HonorTableCell.h"
#import "AsyncImageView.h"

@interface HonorTableCell ()

@property (strong, nonatomic) NSArray *imageViews;

@end

@implementation HonorTableCell

- (void)dealloc
{
    [_users release];
    [_imageViews release];
    [super dealloc];
}

- (void)awakeFromNib
{
    for (UIView *v in self.imageViews) {
        UITapGestureRecognizer *tap3 = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(gestureAction:)] autorelease];
        v.userInteractionEnabled = YES;
        [v addGestureRecognizer:tap3];
    }
}

- (NSArray *)imageViews
{
    if (_imageViews == nil) {
        NSMutableArray *tmp = [NSMutableArray array];
        for (AsyncImageView *v  in self.contentView.subviews) {
            if ([v isKindOfClass:[AsyncImageView class]]) {
                [tmp  addObject:v];
            }
        }
        _imageViews = [[NSArray alloc] initWithArray:tmp];
    }
    
    return _imageViews;
}

- (void)setUsers:(NSArray *)users
{
    if (![_users isEqualToArray:users]) {
        _users = [users retain];
        
        for (int i=0; i< MIN(users.count, self.imageViews.count); i++) {
            AsyncImageView *view = [self.imageViews objectAtIndex:i];
            NSDictionary *user = [users objectAtIndex:i];
            view.hidden = NO;
            if ([user[@"photo"] isEqualToString:@""]) {
                [view loadImage:DEFAULTAVATAR];
            } else{
                [view loadImage:user[@"photo"]];
            }
            
        }
        
        for (int i=users.count; i<self.imageViews.count; i++) {
            AsyncImageView *view = [self.imageViews objectAtIndex:i];
            view.hidden = YES;
        }
    }
}

- (void)gestureAction:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateBegan) {
        // something
        
        CGSize size = gesture.view.frame.size;
        UIView *coverView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)] autorelease];
        coverView.backgroundColor = RGBACOLOR(0, 0, 0, 0.35);
        [gesture.view addSubview:coverView];
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [coverView removeFromSuperview];
        });
        
        NSString *pos = [NSString stringWithFormat:@"%d", [self.imageViews indexOfObject:gesture.view]];
        
        if ([self.delegate respondsToSelector:@selector(didChangeStatus:toStatus:)]) {
            [self.delegate didChangeStatus:self toStatus:pos];
        }
    }
}

@end
