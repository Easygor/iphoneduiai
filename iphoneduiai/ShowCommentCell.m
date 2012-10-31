//
//  ShowCommentCell.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ShowCommentCell.h"

#define CONTENTW 225

@interface ShowCommentCell ()

@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation ShowCommentCell

-(void)dealloc
{
    [_titleLabel release];
    [_headImgView release];
    [_titleLabel release];
    [_contentLabel release];
    [super dealloc];
}

- (void)setContent:(NSString *)content
{
    if (![_content isEqualToString:content]) {
        _content = [content retain];
        
        CGSize size = [content sizeWithFont:self.contentLabel.font
                          constrainedToSize: CGSizeMake(CONTENTW, 1000)
                              lineBreakMode:UILineBreakModeCharacterWrap];
        CGRect contentFrame = self.contentLabel.frame;
        contentFrame.size = size;
        self.contentLabel.frame = contentFrame;
        
        self.contentLabel.text = content;
    }
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.headImgView = [[[AsyncImageView alloc]initWithFrame: CGRectMake(10, 10, 38, 38)] autorelease];
        [self.contentView addSubview:self.headImgView];
        UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatarAction:)] autorelease];
        self.headImgView.userInteractionEnabled = YES;
        [self.headImgView addGestureRecognizer:singleTap];
        
        self.titleLabel = [[[UILabel  alloc]initWithFrame:CGRectMake(55, 10, 225, 14)]autorelease];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel = [[[UILabel alloc]initWithFrame:CGRectMake(55, 25, CONTENTW, 13)]autorelease];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        self.contentLabel.textColor = [UIColor grayColor];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        [self.contentView addSubview:self.contentLabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 10, 60, 20)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        self.timeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.timeLabel];
        

    }
    return self;
}

- (void)tapAvatarAction:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(didChangeStatus:toStatus:)]) {
            [self.delegate didChangeStatus:self toStatus:@"tap_avatar"];
        }
    }
}

- (CGFloat)requiredHeight
{
    return MAX(self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+10, 60);
}

@end
