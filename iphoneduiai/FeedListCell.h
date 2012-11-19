//
//  FeedListCell.h
//  iphoneduiai
//
//  Created by yinliping on 12-10-28.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "CustomCellDelegate.h"

@interface FeedListCell : UITableViewCell

@property(strong,nonatomic)AsyncImageView *headImgView;
@property(strong,nonatomic)UILabel* titleLabel,*contentLabel;
@property (assign, nonatomic) id <CustomCellDelegate> delegate;

@end
