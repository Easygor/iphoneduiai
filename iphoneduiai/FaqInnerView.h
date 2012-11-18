//
//  FaqInnerView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-11-17.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "EngzoContainerView.h"

@interface FaqInnerView : EngzoContainerView

@property (strong, nonatomic) NSString *innerContent;

- (CGFloat)requiredHeight;

@end
