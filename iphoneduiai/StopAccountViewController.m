//
//  StopAccountViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-5.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "StopAccountViewController.h"
#import "SendSuggestViewController.h"
@interface StopAccountViewController ()

@end

@implementation StopAccountViewController

-(void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 290, 80)];
    tipLabel.text = @"如果您已找到对象或不需要我们，可以随时停用账号。账号停用后，你的资料将被注销，任何人都无法在搜索和联系到您。\n在您再次需要我们的时候您可以随时启用账号。";
    
    tipLabel.textColor = RGBCOLOR(182, 182, 182);
    tipLabel.lineBreakMode = UILineBreakModeWordWrap;
    tipLabel.numberOfLines = 0;

    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:tipLabel];
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stopButton.frame = CGRectMake(10, 120, 300, 44);
    stopButton.backgroundColor =RGBCOLOR(226, 86, 89);
    
    [stopButton setTitle:@"停用账号" forState:UIControlStateNormal];
    stopButton.titleLabel.textColor = [UIColor whiteColor];
    [stopButton addTarget:self action:@selector(stopPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
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

-(void)stopPress
{
    SendSuggestViewController *sendSuggestViewController = [[[SendSuggestViewController alloc]init]autorelease];
    [self.navigationController pushViewController:sendSuggestViewController animated:YES];
}

@end
