//
//  UserDetailViewController.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-28.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSDictionary *user;

@end
