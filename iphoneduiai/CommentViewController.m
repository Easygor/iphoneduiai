//
//  CommentViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-26.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "CommentViewController.h"
#import "SVProgressHUD.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "CustomBarButtonItem.h"

@interface CommentViewController ()

@end

@implementation CommentViewController


-(void)dealloc
{
    [_bgView release];
    [_contentView release];
    [_toolView release];
    [_idStr release];
    [super dealloc];
}


-(void)loadView
{
    [super loadView];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 165)];
    
    self.contentView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, 310, 50)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.contentView];
    
    self.toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 140, 320, 40)];
    self.toolView.backgroundColor = RGBCOLOR(246, 246, 246);
    [self.bgView addSubview:self.toolView];
    
    UIButton *picButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [picButton setImage:[UIImage imageNamed:@"messages_toolbar_emoticonbutton_background"] forState:UIControlStateNormal];
    [picButton setImage:[UIImage imageNamed:@"messages_toolbar_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted ];
    picButton.frame = CGRectMake(20, 12, 24, 24);
    [picButton addTarget:self action:@selector(picSelect:)forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolView addSubview:picButton];
    [self.view addSubview:self.bgView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"发表评论"];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"发布"target:self action:@selector(sendButtonPress:)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"取消"target:self action:@selector(backAction)] autorelease];
    [self.contentView becomeFirstResponder];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendButtonPress:(id)sender
{
    NSMutableDictionary *dp = [Utils queryParams];
    [SVProgressHUD show];
    [[RKClient sharedClient] post:[@"/v/reply.api" stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){
        
        // 设置POST的form表单的参数
        NSMutableDictionary *updateArgs = [NSMutableDictionary dictionary];
        if (self.contentView.text) {
            updateArgs[@"replaycontent"] = self.contentView.text;
        }
        updateArgs[@"id"] = self.idStr;
        updateArgs[@"replay"] = @"yes";
        updateArgs[@"submitupdate"] = @"true";
        request.params = [RKParams paramsWithDictionary:updateArgs];
        
        // 请求失败时
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"Error: %@", [error description]);
        }];
        
        // 请求成功时
        [request setOnDidLoadResponse:^(RKResponse *response){
            NSLog(@"error: %@", response.bodyAsString);
            if (response.isOK && response.isJSON) { // 200的返回并且是JSON数据
                NSDictionary *data = [response.bodyAsString objectFromJSONString]; // 提交后返回的状态
                NSInteger code = [data[@"error"] integerValue];  // 返回的状态
                if (code == 0) {
                    // 成功提交的情况
                    // ....
                    [SVProgressHUD showSuccessWithStatus:@"评论成功"];
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

#pragma mark - key board notice
-(void)keyboardWillShow:(NSNotification*)note
{
    CGRect r = CGRectZero;
    [[note.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] getValue:&r];
    
    CGRect rect = self.toolView.frame;
    rect.origin.y = 460 - 85 - r.size.height ;
    self.toolView.frame = rect;
    
    CGRect rect2 = self.contentView.frame;
    rect2.size.height = 350-r.size.height;
    self.contentView.frame = rect2;
   }


@end
