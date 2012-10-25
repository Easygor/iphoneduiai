//
//  WeiboBindingViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-24.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "WeiboBindingViewController.h"
#import "SetEmailViewController.h"
#import "CustomBarButtonItem.h"
#import "SinaWeibo.h"
@interface WeiboBindingViewController ()
@property(retain,nonatomic)IBOutlet UIButton *sinaWeiboButton;
@property(retain,nonatomic)IBOutlet UIButton *tengxunWeiboButton;
@property(retain,nonatomic)IBOutlet UIButton *qqzoneButton;
@property(retain,nonatomic)IBOutlet UIButton *weixinButton;
@property(retain,nonatomic)IBOutlet UIButton *mailButton;

@property(retain,nonatomic)IBOutlet UILabel *mailLabel;
@property(retain,nonatomic)IBOutlet UILabel *sinaWeiboLabel;
@property(retain,nonatomic)IBOutlet UILabel *tengxunWeiboLabel;
@property(retain,nonatomic)IBOutlet UILabel *qqzoneLabel;
@property(retain,nonatomic)IBOutlet UILabel *weixinLabel;


-(IBAction)sinaWeiboButtonPress;
-(IBAction)tengxunWeiboButtonPress;
-(IBAction)qqzoneButtonPress;
-(IBAction)weinxinButonnPress;
-(IBAction)mailButtonPress;
@end

@implementation WeiboBindingViewController

- (void)dealloc
{
    [_sinaWeiboButton release];
    [_tengxunWeiboButton release];
    [_qqzoneButton release];
    [_weixinButton release];
    [_mailButton release];
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
    
    self.navigationItem.title = @"绑定状态";
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

-(IBAction)sinaWeiboButtonPress
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSLog(@"%@", [keyWindow subviews]);
   
    
    SinaWeibo *sinaweibo = [[SinaWeibo alloc]initWithAppKey:@"1118660852" appSecret:@"1e650633c6c72cc28583bc1bdef21a38" appRedirectURI:@"http://www.cnblogs.com/smallyin00/" andDelegate:self];
    [sinaweibo logIn];
}

-(IBAction)tengxunWeiboButtonPress
{

}

-(IBAction)qqzoneButtonPress
{

}

-(IBAction)weinxinButonnPress
{

}

-(IBAction)mailButtonPress
{
    SetEmailViewController *setEmailViewController = [[[SetEmailViewController alloc]init]autorelease];
    [self.navigationController pushViewController:setEmailViewController animated:YES];

}
#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);

}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
}
@end
