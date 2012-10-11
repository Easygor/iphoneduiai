//
//  LeftBubbleCell.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-11.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface LeftBubbleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet AsyncImageView *avatarImageView;
@property (strong, nonatomic) NSString *content, *imageUrl;

- (CGFloat)requiredHeight;

@end
