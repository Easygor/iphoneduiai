//
//  WeiyuOnePicCell.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-11-27.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellDelegate.h"

@interface WeiyuOnePicCell : UITableViewCell

@property (assign, nonatomic) id <CustomCellDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary *weiyu;
@property (nonatomic) NSInteger digoNum, shitNum, commentNum;

@end
