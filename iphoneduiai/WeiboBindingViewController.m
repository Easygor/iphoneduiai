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
#import "TCWBEngine.h"


@interface WeiboBindingViewController () <SinaWeiboDelegate, WBRequestDelegate>
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

@property (nonatomic, retain) TCWBEngine   *weiboEngine;
@property (strong, nonatomic) SinaWeibo *sinaWeibo;
@end

@implementation WeiboBindingViewController

- (void)dealloc
{
    [_sinaWeiboButton release];
    [_tengxunWeiboButton release];
    [_qqzoneButton release];
    [_weixinButton release];
    [_mailButton release];
     [_weiboEngine release], _weiboEngine = nil;
    [_sinaWeibo release];
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
    
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"绑定状态"];
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
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    NSLog(@"%@", [keyWindow subviews]);
   
    
     self.sinaWeibo = [[[SinaWeibo alloc]initWithAppKey:@"495574251"
                                              appSecret:@"d5f062ce2c9898709159c459eb71c8cc"
                                         appRedirectURI:@"http://duiai.com"
                                            andDelegate:self] autorelease];

    [self.sinaWeibo logIn];

}

-(IBAction)tengxunWeiboButtonPress
{

    TCWBEngine *engine = [[TCWBEngine alloc] initWithAppKey:@"801242204"
                                                  andSecret:@"90730f2b629d0ab0b07cb5feb3ee3c9b"
                                             andRedirectUrl:@"http://duiai.com"];
    [engine setRootViewController:self];
    self.weiboEngine = engine;
    [engine release];
    
    [self.weiboEngine logInWithDelegate:self
                              onSuccess:@selector(onSuccessLogin)
                              onFailure:@selector(onFailureLogin:)];


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
    // upload info
    // update locale info
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
}

#pragma mark - method
- (void)onSuccessLogin
{
    NSLog(@"Login successs");
    // upload info
    // update locale info
}

- (void)onFailureLogin:(NSError *)error
{
    NSLog(@"Login error:%@", [error description]);
}

@end
