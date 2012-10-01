//
//  AvatarView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface AvatarView : UIView

@property (strong, nonatomic) IBOutlet AsyncImageView *imageView;
@property (strong, nonatomic) NSString *sex;

@end
