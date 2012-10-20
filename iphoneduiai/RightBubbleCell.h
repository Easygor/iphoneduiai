//
//  RightBubbleCell.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-11.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "CustomCellDelegate.h"

@interface RightBubbleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet AsyncImageView *avatarImageView;
@property (strong, nonatomic) NSString *content, *imageUrl;
@property (strong, nonatomic) NSMutableDictionary *data;
@property (nonatomic) BOOL isRead;
@property (assign, nonatomic) id <CustomCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) NSDate *date;

- (CGFloat)requiredHeight;
- (void)sendMessageToRemote;

@end
