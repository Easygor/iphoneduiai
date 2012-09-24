//
//  CustomTabBarView.h
//  cosmetics
//
//  Created by Cloud Dai on 12-9-7.
//  Copyright (c) 2012年 buykee.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//Delegate methods for responding to TabBar events
@protocol CustomTabBarDelegate <NSObject>

//Handle tab bar touch events, sending the index of the selected tab
-(void)selectTab:(NSInteger)index;


@end


@interface CustomTabBarView : UIView
{
    
    NSObject<CustomTabBarDelegate> *delegate;
    
}

@property (nonatomic, assign) NSObject<CustomTabBarDelegate> *delegate;
@property (strong, nonatomic) IBOutlet UIImageView *bgView;


-(IBAction) touchButton:(id)sender;

@end
