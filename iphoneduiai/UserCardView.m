//
//  UserCardView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-24.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "UserCardView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UserCardView


- (void)dealloc
{
    [_imageView release];
    [_picNumLabel release];
    [_infoLabel release];
    [super dealloc];
}

- (void)doRadius
{
    self.picNumLabel.clipsToBounds = YES;
    self.picNumLabel.layer.cornerRadius = 3;
}

- (void)awakeFromNib
{
    [self doRadius];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self doRadius];
    }
    return self;
}

@end
