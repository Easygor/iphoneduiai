//
//  UserInfoTableCell.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-24.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "UserInfoTableCell.h"

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
    [super dealloc];
}

@end
