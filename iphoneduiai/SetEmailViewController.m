//
//  SetEmailViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-7.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "SetEmailViewController.h"

@interface SetEmailViewController ()

@end

@implementation SetEmailViewController


-(void)loadView
{
    [super loadView];
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    UIView *emailView = [[UIView alloc]initWithFrame:CGRectMake(10, 15, 300, 44)];
    emailView.backgroundColor = [UIColor whiteColor];
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 15, 40, 15)];
    emailLabel.text = @"邮箱";
    emailLabel.font = [UIFont systemFontOfSize:15];
    UITextField *emailField = [[UITextField alloc]initWithFrame:CGRectMake(80, 15, 170, 15)];
    emailField.textColor = RGBCOLOR(179, 179, 179);
    [emailView addSubview:emailLabel];
    [emailView addSubview:emailField];
    [emailField becomeFirstResponder ];
    [self.view addSubview:emailView];
    
    UIButton *verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    verifyButton.frame = CGRectMake(10, 70, 300, 44);
    verifyButton.backgroundColor =RGBCOLOR(191, 235, 114);
    [verifyButton setTitle:@"主动验证邮箱" forState:UIControlStateNormal];
    [self.view addSubview:verifyButton];
    
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, 300, 60)];
    tipLabel.text =  @"邮箱用来登陆对爱和找回密码的唯一账号。\n如需要更改邮件绑定，请使用新邮箱发送一封标题为100010310的邮件到love@duiai.com,发送成功后即可自动绑定。\n更换绑定后，请使用新邮箱登陆。";
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    tipLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    tipLabel.font = [UIFont systemFontOfSize:11];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.shadowColor = [UIColor whiteColor];
    tipLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    
    [self.view addSubview:tipLabel];
    
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
