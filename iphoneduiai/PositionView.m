//
//  PositionView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-22.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "PositionView.h"
#import <QuartzCore/QuartzCore.h>

@interface PositionView ()

@property (strong, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation PositionView

- (void)doInitWork
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height/2;
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

- (void)setAddress:(NSString *)address
{
    if (![_address isEqualToString:address]) {
        _address = [address retain];
        
        UIFont *font = [UIFont systemFontOfSize:12.0f];
        CGSize size = [address sizeWithFont:font];
        
        CGRect descFrame = self.descLabel.frame;
        descFrame.size.width = MIN(size.width, 220) + 5;
        self.descLabel.frame = descFrame;
        
        CGRect selfFrame = self.frame;
        selfFrame.size.width = self.descLabel.frame.size.width + 20;
        self.frame = selfFrame;
        
        self.descLabel.text = address;
    }
}

@end
