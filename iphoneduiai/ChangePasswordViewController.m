//
//  ChangePasswordViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-5.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "CustomBarButtonItem.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"


@interface ChangePasswordViewController () <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *oldPassField;
@property (retain, nonatomic) IBOutlet UITextField *passField;
@property (retain, nonatomic) IBOutlet UITextField *confirmPassField;

@end

@implementation ChangePasswordViewController

- (void)dealloc {
    [_oldPassField release];
    [_passField release];
    [_confirmPassField release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setOldPassField:nil];
    [self setPassField:nil];
    [self setConfirmPassField:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"保存"
                                                                                                target:self
                                                                                                action:@selector(saveAction)] autorelease];

    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];

    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"修改密码"];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark-
-(void)saveAction
{
    NSMutableDictionary *dp = [Utils queryParams];
    [SVProgressHUD show];
    [[RKClient sharedClient]post:[@"/common/setpasswd.api"
     stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){
     
    // 设置POST的form表单的参数 
     NSMutableDictionary *updateArgs = [NSMutableDictionary dictionary];
        updateArgs[@"password"] = self.oldPassField.text;
        updateArgs[@"newpassword"] = self.passField.text;
        updateArgs[@"confrimpassword"] = self.confirmPassField.text;
        updateArgs[@"submitupdate"] = @"true";
        
        request.params = [RKParams paramsWithDictionary:updateArgs];
        // 请求失败时
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"Error: %@", [error description]);
        }];
        // 请求成功时
        [request setOnDidLoadResponse:^(RKResponse *response){
            //            NSLog(@"kkk: %@", response.bodyAsString);
            if (response.isOK && response.isJSON) { // 200的返回并且是JSON数据
                NSDictionary *data = [response.bodyAsString objectFromJSONString]; // 提交后返回的状态
                NSInteger code = [data[@"error"] integerValue];  // 返回的状态
                if (code == 0) {
                    // 成功提交的情况
                    // ....
                    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.confirmPassField resignFirstResponder];
    [self.passField resignFirstResponder];
    [self.oldPassField resignFirstResponder];
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

@end
