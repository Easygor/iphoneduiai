//
//  MoreUserInfoView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreUserInfoView : UIView

@property (strong, nonatomic) NSDictionary *moreUserInfo, *userLife;

- (void)showMeInView:(UIView *)view atPoint:(CGPoint)pos animated:(BOOL)animated;
- (void)removeMeWithAnimated:(BOOL)animated;

@end
