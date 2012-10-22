//
//  AboutViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-5.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "AboutViewController.h"
#import "CustomBarButtonItem.h"

@interface AboutViewController ()

@end

@implementation AboutViewController


-(void)loadView
{
    [super loadView];
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    UIImageView *duiAiImgView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 160)]autorelease];
    duiAiImgView.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:duiAiImgView];
    
    UILabel *versionLabel = [[[UILabel alloc]initWithFrame:CGRectMake(110, 200, 80, 30)]autorelease];
    versionLabel.text = @"iPhone版v1.0\n已是最新版本";
    versionLabel.lineBreakMode = UILineBreakModeWordWrap;
    versionLabel.numberOfLines = 0;
    versionLabel.font = [UIFont systemFontOfSize:13];
    versionLabel.textColor = RGBCOLOR(197, 197, 197);
    versionLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:versionLabel];
    
    
    UILabel *URLLabel = [[[UILabel alloc]initWithFrame:CGRectMake(80, 280, 180, 18)]autorelease];
    URLLabel.text = @"官方网站:www.duiai.com";
    URLLabel.font = [UIFont systemFontOfSize:15];
    URLLabel.textColor = RGBCOLOR(197, 197, 197);
    URLLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:URLLabel];
    
    UILabel *moreLabel = [[[UILabel alloc]initWithFrame:CGRectMake(100, 305, 130, 18)]autorelease];
    moreLabel.text = @"更多功能,请登陆官网";
    moreLabel.font = [UIFont systemFontOfSize:13];
    moreLabel.textColor = RGBCOLOR(197, 197, 197);
    moreLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:moreLabel];

 

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    self.navigationItem.title = @"关于我们";
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
