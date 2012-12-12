//
//  NotificationCell.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-27.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "NotificationCell.h"

#define CELLH 56

@interface NotificationCell ()

@property (strong, nonatomic) UIView *readBgView, *unReadBgView;

@end

@implementation NotificationCell
@synthesize titleLabel,contentLabel,headImgView,arrowImgView;

-(void)dealloc
{
    self.delegate = nil;
    [_readBgView release];
    [_unReadBgView release];
    [titleLabel release];
    [contentLabel release];
    [headImgView release];
    [arrowImgView release];
    [super dealloc];
}

- (UIView *)readBgView
{
    if (_readBgView == nil) {
        _readBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, CELLH)];
        _readBgView.backgroundColor = RGBCOLOR(251, 251, 251);
        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0, CELLH-1, 320, 1)] autorelease];
        lbl.backgroundColor = RGBCOLOR(216, 216, 216);
        [_readBgView addSubview:lbl];
    }
    
    return _readBgView;
}

- (UIView*)unReadBgView
{
    if (_unReadBgView == nil) {
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, CELLH)];
        UIImage *bg = [[UIImage imageNamed:@"notice_unread_bg"] stretchableImageWithLeftCapWidth:3 topCapHeight:0];
        v.image = bg;
        _unReadBgView = v;
    }
    
    return _unReadBgView;
}

- (void)setRead:(BOOL)read
{
//    if (read != _read) {
        _read = read;
        
        if (read) {
            self.backgroundView = self.readBgView;

        } else{

            self.backgroundView = self.unReadBgView;
        }
//    }
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
        
        self.arrowImgView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_more"]] autorelease];
        self.arrowImgView.frame = CGRectMake(0, 0, 9, 16);
//        [self.contentView addSubview:arrowImgView];
        self.accessoryView = self.arrowImgView;
        
        UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatarAction:)] autorelease];
        self.headImgView.userInteractionEnabled = YES;
        [self.headImgView addGestureRecognizer:singleTap];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
