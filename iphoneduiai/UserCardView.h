//
//  UserCardView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-24.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface UserCardView : UIView

@property (strong, nonatomic) IBOutlet AsyncImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *picNumLabel, *infoLabel;

@end
