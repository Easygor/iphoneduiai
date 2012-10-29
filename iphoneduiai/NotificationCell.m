//
//  NotificationCell.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-27.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell
@synthesize titleLabel,contentLabel,headImgView,arrowImgView;

-(void)dealloc
{
    [titleLabel release];
    [contentLabel release];
    [headImgView release];
    [arrowImgView release];
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
        
        self.contentLabel = [[[UILabel alloc]initWithFrame:CGRectMake(55,25, 225, 33)]autorelease];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        self.contentLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.contentLabel];
        
        self.arrowImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_more"]];
        self.arrowImgView.frame = CGRectMake(0, 0, 9, 16);
//        [self.contentView addSubview:arrowImgView];
        self.accessoryView = self.arrowImgView;
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
