//
//  ShowPhotoView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ShowPhotoView : UIView

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) IBOutlet AsyncImageView *showImageView;

@end
