//
//  ShowCommentCell.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ShowCommentCell.h"

@implementation ShowCommentCell

-(void)dealloc
{
    [_headImgView release];
    [_titleLabel release];
    [_contentLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.headImgView = [[[AsyncImageView alloc]initWithFrame: CGRectMake(10, 10, 38, 38)] autorelease];
        [self.contentView addSubview:self.headImgView];
        
        self.titleLabel = [[[UILabel  alloc]initWithFrame:CGRectMake(55, 10, 225, 22)]autorelease];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel = [[[UILabel alloc]initWithFrame:CGRectZero]autorelease];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        self.contentLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.contentLabel];

        CGSize size = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize: CGSizeMake(self.contentLabel.frame.size.width, 400) lineBreakMode:UILineBreakModeCharacterWrap];
        self.contentLabel.frame = CGRectMake(55, 25, size.width, size.height);
        


    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
