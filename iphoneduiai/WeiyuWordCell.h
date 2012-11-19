//
//  WeiyuWordCell.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "CustomCellDelegate.h"

@interface WeiyuWordCell : UITableViewCell

@property (strong, nonatomic) IBOutlet AsyncImageView *avaterImageView;
@property (assign, nonatomic) id <CustomCellDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary *weiyu;
@property (nonatomic) NSInteger digoNum, shitNum, commentNum;

- (CGFloat)requiredHeight;


@end
