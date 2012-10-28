//
//  DetailNotificationViewController.h
//  iphoneduiai
//
//  Created by yinliping on 12-10-28.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface DetailNotificationViewController : UIViewController
@property(nonatomic,retain)IBOutlet AsyncImageView *headImgView;
@property(nonatomic,retain)IBOutlet UILabel *titleLabel,*contentLabel,*timeLabel;
@property(nonatomic,retain)NSDictionary *notificationData;
@end
