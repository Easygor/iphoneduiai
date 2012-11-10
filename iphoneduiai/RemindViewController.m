//
//  RemindViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "RemindViewController.h"
#import "CustomBarButtonItem.h"

@interface RemindViewController ()
@property (retain, nonatomic) IBOutlet UISwitch *messageSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *dynamicSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *goodMeSwitch;


@end

@implementation RemindViewController



- (void)dealloc
{

    [_messageSwitch release];
    [_dynamicSwitch release];
    [_goodMeSwitch release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"提醒设置"];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setMessageSwitch:nil];
    [self setDynamicSwitch:nil];
    [self setGoodMeSwitch:nil];
    [super viewDidUnload];
}
@end
