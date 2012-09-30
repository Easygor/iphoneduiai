//
//  ShowPhotoView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ShowPhotoView.h"

@interface ShowPhotoView ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ShowPhotoView

- (void)dealloc
{
    [_scrollView release];
    [_showImageView release];
    [_photos release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
