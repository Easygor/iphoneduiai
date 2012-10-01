//
//  MarrayReqView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarrayReqView : UIView

@property (strong, nonatomic) NSDictionary *marrayReq;

- (void)showMeInView:(UIView *)view atPoint:(CGPoint)pos animated:(BOOL)animated;
- (void)removeMeWithAnimated:(BOOL)animated;

@end
