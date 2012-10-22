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
                                                                                                action:@selector(saceAction)] autorelease];

    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    self.navigationItem.title = @"修改密码";
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark-
-(void)saceAction
{

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.confirmPassField resignFirstResponder];
    [self.passField resignFirstResponder];
    [self.oldPassField resignFirstResponder];
}

@end
