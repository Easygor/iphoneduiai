//
//  UserInfoTableCell.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-24.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface UserInfoTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet AsyncImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel, *graphLabel, *ageHightLabel, *timeDistanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconR, *iconL, *iconM;
@property (strong, nonatomic) IBOutlet UILabel *pictureNum;
@property (strong, nonatomic) NSString *graphText;
@property (retain, nonatomic) IBOutlet UILabel *xLabel;

@end
