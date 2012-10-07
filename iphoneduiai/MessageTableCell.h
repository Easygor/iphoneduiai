//
//  MessageTableCell.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-6.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface MessageTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet AsyncImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel, *timeLabel, *descLabel;
@property (nonatomic) NSInteger count;

@end
