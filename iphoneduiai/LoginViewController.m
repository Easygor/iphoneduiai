//
//  LoginViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImage+mergeImages.h"
#import "RegisterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LocationController.h"
#import "UIDevice+UIDeviceAppIndentifier.h"
#import "RegexKitLite.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "LocationController.h"
#import "ForgetPasswordViewController.h"

@interface LoginViewController () <UIAlertViewDelegate>
@property (retain, nonatomic) IBOutlet UIButton *forgotPasswordBtn;
@property (retain, nonatomic) IBOutlet UITextField *emailText;
@property (retain, nonatomic) IBOutlet UITextField *passwordText;
@property (retain, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) NSMutableSet *errors;

@end

@implementation LoginViewController
@synthesize forgotPasswordBtn;
@synthesize emailText;
@synthesize passwordText;
@synthesize errorLabel;
@synthesize errors=_errors;
@synthesize contentView,logoImgView;
- (void)dealloc {
    [forgotPasswordBtn release];
    [emailText release];
    [passwordText release];
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    // update the location
    if ([[LocationController sharedInstance] allow]) {
        [[[LocationController sharedInstance] locationManager] startUpdatingLocation];
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[[LocationController sharedInstance] locationManager] stopUpdatingLocation];
        });
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:self.view.window];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [self setForgotPasswordBtn:nil];
    [self setEmailText:nil];
    [self setPasswordText:nil];
    [self setErrorLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)forgotPasswordAction
{
//    NSLog(@"Forgot password");
    ForgetPasswordViewController *fpvc = [[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:nil];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:fpvc];
    nvc.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    nvc.navigationBar.layer.shadowOffset = CGSizeMake(0, 1.2);
    nvc.navigationBar.layer.shadowRadius = 1.5;
    nvc.navigationBar.layer.shadowOpacity = 0.25;
    nvc.navigationBar.layer.masksToBounds = NO;
    nvc.navigationBar.layer.shouldRasterize = YES;
    if ([nvc.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [nvc.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-top.png"] forBarMetrics:UIBarMetricsDefault];
    } else {
        [nvc.navigationBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-top.png"]] autorelease] atIndex:1];
    }
    [self presentModalViewController:nvc animated:YES];
    [fpvc release];
    [nvc release];
}

- (IBAction)loginAction
{
    if ([self canCommitData]) {
        [self loginRequest];
    }
}

- (IBAction)registerAction
{
    RegisterViewController *rvc = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:rvc];
    nvc.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    nvc.navigationBar.layer.shadowOffset = CGSizeMake(0, 1.2);
    nvc.navigationBar.layer.shadowRadius = 1.5;
    nvc.navigationBar.layer.shadowOpacity = 0.25;
    nvc.navigationBar.layer.masksToBounds = NO;
    nvc.navigationBar.layer.shouldRasterize = YES;
    if ([nvc.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [nvc.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-top.png"] forBarMetrics:UIBarMetricsDefault];
    } else {
        [nvc.navigationBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-top.png"]] autorelease] atIndex:1];
    }
    [self presentModalViewController:nvc animated:YES];
    [rvc release];
    [nvc release];
}



#pragma mark - textfield delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.passwordText resignFirstResponder];
    [self.emailText resignFirstResponder];
}

#define email_error_msg @"Email格式错误"
#define pass_error_msg @"密码不能为空"

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.emailText]) {
        // check passwd non empty
        NSString *emailRegex = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
        if(![textField.text isMatchedByRegex:emailRegex]){
//            [Utils warningNotification:@"错误的地址"];
            [self.errors addObject:email_error_msg];
        } else{
            [self.errors removeObject:email_error_msg];
        }
    } else if ([textField isEqual:self.passwordText]){
        NSString *whiteRegex = @"\\w+";
        if ([textField.text isMatchedByRegex:whiteRegex]) {
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
}

-(BOOL)canCommitData
{
    NSString *nonemptyRegex = @"\\w+";
    if ([self.emailText.text isMatchedByRegex:nonemptyRegex] &&
          [self.passwordText.text isMatchedByRegex:nonemptyRegex]
        && self.errors.count <= 0) {
        
        return YES;
    }
    
    return NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loginAction];
    [self.passwordText resignFirstResponder];
    [self.emailText resignFirstResponder];
    return NO;
}

#pragma mark - networking request
-(void)loginRequest
{
    if ([LocationController sharedInstance].allow) {
        CLLocationCoordinate2D curLocation = [[[LocationController sharedInstance] location] coordinate];
        [self loginRequestWithLocation:curLocation];
    } else{
        [self loginRequestWithLocation:CLLocationCoordinate2DMake(0.0, 0.0)];
    }
        
}

-(void)loginRequestWithLocation:(CLLocationCoordinate2D)curLocation
{
    NSString *model = [[UIDevice currentDevice] model];
    NSString *udid = [[UIDevice currentDevice] deviceApplicationIdentifier];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          model, @"devicename",
                          udid, @"deviceid",
                          [NSNumber numberWithFloat:curLocation.longitude], @"jin",
                          [NSNumber numberWithFloat:curLocation.latitude], @"wei",
                          self.emailText.text, @"username",
                          self.passwordText.text, @"password",
                          nil];
    
    RKParams *params = [RKParams paramsWithDictionary:data];
    
    // per
    [[RKClient sharedClient] post:[@"/login" stringByAppendingQueryParameters:[Utils queryParams]]
                       usingBlock:^(RKRequest *request){
                           // set params
                           [request setParams:params];
                           
                           // hud
                           [SVProgressHUD show];
                           // set successful block
                           [request setOnDidLoadResponse:^(RKResponse *response){
                               if (response.isOK && response.isJSON)
                               {
                                   NSDictionary *data = [[response bodyAsString] objectFromJSONString];
//                                   NSLog(@"res: %@", data);
                                   NSInteger code = [[data objectForKey:@"error"] intValue];
                                   if (0 == code)
                                   {
                                       NSDictionary *userinfo = @{
                                       @"accesskey": data[@"accesskey"],
                                       @"username":data[@"data"][@"username"],
                                       @"info": data[@"data"][@"userinfo"]};
                                       
                                       [[NSUserDefaults standardUserDefaults] setObject:userinfo  forKey:@"user"];
                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                       [SVProgressHUD dismiss];
                                       
                                        [self dismissModalViewControllerAnimated:YES];
                                   
                                   }
                                   else if (44 == code)
                                   {
                                       NSDictionary *usefulData = data[@"data"];
                                       NSDictionary *userinfo = @{
                                       @"accesskey": usefulData[@"accesskey"],
                                       @"username":usefulData[@"data"][@"username"],
                                       @"info": usefulData[@"data"][@"userinfo"]};
                                       
                                       [[NSUserDefaults standardUserDefaults] setObject:userinfo  forKey:@"user"];
                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                       [SVProgressHUD dismiss];
                                       
                                       UIAlertView *noteStartZ = [[UIAlertView alloc] initWithTitle:nil
                                                                                            message:data[@"message"]
                                                                                           delegate:self
                                                                                  cancelButtonTitle:@"取消"
                                                                                  otherButtonTitles:@"确定", nil];
                                       [noteStartZ show];
                                       [noteStartZ release];
                                   }
                                   else
                                   {
                                       [SVProgressHUD showErrorWithStatus:[data objectForKey:@"message"]];

                                   }

                               }
                               else
                               {
                                   [SVProgressHUD showSuccessWithStatus:@"网络错误"];
                               }
                           }];
                           
                           // set error block
                           [request setOnDidFailLoadWithError:^(NSError *error){
                                NSLog(@"Network Error: %@", [error localizedDescription]);
                           }];
                       }];
        // do somethign here
}

#pragma mark - UIAlertview
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex) {
        return;
    }
    
    NSMutableDictionary *dp = [Utils queryParams];
    [SVProgressHUD show];
    [[RKClient sharedClient] post:[@"/success/start.api" stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){
        NSMutableDictionary *updateArgs = [NSMutableDictionary dictionary];
        updateArgs[@"submitupdate"] = @"true";
        request.params = [RKParams paramsWithDictionary:updateArgs];
        
        // 请求失败时
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"Error: %@", [error description]);
        }];
        
        // 请求成功时
        [request setOnDidLoadResponse:^(RKResponse *response){
            
            if (response.isOK && response.isJSON)
            {
                NSDictionary *data = [response.bodyAsString objectFromJSONString];
                NSInteger code = [data[@"error"] integerValue]; 
                if (code == 0)
                {
                    [SVProgressHUD showSuccessWithStatus:data[@"message"]];
                }
                else
                {
                    // 失败的情况
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"网络故障"];
            }
        }];
        
    }];
}

# pragma mark - keyboard show event for resize the UI
- (void)keyboardWillShow:(NSNotification *)notif
{
    //keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
    
    NSValue *endingFrame = [[notif userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame;
    [endingFrame getValue:&frame];
    
    CGRect containerFrame = self.contentView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (frame.size.height + containerFrame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = containerFrame;
    }];
    
    [self.logoImgView setHidden:YES];
    
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    }];
    [self.logoImgView setHidden:NO];
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
@end
