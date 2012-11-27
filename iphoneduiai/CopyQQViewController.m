//
//  CopyQQViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-5.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "CopyQQViewController.h"
#import "SVProgressHUD.h"
#import "CustomBarButtonItem.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>

@interface CustomView :UIView
@end
@implementation CustomView
- (void)drawRect:(CGRect)rect
{
    //画长方形
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [RGBCOLOR(213, 213, 213) CGColor]);
    CGContextSetLineWidth(ctx, 1.0);
    CGPoint poins[] = {CGPointMake(0, 0),CGPointMake(280, 0),CGPointMake(280, 40),CGPointMake(0, 40)};
    CGContextAddLines(ctx,poins,4);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
    //画线
    CGContextMoveToPoint(ctx, 195, 0);
    CGContextAddLineToPoint(ctx, 195, 40);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextStrokePath(ctx);
}
@end
@interface CopyQQViewController ()

@end

@implementation CopyQQViewController
@synthesize QQdata;
-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    UIView *upView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 130)]autorelease];
    upView.backgroundColor = RGBCOLOR(250, 250, 250);
    upView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:upView];
    
    UILabel *myQQLabel  = [[[UILabel alloc]initWithFrame:CGRectMake(20, 30, 100, 16)]autorelease];
    myQQLabel.text = @"我的QQ是:";
    myQQLabel.backgroundColor = [UIColor clearColor];
    myQQLabel.opaque = YES;
    myQQLabel.textColor = RGBCOLOR(158, 210, 238);
    [upView addSubview:myQQLabel];
    
    CustomView *compositeView = [[[CustomView alloc]initWithFrame:CGRectMake(20, 55, 280, 40)]autorelease];
    compositeView.backgroundColor = [UIColor clearColor];
    [upView addSubview:compositeView];
    
    qqLabel = [[[UILabel alloc]initWithFrame:CGRectMake(10, 1, 190, 38)]autorelease];
    qqLabel.text = self.QQdata[@"data"][@"contact"];
    qqLabel.font = [UIFont systemFontOfSize:23];
    qqLabel.backgroundColor = [UIColor clearColor];
    [compositeView addSubview:qqLabel];
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    copyButton.frame = CGRectMake(195, 1, 84, 38);
    copyButton.backgroundColor = RGBCOLOR(240, 240, 240);
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton setTitle:@"复制" forState:UIControlStateHighlighted];
    [copyButton setTitleColor:RGBCOLOR(181, 181, 181) forState:UIControlStateNormal];
    [copyButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateHighlighted];
    [copyButton addTarget:self action:@selector(copyPress:) forControlEvents:UIControlEventTouchUpInside];
    [compositeView addSubview:copyButton];
    
    
    UILabel *tipLabel = [[[UILabel alloc]initWithFrame:CGRectMake(20, 100, 282, 300)]autorelease];
    tipLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    tipLabel.text = @"1.如果QQ无法联系到对方,您可以通过TA的邮箱:81168900@qq.com发邮件给她。您也可以通过QQ加TA的微信\n\n2.本次查看消耗一次查看机会，您今天还有6次查看他人联系方式机会！\n\n3.如果女方聊了没几句就着急见面，并把你领到一个‘你不熟悉的酒吧餐厅’,一定要立马闪人并向我们举报,以免遭受经济损失!";
    
    //文本阴影颜色
    tipLabel.shadowColor = [UIColor whiteColor];
    //阴影大小
    tipLabel.shadowOffset = CGSizeMake(0.0, 1.0);

    
    tipLabel.lineBreakMode = UILineBreakModeWordWrap;
    tipLabel.numberOfLines = 0;
    
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textColor = RGBCOLOR(174, 174, 174);
    [self.view addSubview:tipLabel];
  
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
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"查看QQ"];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)copyPress:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = qqLabel.text;
    
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];

}


@end
