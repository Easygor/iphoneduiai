//
//  ShowCommentViewController.h
//  iphoneduiai
//
//  Created by yinliping on 12-10-26.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiyuWordCell.h"

@interface ShowCommentViewController : UITableViewController<CustomCellDelegate>

@property (nonatomic, retain) NSMutableDictionary *weiYuDic;

@end
