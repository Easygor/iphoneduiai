//
//  CustomTabBarController.h
//  cosmetics
//
//  Created by Cloud Dai on 12-9-7.
//  Copyright (c) 2012年 buykee.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarController : UITabBarController

- (void)showNewTabBar;
- (void)hideNewTabBar;

- (void)selectTab:(int)tabID;

@end
