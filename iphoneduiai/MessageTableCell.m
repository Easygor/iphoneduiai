//
//  MessageTableCell.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-6.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "MessageTableCell.h"

@interface MessageTableCell ()

@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIView *countView;

@end

@implementation MessageTableCell

- (void)dealloc
{
    [_countLabel release];
    [_countView release];
    [_avatarImageView release];
    [_nameLabel release];
    [_timeLabel release];
    [_descLabel release];
    [super dealloc];
}

- (void)setCount:(NSInteger)count
{
//    if (_count != count) {
        if (count > 0) {
            self.countView.hidden = NO;
            NSString *countString = nil;
            if (count < 10) {
                countString = [NSString stringWithFormat:@"%d", count];
            } else{
                countString = @"N";
            }
            self.countLabel.text = countString;
            self.descLabel.textColor = RGBCOLOR(113, 181, 64);
            self.descLabel.highlightedTextColor = RGBCOLOR(113, 181, 64);
        } else{
            self.countView.hidden = YES;
            self.descLabel.textColor = RGBCOLOR(136, 136, 136);
            self.descLabel.highlightedTextColor = RGBCOLOR(136, 136, 136);
            self.countLabel.text = nil;
        }
        
//    }
}

@end
