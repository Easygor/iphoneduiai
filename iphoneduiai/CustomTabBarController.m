//
//  CustomTabBarController.m
//  cosmetics
//
//  Created by Cloud Dai on 12-9-7.
//  Copyright (c) 2012年 buykee.com. All rights reserved.
//

#import "CustomTabBarController.h"
#import "CustomTabBarView.h"
#import "LoginViewController.h"

@interface CustomTabBarController () <CustomTabBarDelegate>

@property (nonatomic, strong) CustomTabBarView *bgView;

- (void)buttonClicked:(id)sender;

@end

@implementation CustomTabBarController

@synthesize bgView;


- (void)dealloc
{
    [bgView release];
    
    [super dealloc];
}

- (BOOL)checkLogin
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user"]) {
        return YES;
    }
    
    LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self presentModalViewController:lvc animated:NO];
    [lvc release];
    
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
	[self hideTabBar];
	[self addCustomElements];
    [self selectTab:0];
}

- (void)hideTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}

- (void)hideNewTabBar
{
    self.bgView.hidden = YES;
}

- (void)showNewTabBar
{
    self.bgView.hidden = NO;
}

-(void)addCustomElements
{
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
    self.bgView = [nibObjects objectAtIndex:0];
    self.bgView.delegate = self;
    
    CGRect bgViewFrame = self.bgView.frame;
    bgViewFrame.origin.y = self.view.frame.size.height - bgViewFrame.size.height;
    self.bgView.frame = bgViewFrame;
    
    [self.view addSubview:self.bgView];
   
}



- (void)buttonClicked:(id)sender
{
	int tagNum = [sender tag];
	[self selectTab:tagNum];
}

- (void)selectTab:(int)tabID
{
    if ([self checkLogin]) {
        // do nothing
    }
    
    for (UIButton *btn in self.bgView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag == tabID) {
                btn.selected = YES;
            } else{
                btn.selected = NO;
            }
        }
    }
    
	self.selectedIndex = tabID;
    
}


@end
