//
//  DropMenuView.h
//  cosmetics
//
//  Created by Cloud Dai on 12-9-20.
//  Copyright (c) 2012年 buykee.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropMenuView;

@protocol DropMenuViewDelegate <NSObject>

@optional
- (void)didSelectedMenuCell:(DropMenuView *)dropView withTag:(NSString *)tag name:(NSString*)name;

@end

@protocol DropMenuViewDataSource <NSObject>

- (NSArray *)dropMenuViewData:(DropMenuView *)dropView;

@end

@interface DropMenuView : UIView

@property (assign, nonatomic) IBOutlet id <DropMenuViewDelegate> delegate;
@property (assign, nonatomic) IBOutlet id <DropMenuViewDataSource> dataSource;
@property (nonatomic) BOOL visible;

- (void)reloadData;
- (void)removeMeWithAnimated:(BOOL)animated;
- (void)showMeInView:(UIView *)view atPoint:(CGPoint)pos animated:(BOOL)animated;

@end
