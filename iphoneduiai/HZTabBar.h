//
//  HZTabBar.h
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-7.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HZTabBarDelegate <NSObject>

-(void)touchUpInsideItemAtIndex:(int)index;

@end

@interface HZTabBar : UIView
{
    
    NSObject <HZTabBarDelegate> *delegate;
    
    NSMutableArray* buttons;
    
    NSMutableArray* itemImages;
    
    float height,width;
    
}

@property (nonatomic, retain) NSMutableArray *buttons, *itemImages;

@property (nonatomic) float height;

- (id) initWithImages:(NSArray*)images delegate:(NSObject <HZTabBarDelegate>*)myDelegate;

@end
