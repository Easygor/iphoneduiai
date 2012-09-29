//
//  UserCardTableCell.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-24.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCardView.h"

@interface UserCardTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UserCardView *leftCard, *middleCard, *rightCard;
@property (strong, nonatomic) NSArray *users;

@end
