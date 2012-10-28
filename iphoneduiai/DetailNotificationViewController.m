//
//  DetailNotificationViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-28.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "DetailNotificationViewController.h"
#import "CustomBarButtonItem.h"
@interface DetailNotificationViewController ()

@end

@implementation DetailNotificationViewController
@synthesize timeLabel,titleLabel,contentLabel,headImgView;
@synthesize notificationData;
-(void)dealloc
{
    [headImgView release];
    [titleLabel release];
    [timeLabel release];
    [contentLabel release];
    [notificationData release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    self.navigationItem.title = @"系统通知";
  CustomBarButtonItem  *rightBarButton = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"编辑"target:self action:@selector(editButton)] autorelease];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"target:self action:@selector(backAction)] autorelease];

    [self.headImgView loadImage:self.notificationData[@"photo"]];
    self.titleLabel.text  = self.notificationData[@"title"];
    self.contentLabel.text = notificationData[@"content"];

}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
