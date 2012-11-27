//
//  UserInfoTableCell.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-24.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "UserInfoTableCell.h"

@interface UserInfoTableCell ()

@property (retain, nonatomic) IBOutlet UIImageView *bottomLineImgView;
@property (retain, nonatomic) IBOutlet UIImageView *graphBgImgView;



@end

@implementation UserInfoTableCell

- (void)dealloc
{
    [_avatarImageView release];
    [_nameLabel release];
    [_graphLabel release];
    [_ageHightLabel release];
    [_timeDistanceLabel release];
    [_iconL release];
    [_iconR release];
    [_iconM release];
    [_pictureNum release];
    [_bottomLineImgView release];
    [_graphBgImgView release];
    [_xLabel release];
    [super dealloc];
}

- (void)setWeibolist:(NSString *)weibolist
{
    if (![_weibolist isEqualToString:weibolist]) {
        _weibolist = [weibolist retain];
        NSArray *tmp = [weibolist componentsSeparatedByString:@"|"];
        self.iconL.image = nil;
        self.iconM.image = nil;
        if (tmp.count == 1)
        {
            if ([tmp[0] isEqualToString:@"sinaweibo"])
            {
                self.iconM.image = [UIImage imageNamed:@"weibo_icon_s"];
            }
            else if([tmp[0] isEqualToString:@"tweibo"])
            {
                self.iconM.image = [UIImage imageNamed:@"t-qq_icon"];
            }

        }
        else if(tmp.count == 2)
        {
            if ([tmp[0] isEqualToString:@"sinaweibo"])
            {
                self.iconL.image = [UIImage imageNamed:@"weibo_icon_s"];
            }
            else if([tmp[0] isEqualToString:@"tweibo"])
            {
                self.iconL.image = [UIImage imageNamed:@"t-qq_icon"];
            }
            if ([tmp[1] isEqualToString:@"sinaweibo"])
            {
                self.iconM.image = [UIImage imageNamed:@"weibo_icon_s"];
            }
            else if([tmp[1] isEqualToString:@"tweibo"])
            {
                self.iconM.image = [UIImage imageNamed:@"t-qq_icon"];
            }
        }
    }
}

- (void)doUserInfoInitWork
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (scale > 1.0) {
        CGRect frame = self.bottomLineImgView.frame;
        frame.size.height /= 2;
        frame.origin.y += 1;
        self.bottomLineImgView.frame = frame;
    }
}

- (void)awakeFromNib
{
    [self doUserInfoInitWork];
}

- (void)setGraphText:(NSString *)graphText
{
    if (![_graphText isEqualToString:graphText]) {
        _graphText = [graphText retain];
        
        if (graphText == nil || [graphText isEqualToString:@""]) {
            self.graphBgImgView.hidden = YES;
            self.graphLabel.hidden = YES;
        } else{
            self.graphBgImgView.hidden = NO;
            self.graphLabel.hidden = NO;
            self.graphLabel.text = graphText;
        }
    }
}

@end
