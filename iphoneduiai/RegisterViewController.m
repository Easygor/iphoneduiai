//
//  RegisterViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "RegisterViewController.h"
#import "Step2ViewController.h"
#import "CustomBarButtonItem.h"
#import "RegexKitLite.h"
#import "SVProgressHUD.h"

static NSString *const wRegex = @"\\w+";
static NSString *const emailRegex = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";


@interface RegisterViewController ()
@property (retain, nonatomic) IBOutlet UITextField *emailText;
@property (retain, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) NSMutableSet *errors;
@property (retain, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation RegisterViewController
@synthesize emailText;
@synthesize passwordText;
@synthesize errors=_errors;
@synthesize errorLabel;

- (void)dealloc {
    [emailText release];
    [passwordText release];
    [_errors release];
    [errorLabel release];
    [super dealloc];
}

-(NSMutableSet *)errors
{
    if (_errors == nil) {
        _errors = [[NSMutableSet alloc] init];
        
    }
    return _errors;
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

    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"创建帐号"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"取消"
                                                                                             target:self
                                                                                             action:@selector(backAction)] autorelease];
    
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"下一步"
                                                                                                target:self
                                                                                                action:@selector(nextAction)] autorelease];
//    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSDictionary *d = [[NSUserDefaults standardUserDefaults] objectForKey:@"step1"];
    if (d) {
        self.emailText.text = [d objectForKey:@"username"];
        self.passwordText.text = [d objectForKey:@"password"];
//        [self checkInputs];
    }
}

- (void)viewDidUnload
{
    [self setEmailText:nil];
    [self setPasswordText:nil];
    [self setErrorLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:2];
    if ([self.emailText.text isMatchedByRegex:wRegex]) {
        [d setObject:self.emailText.text forKey:@"username"];
        [d setObject:self.passwordText.text forKey:@"password"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"step1"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - actions
-(void)backAction
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
//    [self.presentedViewController dismissModalViewControllerAnimated:YES];
}

- (void)nextAction
{
    if ([self checkInputs]) {
        Step2ViewController *s2vc = [[Step2ViewController alloc] initWithNibName:@"Step2ViewController" bundle:nil];
        [self.navigationController pushViewController:s2vc animated:YES];
        [s2vc release];
    } else{
        [SVProgressHUD showErrorWithStatus:@"请填写正确信息"];
    }
}


#pragma mark - textfield delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.passwordText resignFirstResponder];
    [self.emailText resignFirstResponder];
}

#define email_error_msg @"email格式错误"
#define pass_error_msg @"密码不能为空"

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.emailText]) {
        // check passwd non empty
        if(![textField.text isMatchedByRegex:emailRegex]){
            //            [Utils warningNotification:@"错误的地址"];
            [self.errors addObject:email_error_msg];
        } else{
            [self.errors removeObject:email_error_msg];
        }
    } else if ([textField isEqual:self.passwordText]){
        if ([textField.text isMatchedByRegex:wRegex]) {
            [self.errors removeObject:pass_error_msg];
        } else{
            [self.errors addObject:pass_error_msg];
        }
    }
    
    [self processError];
}

-(void)processError
{
    self.errorLabel.text = [[self.errors allObjects] componentsJoinedByString:@","];
    if ([self.errors count] <= 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

-(BOOL)checkInputs
{
    [self textFieldDidEndEditing:self.emailText];
    [self textFieldDidEndEditing:self.passwordText];
    
    // check passwd non empty
    if([self.emailText.text isMatchedByRegex:emailRegex] &&
       [self.passwordText.text isMatchedByRegex:wRegex] &&
       self.errors.count <= 0
       ){
        return YES;
    }
    
    return NO;
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self nextAction];
    [textField resignFirstResponder];
    return YES;
}
@end
