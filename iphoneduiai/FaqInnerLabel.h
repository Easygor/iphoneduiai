//
//  FaqInnerLabel.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-11-27.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EngzoContainerView.h"

@interface FaqInnerLabel : EngzoContainerView

@property (strong, nonatomic) NSString *innerContent;

- (CGFloat)requiredHeight;

@end
