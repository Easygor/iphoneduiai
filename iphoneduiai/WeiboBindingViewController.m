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
#import "SinaWeiboRequest.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"


@interface WeiboBindingViewController () <SinaWeiboDelegate, WBRequestDelegate, SinaWeiboRequestDelegate>
@property(retain,nonatomic)IBOutlet UIButton *sinaWeiboButton;
@property(retain,nonatomic)IBOutlet UIButton *tengxunWeiboButton;

@property(retain,nonatomic)IBOutlet UILabel *sinaWeiboLabel;
@property(retain,nonatomic)IBOutlet UILabel *tengxunWeiboLabel;


@property (strong, nonatomic) NSDictionary *txUserInfo;


@property (nonatomic, retain) TCWBEngine *weiboEngine;
@property (strong, nonatomic) SinaWeibo *sinaWeibo;

@end

@implementation WeiboBindingViewController

- (void)dealloc
{
    [_txUserInfo release];
    [_sinaWeiboButton release];
    [_tengxunWeiboButton release];
    [_weiboEngine release], _weiboEngine = nil;
    [_sinaWeibo release];
    [super dealloc];
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


    
    // init weibos
    NSDictionary *sinaInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"sinaweibo"];
    if (sinaInfo) {
        self.sinaWeiboLabel.text = sinaInfo[@"name"];
    }
    
    NSDictionary *txInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"txweibo"];
    if (txInfo) {
        self.tengxunWeiboLabel.text = txInfo[@"name"];
    }
    
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
   
//    
     self.sinaWeibo = [[[SinaWeibo alloc]initWithAppKey:@"2333922239"
                                              appSecret:@"9b6ae0efc4ff7264c979ccda7c4d88eb"
                                         appRedirectURI:@"http://duiai.com"
                                            andDelegate:self] autorelease];
//    self.sinaWeibo = [[SinaWeibo alloc]initWithAppKey:@"1118660852" appSecret:@"1e650633c6c72cc28583bc1bdef21a38" appRedirectURI:@"http://www.cnblogs.com/smallyin00/" andDelegate:self];

    [self.sinaWeibo logIn];

}

-(IBAction)tengxunWeiboButtonPress
{

    TCWBEngine *engine = [[TCWBEngine alloc] initWithAppKey:@"801242204"
                                                  andSecret:@"90730f2b629d0ab0b07cb5feb3ee3c9b"
                                             andRedirectUrl:@"http://duiai.com/bindsuccess"];
    [engine setRootViewController:self];
    self.weiboEngine = engine;
    [engine release];
    
    [self.weiboEngine logInWithDelegate:self
                              onSuccess:@selector(onSuccessLogin)
                              onFailure:@selector(onFailureLogin:)];


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


    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
//        [userInfo release], userInfo = nil;
        NSLog(@"sina weibo error");
    }

}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
//        [userInfo release];
//        NSLog(@"sina result: %@", result);
        NSString *url = [@"http://weibo.com/" stringByAppendingString:request.sinaweibo.userID];
        [[NSUserDefaults standardUserDefaults] setObject:@{@"name": result[@"name"], @"gender": result[@"gender"],
         @"link": url, @"accesstoken": request.sinaweibo.accessToken}
                                                  forKey:@"sinaweibo"];
        self.sinaWeiboLabel.text = result[@"name"];
        [self updateBindInfo:@"opensinaweibo" url:url];
    }

}

#pragma mark - method
- (void)onSuccessLogin
{

    NSString *url = [@"http://t.qq.com/" stringByAppendingString:self.weiboEngine.name];
    [[NSUserDefaults standardUserDefaults] setObject:@{@"name": self.weiboEngine.name,
     @"link": url, @"accesstoken": self.weiboEngine.accessToken}
                                              forKey:@"txweibo"];
    self.tengxunWeiboLabel.text = self.weiboEngine.name;
    [self updateBindInfo:@"opentweibo" url:url];
}

- (void)onFailureLogin:(NSError *)error
{
    NSLog(@"tx Login error:%@", [error description]);
}

#pragma mark - update bind info
- (void)updateBindInfo:(NSString*)bindType url:(NSString*)url
{
    // update the user info
    NSMutableDictionary *dp = [Utils queryParams];
    [SVProgressHUD show];
    [[RKClient sharedClient] post:[@"/uc/updatebind.api" stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){
        
        
        request.params = [RKParams paramsWithDictionary:@{@"submitupdate": @"true", @"url": url, @"bindtype": bindType}];
        
        // 请求失败时
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"Error: %@", [error description]);
        }];
        
        // 请求成功时
        [request setOnDidLoadResponse:^(RKResponse *response){
            
            if (response.isOK && response.isJSON) { // 200的返回并且是JSON数据
                NSDictionary *data = [response.bodyAsString objectFromJSONString]; // 提交后返回的状态
                NSInteger code = [data[@"error"] integerValue];  // 返回的状态
                if (code == 0) {
                    // 成功提交的情况
                    [SVProgressHUD showSuccessWithStatus:data[@"message"]];
                } else{
                    // 失败的情况
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
            } else{
                [SVProgressHUD showErrorWithStatus:@"网络故障"];
            }
        }];
        
    }];
}

@end
