//
//  HonorTableCell.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-7.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellDelegate.h"

@interface HonorTableCell : UITableViewCell

@property (strong, nonatomic) NSArray *users;
@property (assign, nonatomic) IBOutlet id <CustomCellDelegate> delegate;

@end
