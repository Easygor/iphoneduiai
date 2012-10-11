//
//  LeftBubbleCell.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-11.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "LeftBubbleCell.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

#define TEXTW 185

@interface LeftBubbleCell ()

@property (strong, nonatomic) IBOutlet UIImageView *bubbleImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation LeftBubbleCell

- (void)dealloc
{
    [_avatarImageView release];
    [_bubbleImageView release];
    [_indicatorView release];
    [_content release];
    [_imageUrl release];
    [_contentLabel release];
    [super dealloc];
}


- (void)doInitWork
{
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 4.0f;
}

- (void)awakeFromNib
{
    [self doInitWork];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self doInitWork];
    }
    return self;
}


- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.opaque = YES;
        _contentLabel.numberOfLines = 0;
    }
    
    return _contentLabel;
}

- (void)setContent:(NSString *)content
{
    if (![_content isEqualToString:content]) {
        _content = [content retain];

        CGSize size = [content sizeWithFont:self.contentLabel.font
                          constrainedToSize:CGSizeMake(TEXTW, 10000)
                              lineBreakMode:UILineBreakModeCharacterWrap];

        self.contentLabel.frame = CGRectMake(15, 10, TEXTW, size.height);
        self.contentLabel.text = content;
        [self.contentLabel sizeToFit];
        
        UIImage *bgImage = [self.bubbleImageView.image stretchableImageWithLeftCapWidth:20 topCapHeight:30];
        CGRect bFrame = self.bubbleImageView.frame;
        bFrame.size.width = MAX(self.contentLabel.frame.size.width+self.contentLabel.frame.origin.x+15, 58);
        bFrame.size.height = MAX(self.contentLabel.frame.size.height+self.contentLabel.frame.origin.y+10, 48);
        self.bubbleImageView.frame = bFrame;
        self.bubbleImageView.image = bgImage;
        
        CGRect iFrame = self.indicatorView.frame;
        iFrame.origin.x = self.bubbleImageView.frame.size.width + self.bubbleImageView.frame.origin.x + 8;
        self.indicatorView.frame = iFrame;
//        [self.indicatorView startAnimating];

        [self.bubbleImageView addSubview:self.contentLabel];
        
    }
}

- (CGFloat)requiredHeight
{
    return self.bubbleImageView.frame.origin.y + self.bubbleImageView.frame.size.height + 15;
}

- (void)setImageUrl:(NSString *)imageUrl
{
    if (![_imageUrl isEqualToString:imageUrl]) {
        _imageUrl = [imageUrl retain];
        
        // do here
    }
}

@end
