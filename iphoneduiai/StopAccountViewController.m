//
//  StopAccountViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-5.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "StopAccountViewController.h"
#import "CustomBarButtonItem.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "SendSuggestViewController.h"


@interface StopAccountViewController ()

@end

@implementation StopAccountViewController

-(void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    UILabel *tipLabel = [[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 290, 80)] autorelease];
    tipLabel.text = @"如果您已找到对象或不需要我们，可以随时停用账号。账号停用后，你的资料将被注销，任何人都无法在搜索和联系到您。\n在您再次需要我们的时候您可以随时启用账号。";
    
    tipLabel.textColor = RGBCOLOR(153, 153, 153);
    tipLabel.lineBreakMode = UILineBreakModeWordWrap;
    tipLabel.numberOfLines = 0;

    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.opaque = YES;
    [self.view addSubview:tipLabel];
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stopButton.frame = CGRectMake(9, 120, 302, 48);
//    stopButton.backgroundColor =RGBCOLOR(226, 86, 89);
    
    [stopButton setTitle:@"停用账号" forState:UIControlStateNormal];
    [stopButton setTitle:@"停用账号" forState:UIControlStateHighlighted];
    [stopButton setBackgroundImage:[UIImage imageNamed:@"red_btn"] forState:UIControlStateNormal];
    stopButton.titleLabel.textColor = [UIColor whiteColor];
    [stopButton addTarget:self action:@selector(stopPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    
    /*
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testButton.backgroundColor = [UIColor grayColor];
    testButton.frame = CGRectMake(10, 300, 300, 44);
    [testButton addTarget:self action:@selector(testPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    */

    
    UILabel *bTipLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 184, 300, 10)] autorelease];
    bTipLabel.textColor = RGBCOLOR(204, 204, 204);
    bTipLabel.backgroundColor = [UIColor clearColor];
    bTipLabel.opaque = YES;
    bTipLabel.textAlignment = UITextAlignmentCenter;
    bTipLabel.font = [UIFont systemFontOfSize:10.0f];
    bTipLabel.text = @"这个世界，充满了诡谲，只有爱情，永远天真";
    bTipLabel.shadowColor = [UIColor whiteColor];
    bTipLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    [self.view addSubview:bTipLabel];
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
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];

    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"停用帐号"];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)stopPress
{
    SendSuggestViewController *sendSuggestViewController = [[SendSuggestViewController alloc]init];
    [self.navigationController pushViewController:sendSuggestViewController animated:YES];
}
-(void)testPress
{
    NSMutableDictionary *dParams = [Utils queryParams];
    
    [[RKClient sharedClient] get:[@"/success/start.api" stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
        [request setOnDidLoadResponse:^(RKResponse *response){
        }];
        
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"error: %@", [error description]);
        }];
        
    }];
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

@end
