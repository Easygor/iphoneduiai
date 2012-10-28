//
//  CustomBarButtonItem.m
//  WhoHelp
//
//  Created by Dai Cloud on 12-1-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomBarButtonItem.h"
#import "UIImage+mergeImages.h"

@implementation CustomBarButtonItem


-(id)initBackBarButtonWithTitle:(NSString *)title  target:(id)target action:(SEL)action
{
    self = [super init];
    if (self != nil) {
        UIFont *textFont = [UIFont boldSystemFontOfSize:14.0f];
        CGSize size = [title sizeWithFont:textFont];
        CGFloat width = MAX(size.width+24, 54);
        UIImage *bgImg = [[UIImage imageNamed:@"nav_back_btn"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
        UIImage *bgImgPressed = [[UIImage imageNamed:@"nav_back_btn_highlight"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 0, width, bgImg.size.height);
        
        [button setBackgroundImage:bgImg forState:UIControlStateNormal];
        [button setBackgroundImage:bgImgPressed forState:UIControlStateHighlighted];
        
       
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
        
         button.titleLabel.shadowOffset = CGSizeMake(0.0, 1);
        [button setTitleShadowColor:RGBCOLOR(120, 200, 235) forState:UIControlStateNormal];

        button.titleLabel.font = textFont;
        
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        self.customView = button;
        
    }
    
    return self;
}

-(id)initBarButtonWithImage:(UIImage *)image  target:(id)target action:(SEL)action
{
    self = [super init];
    if (self != nil) {
        UIFont *textFont = [UIFont boldSystemFontOfSize:14.0f];
        CGSize size = image.size;
        CGFloat width = MAX(size.width, 40);
        UIImage *bgImg = [[UIImage imageNamed:@"nav_btn"] stretchableImageWithLeftCapWidth:9 topCapHeight:0];
        UIImage *bgImgPressed = [[UIImage imageNamed:@"nav_btn_highlight"] stretchableImageWithLeftCapWidth:9 topCapHeight:0];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 0, width, bgImg.size.height);
        
        [button setBackgroundImage:bgImg forState:UIControlStateNormal];
        [button setBackgroundImage:bgImgPressed forState:UIControlStateHighlighted];
        
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        
        button.titleLabel.font = textFont;
        
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        self.customView = button;
        
    }
    
    return self;
}

-(id)initRightBarButtonWithTitle:(NSString *)title  target:(id)target action:(SEL)action
{
    self = [super init];
    if (self != nil) {
        UIFont *textFont = [UIFont boldSystemFontOfSize:14.0f];
        CGSize size = [title sizeWithFont:textFont];
        CGFloat width = MAX(size.width+14, 50);
        UIImage *bgImg = [[UIImage imageNamed:@"nav_btn"] stretchableImageWithLeftCapWidth:9 topCapHeight:0];
        UIImage *bgImgPressed = [[UIImage imageNamed:@"nav_btn_highlight"] stretchableImageWithLeftCapWidth:9 topCapHeight:0];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 0, width, bgImg.size.height);
        
        [button setBackgroundImage:bgImg forState:UIControlStateNormal];
        [button setBackgroundImage:bgImgPressed forState:UIControlStateHighlighted];
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
        button.titleLabel.shadowOffset = CGSizeMake(0.0, 1);
        [button setTitleShadowColor:RGBCOLOR(120, 200, 235) forState:UIControlStateNormal];
        
        button.titleLabel.font = textFont;
        
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        self.customView = button;
        
    }
    
    return self;
}

#pragma mark relate methods

+ titleForNavigationItem:(NSString*)title
{
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 18.0f)] autorelease];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.shadowColor = RGBCOLOR(120, 200, 235);
    titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    titleLabel.opaque = YES;
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    return titleLabel;
}
@end
