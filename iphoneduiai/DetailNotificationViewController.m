//
//  DetailNotificationViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-28.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "DetailNotificationViewController.h"
#import "CustomBarButtonItem.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "NSDate-Utilities.h"
#import "SVProgressHUD.h"
#import "UserDetailViewController.h"

@interface DetailNotificationViewController ()
@property (retain, nonatomic) IBOutlet UIView *containerView;
@property (retain, nonatomic) IBOutlet UIButton *agreeBtn;
@property (retain, nonatomic) IBOutlet UIButton *rejectBtn;

@end

@implementation DetailNotificationViewController
@synthesize timeLabel,titleLabel,contentLabel,headImgView;
@synthesize notificationData;
-(void)dealloc
{
    [headImgView release];
    [titleLabel release];
    [timeLabel release];
    [contentLabel release];
    [notificationData release];
    [_containerView release];
    [_agreeBtn release];
    [_rejectBtn release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"data: %@", self.notificationData);
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    CGFloat btnHeight = 0;
    if ([self.notificationData[@"msgcontent"] isEqualToString:@"agreecontact"] &&
        [self.notificationData[@"agent"] integerValue] == 1) {
        
        UIImage *bg = [[UIImage imageNamed:@"notice_btn"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
        UIImage *bgs = [[UIImage imageNamed:@"notice_btn_linked"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
        [self.agreeBtn setBackgroundImage:bg forState:UIControlStateNormal];
        [self.agreeBtn setBackgroundImage:bgs forState:UIControlStateHighlighted];
        [self.rejectBtn setBackgroundImage:bg forState:UIControlStateNormal];
        [self.rejectBtn setBackgroundImage:bgs forState:UIControlStateHighlighted];
        self.agreeBtn.hidden = NO;
        self.rejectBtn.hidden = NO;
        btnHeight = self.agreeBtn.frame.size.height + 5;
        
    } else
    {
        self.agreeBtn.hidden = YES;
        self.rejectBtn.hidden = YES;
    }

    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"通知详情"];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"target:self action:@selector(backAction)] autorelease];

    [self.headImgView loadImage:self.notificationData[@"photo"]];
    CGSize size = [self.notificationData[@"content"] sizeWithFont:self.contentLabel.font constrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, 400) lineBreakMode:UILineBreakModeCharacterWrap];
    CGRect contentFrame = self.contentLabel.frame;
    contentFrame.size.height = size.height;
    self.contentLabel.frame = contentFrame;
    
    CGRect containerFrame = self.containerView.frame;
    containerFrame.size.height = self.contentLabel.frame.origin.y + btnHeight + self.contentLabel.frame.size.height+23;
    self.containerView.frame = containerFrame;
    
    self.titleLabel.text  = self.notificationData[@"title"];
    self.contentLabel.text = self.notificationData[@"content"];
    self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:[self.notificationData[@"addtime"] integerValue]] stringForHuman];
    
    UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatarAction:)] autorelease];
    self.headImgView.userInteractionEnabled = YES;
    [self.headImgView addGestureRecognizer:singleTap];

}

- (void)tapAvatarAction:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        UserDetailViewController *udvc = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
        udvc.user = @{@"_id": self.notificationData[@"suid"], @"niname": @"", @"photo": self.notificationData[@"photo"]};
        [self.navigationController pushViewController:udvc animated:YES];
        [udvc release];
    }
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.notificationData[@"read"] integerValue] == 0) {
        NSMutableDictionary *params = [Utils queryParams];
        [params setObject:self.notificationData[@"tid"] forKey:@"tid[]"];
        //            [SVProgressHUD show];
        [[RKClient sharedClient] post:[@"/common/readnotice.api" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
//            NSLog(@"url: %@", request.URL);
            
            request.params = [RKParams paramsWithDictionary:@{@"tid" : self.notificationData[@"tid"], @"submitupdate": @"true"}];
            
            [request setOnDidLoadResponse:^(RKResponse *response){

                if (response.isOK && response.isJSON) {
                    NSDictionary *data = [[response bodyAsString] objectFromJSONString];
                    //                        NSLog(@"read data: %@", data[@"message"]);
                    NSInteger code = [data[@"error"] integerValue];
                    if (code == 0) {
                        self.notificationData[@"read"] = @"1";
                        //                            [SVProgressHUD dismiss];
                    } else{
                        //                            [SVProgressHUD showErrorWithStatus:data[@"message"]];
                    }
                    
                } else{
                    //                        [SVProgressHUD showErrorWithStatus:@"获取失败"];
                }
            }];
            [request setOnDidFailLoadWithError:^(NSError *error){
                //                    [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
                NSLog(@"Error: %@", [error description]);
            }];
        }];
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)answerWith:(NSString*)v
{
    NSMutableDictionary *params = [Utils queryParams];
    [params setObject:self.notificationData[@"tid"] forKey:@"tid[]"];
    [SVProgressHUD show];
    [[RKClient sharedClient] post:[@"/common/agreeview.api" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
//        NSLog(@"url: %@", request.URL);
        
        request.params = [RKParams paramsWithDictionary:@{@"msgid" : self.notificationData[@"tid"], @"agree": v, @"submitupdate": @"true"}];
        
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSDictionary *data = [[response bodyAsString] objectFromJSONString];
                //                        NSLog(@"read data: %@", data[@"message"]);
                NSInteger code = [data[@"error"] integerValue];
                if (code == 0) {
                    [SVProgressHUD dismiss];
                    [self.navigationController popViewControllerAnimated:YES];
                } else{
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
            } else{
                [SVProgressHUD showErrorWithStatus:@"获取失败"];
            }
        }];
        [request setOnDidFailLoadWithError:^(NSError *error){
            [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
            NSLog(@"Error: %@", [error description]);
        }];
    }];

}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (IBAction)rejectAction
{

    [self answerWith:@"no"];
}

- (IBAction)agreeAction:(id)sender
{
    [self answerWith:@"yes"];
}

- (void)viewDidUnload {
    [self setContainerView:nil];
    [self setAgreeBtn:nil];
    [self setRejectBtn:nil];
    [super viewDidUnload];
}
@end
