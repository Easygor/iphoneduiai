//
//  SessionViewController.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>

@property (strong, nonatomic) NSMutableDictionary *messageData;

@end
