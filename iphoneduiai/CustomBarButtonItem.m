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
        CGFloat width = MAX(size.width+14, 54);
        UIImage *bgImg = [UIImage imageWithLeftNamed:@"btn-left-back-bg.png"
                                           bodyNamed:@"btn-x-bg.png"
                                        rightImgName:@"btn-right-bg.png"
                                               width:width];
        UIImage *bgImgPressed = [UIImage imageWithLeftNamed:@"btn-left-back-bg-linked.png"
                                           bodyNamed:@"btn-x-bglinked.png"
                                        rightImgName:@"btn-right-bglinked.png"
                                               width:width];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 0, bgImg.size.width, bgImg.size.height);
        
        [button setBackgroundImage:bgImg forState:UIControlStateNormal];
        [button setBackgroundImage:bgImgPressed forState:UIControlStateHighlighted];
        
        button.titleLabel.shadowColor = RGBCOLOR(210, 233, 245);
        button.titleLabel.shadowOffset = CGSizeMake(0.0, 1);
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
        
//        [button setTitleShadowColor:RGBCOLOR(89, 176, 218) forState:UIControlStateNormal];
//        [button setTitleShadowColor:RGBCOLOR(89, 176, 218) forState:UIControlStateHighlighted];
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
        CGFloat width = MAX(size.width, 50);
        UIImage *bgImg = [UIImage imageWithLeftNamed:@"btn-leftbg.png"
                                           bodyNamed:@"btn-x-bg.png"
                                        rightImgName:@"btn-right-bg.png"
                                               width:width];
        UIImage *bgImgPressed = [UIImage imageWithLeftNamed:@"btn-leftbg-linked.png"
                                                  bodyNamed:@"btn-x-bglinked.png"
                                               rightImgName:@"btn-right-bglinked.png"
                                                      width:width];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 0, bgImg.size.width, bgImg.size.height);
        
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
        UIImage *bgImg = [UIImage imageWithLeftNamed:@"btn-leftbg.png"
                                           bodyNamed:@"btn-x-bg.png"
                                        rightImgName:@"btn-right-bg.png"
                                               width:width];
        UIImage *bgImgPressed = [UIImage imageWithLeftNamed:@"btn-leftbg-linked.png"
                                                  bodyNamed:@"btn-x-bglinked.png"
                                               rightImgName:@"btn-right-bglinked.png"
                                                      width:width];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 0, bgImg.size.width, bgImg.size.height);
        
        [button setBackgroundImage:bgImg forState:UIControlStateNormal];
        [button setBackgroundImage:bgImgPressed forState:UIControlStateHighlighted];
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
        button.titleLabel.shadowColor = RGBCOLOR(210, 233, 245);
        button.titleLabel.shadowOffset = CGSizeMake(0.0, 1);
        
//        [button setTitleShadowColor:RGBCOLOR(89, 176, 218) forState:UIControlStateNormal];
//        [button setTitleShadowColor:RGBCOLOR(89, 176, 218) forState:UIControlStateHighlighted];
        button.titleLabel.font = textFont;
        
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        self.customView = button;
        
    }
    
    return self;
}


-(id)initBackBarButtonItemWithTarget:(id)target action:(SEL)action
{
    self = [super init];
    if (self != nil){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 26, 26);
        button.backgroundColor = [UIColor clearColor];
        button.opaque = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"back_pressed.png"] forState:UIControlStateHighlighted];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        //[button setTitle:@"返回" forState:UIControlStateNormal];
//        [button setTitle:@"返回" forState:UIControlStateHighlighted];
//        button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
//        button.titleLabel.backgroundColor = [UIColor redColor];
//        CGRect titleFrame = button.titleLabel.frame;
//        titleFrame.origin.y -= 1;
//        titleFrame.origin.x += 2;
//        button.titleLabel.frame = titleFrame;

        self.customView = button;
    }
    
    return self;
}

-(id)initSendBarButtonItemWithTarget:(id)target action:(SEL)action
{
    self = [super init];
    if (self != nil){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 48, 30);
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage imageNamed:@"list_bar_bg_normal.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"list_bar_bg_hl.png"] forState:UIControlStateHighlighted];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"分类" forState:UIControlStateNormal];
        [button setTitle:@"分类" forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        CGRect titleFrame = button.titleLabel.frame;
        titleFrame.origin.y -= 1;
        button.titleLabel.frame = titleFrame;
        
        self.customView = button;
    }
    
    return self; 
}

@end
