//
//  CountView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "CountView.h"
#import <QuartzCore/QuartzCore.h>

@interface CountView ()

@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation CountView

- (void)dealloc
{
    [_logo release];
    [_count release];
    [_countLabel release];
    [super dealloc];
}

- (void)setCount:(NSString *)count
{
    if (![_count isEqualToString:count]) {
        _count = [count retain];
        CGSize size = [count sizeWithFont:self.countLabel.font];
        CGRect countFrame = self.countLabel.frame;
        countFrame.size.width = size.width;
        self.countLabel.frame = countFrame;
        
        CGRect selfFrame = self.frame;
        selfFrame.size.width = size.width + self.logo.frame.size.width + 15;
        selfFrame.origin.x = 320 - 5 - selfFrame.size.width;
        self.frame = selfFrame;
        
        self.countLabel.text = count;
    }
}


- (void)doInitWork
{
    self.layer.cornerRadius = 3.0f;
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


@end
