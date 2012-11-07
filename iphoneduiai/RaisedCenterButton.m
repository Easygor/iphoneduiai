//
//  RaisedCenterButton.m
//  RaisedCenterButton
//
//  Created by Johnnie Pittman on 5/13/12.
//  Copyright (c) 2012 Group 6. All rights reserved.
//

#import "RaisedCenterButton.h"

@interface RaisedCenterButton ()

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (copy, nonatomic) UIImage *buttonImage;

@end

@implementation RaisedCenterButton

- (void)dealloc
{
    [_tabBarController release];
    [_buttonImage release];
    
    [super dealloc];
}

+ (id)buttonWithBgImage:(UIImage *)image hlImage:(UIImage*)hlImage forTabBarController:(UITabBarController *)tabBarController
{
    RaisedCenterButton *button = [RaisedCenterButton buttonWithType:UIButtonTypeCustom];
    
    // we use this to center our button and take action when the button is used.
    [button setTabBarController:tabBarController];
    [button setButtonBgImage:image withHlImage:hlImage];

    return button;
}

- (void)setButtonBgImage:(UIImage *)buttonImage withHlImage:(UIImage*)hlImage
{
    if (buttonImage != _buttonImage) {
        _buttonImage = [buttonImage retain];
        
        self.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
        [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [self setBackgroundImage:hlImage forState:UIControlStateHighlighted];
        [self setBackgroundImage:hlImage forState:UIControlStateSelected];
        self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        CGFloat heightDifference = buttonImage.size.height - self.tabBarController.tabBar.frame.size.height;
        
        if (heightDifference < 0)
            self.center = self.tabBarController.tabBar.center;
        else
        {
            CGPoint center = self.tabBarController.tabBar.center;
            center.y = center.y - heightDifference/2.0;
            self.center = center;
        }
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }

}

// replicating the action of touching the center button on the tab bar.
- (void)buttonAction:(UIButton*)btn
{
    [self.tabBarController setSelectedIndex:2];
    btn.selected = YES;
}

@end
