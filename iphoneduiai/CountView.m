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

         self.countLabel.text = count;
        [self.countLabel sizeToFit];
        
        CGRect selfFrame = self.frame;
        selfFrame.size.width = self.countLabel.frame.size.width + self.logo.frame.size.width + 20;
        selfFrame.origin.x = 320 - 10 - selfFrame.size.width;
        self.frame = selfFrame;  
       
    }
}


- (void)doInitWork
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 4.0f;
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
