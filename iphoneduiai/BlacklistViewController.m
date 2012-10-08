//
//  BlacklistViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "BlacklistViewController.h"
#import "CustomBarButtonItem.h"
@interface BlacklistViewController ()

@end

@implementation BlacklistViewController



-(void)loadView
{
    [super loadView];
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"编辑"target:self action:@selector(saceAction)] autorelease];
    
    UILabel *bigLabel = [[[UILabel alloc]initWithFrame:CGRectMake(90,150, 170, 15)]autorelease];
    bigLabel.text = @"您的黑名单空空空空如也";
    bigLabel.backgroundColor = [UIColor clearColor];
    bigLabel.font = [UIFont systemFontOfSize:14];
    bigLabel.textColor = RGBCOLOR(169, 169, 169);
    [self.view addSubview:bigLabel];
    
    UILabel *smallLabel = [[[UILabel alloc]initWithFrame:CGRectMake(75,175,200, 15)]autorelease];
    smallLabel.text = @"你将不会收到黑名单用户给您的信息";
    smallLabel.font = [UIFont systemFontOfSize:12];
    smallLabel.textColor = RGBCOLOR(208, 208, 208);
    smallLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:smallLabel];
    
    
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
