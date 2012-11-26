//
//  ForgetPasswordViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-11-25.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "SVProgressHUD.h"
#import "CustomBarButtonItem.h"

@interface ForgetPasswordViewController () <UIWebViewDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ForgetPasswordViewController

- (void)dealloc {
    [_webView release];
    [_urlString release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    

    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    NSString *titleString = nil;
    if (self.urlString)
    {
        titleString = @"微博";
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    }
    else
    {
        titleString = @"找回密码";
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://duiai.com/login/getpassword.html"]]];
    }
    
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:titleString];

}

- (void)backAction
{
    if (self.urlString) {
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        [self dismissModalViewControllerAnimated:YES];
    }

}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"加载页面出错"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}


- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
