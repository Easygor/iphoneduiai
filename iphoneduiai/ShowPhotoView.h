//
//  ShowPhotoView.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "CountView.h"

@class ShowPhotoView;

@protocol ShowPhotoDelegate <NSObject>

@optional
- (void)didTriggerAddPhotoAction:(ShowPhotoView*)view;
- (void)didTriggerDelPhotoAction:(ShowPhotoView*)view at:(NSInteger)index;

@end

@interface ShowPhotoView : UIView

@property (strong, nonatomic) NSMutableArray *photos;
@property (nonatomic) BOOL editing;
@property (assign, nonatomic) id <ShowPhotoDelegate> delegate;

- (void)insertPhoto:(NSMutableDictionary*)d atIndex:(NSInteger)index;
- (void)removePhotoAt:(NSInteger)index;
- (void)selectRoundAt:(NSInteger)index;

@end
