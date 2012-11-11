//
//  BlockUserCell.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-11-11.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCardView.h"
#import "CustomCellDelegate.h"

@interface BlockUserCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UserCardView *leftCard, *middleCard, *rightCard;
@property (strong, nonatomic) NSArray *users;
@property (assign, nonatomic) IBOutlet id <CustomCellDelegate> delegate;
@property (nonatomic) BOOL isEditing;

@end
