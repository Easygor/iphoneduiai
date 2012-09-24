//
//  CustomTabBarView.m
//  cosmetics
//
//  Created by Cloud Dai on 12-9-7.
//  Copyright (c) 2012年 buykee.com. All rights reserved.
//

#import "CustomTabBarView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomTabBarView

@synthesize delegate;
@synthesize bgView;

- (void)dealloc
{
    
    delegate = nil;
    [bgView release];
    [super dealloc];
}

//- (void)drawRect:(CGRect)rect
//{
//    UIImage *image = [UIImage imageNamed:@"tabbar-bg.png"];
//    [image drawInRect:rect];
//}

- (void)makeShadowForView:(UIView *)view
{
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOffset = CGSizeMake(0, -2);
    view.layer.shadowRadius = 2.5;
    view.layer.shadowOpacity = 0.25;
    view.layer.masksToBounds = NO;
    view.layer.shouldRasterize = YES;
}

-(void)makeShadow
{
//    for (UIView *view in self.subviews) {
//        if (view.frame.origin.y < 0) {
//            [self makeShadowForView:view];
//        }
//    }
//    [self makeShadowForView:self];
    
    if (bgView) {
        [self makeShadowForView:bgView];
    }
    
}

- (void)awakeFromNib
{
    [self makeShadow];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        [self makeShadow];
    }
    return self;
}

//Let the delegate know that a tab has been touched
-(IBAction) touchButton:(id)sender
{
    
    if( delegate != nil && [delegate respondsToSelector:@selector(selectTab:)]) {
        
        [delegate selectTab:[sender tag]];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
