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

    [self.messageSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"message_can_receive"]];
    [self.dynamicSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"dynamic_can_receive"]];
    [self.goodMeSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"digome_can_receive"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (IBAction)messageSwitchAction:(UISwitch*)sw
{
    [[NSUserDefaults standardUserDefaults] setBool:sw.isOn forKey:@"message_can_receive"];

}

- (IBAction)dynamicSwitchAction:(UISwitch*)sw
{
    [[NSUserDefaults standardUserDefaults] setBool:sw.isOn forKey:@"dynamic_can_receive"];
}

- (IBAction)digoMeAction:(UISwitch*)sw
{
    [[NSUserDefaults standardUserDefaults] setBool:sw.isOn forKey:@"digome_can_receive"];
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
