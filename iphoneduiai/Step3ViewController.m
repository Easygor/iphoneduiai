//
//  Step3ViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "Step3ViewController.h"
#import "CustomBarButtonItem.h"
#import "NSDate-Utilities.h"
#import "RegexKitLite.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "LocationController.h"
#import "UIDevice+UIDeviceAppIndentifier.h"

static NSString *const wRegex = @"\\w+";
static NSString *const cnRegex = @"^([\u4e00-\u9fa5]|\\w){1,8}$";
static NSString *const qqRegex = @"[1-9][0-9]{4,}";

@interface Step3ViewController ()
@property (retain, nonatomic) IBOutlet UILabel *errorLabel;
@property (retain, nonatomic) IBOutlet UITextField *nickText;
@property (retain, nonatomic) IBOutlet UITextField *qqText;
@property (strong, nonatomic) NSMutableSet *errors;
@property (nonatomic) BOOL notSave;

@end

@implementation Step3ViewController
@synthesize errorLabel;
@synthesize nickText;
@synthesize qqText;
@synthesize errors=_errors;

- (void)dealloc {
    [errorLabel release];
    [nickText release];
    [qqText release];
    [_errors release];
    [super dealloc];
}

-(NSMutableSet *)errors
{
    if (_errors == nil) {
        _errors = [[NSMutableSet alloc] init];
        
    }
    return _errors;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"昵称及联系方式"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"完成"
                                                                                                target:self
                                                                                                action:@selector(nextAction)] autorelease];
   self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSDictionary *d = [[NSUserDefaults standardUserDefaults] objectForKey:@"step3"];
    if (d) {
        self.nickText.text = [d objectForKey:@"nickname"];
        self.qqText.text = [d objectForKey:@"qq"];
        
        if (self.errors.count <=0 ) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setErrorLabel:nil];
    [self setNickText:nil];
    [self setQqText:nil];
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

-(void)viewDidDisappear:(BOOL)animated
{
    if (!self.notSave) {
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        if ([self.nickText.text isMatchedByRegex:wRegex]){
            [d setObject:self.nickText.text forKey:@"nickname"];
        }
        
        if ([self.qqText.text isMatchedByRegex:wRegex]) {
            [d setObject:self.qqText.text forKey:@"qq"];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"step3"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [super viewDidDisappear:YES];
}

#pragma mark - actions
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.presentedViewController dismissModalViewControllerAnimated:YES];
}



-(void)processError
{
    self.errorLabel.text = [[self.errors allObjects] componentsJoinedByString:@","];
    if ([self.errors count] <= 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}


- (void)nextAction
{
    if ([self checkinputs]) {
        [self registerRequest];
    } else{
        [SVProgressHUD showErrorWithStatus:@"请填写信息"];
    }
}

-(BOOL)checkinputs
{
    [self textFieldDidEndEditing:self.nickText];
    [self textFieldDidEndEditing:self.qqText];
    
    if ([self.nickText.text isMatchedByRegex:wRegex] &&
        [self.qqText.text isMatchedByRegex:wRegex] &&
        self.errors.count <= 0) {
        return YES;
    }
    
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.nickText resignFirstResponder];
    [self.qqText resignFirstResponder];
}

#pragma mark - textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self nextAction];
    [textField resignFirstResponder];
    return YES;
}

#define nonc_error_msg @"昵称不对(8个以内的汉字、英文字母或下划线组成)"
#define qq_error_msg @"QQ号不正确"

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.nickText]) {
        // check passwd non empty
        if([textField.text isMatchedByRegex:cnRegex]){
            [self.errors removeObject:nonc_error_msg];
        } else{
            [self.errors addObject:nonc_error_msg];
        }
    } else if ([textField isEqual:self.qqText]){
        if ([textField.text isMatchedByRegex:qqRegex]) {
            [self.errors removeObject:qq_error_msg];
        } else{
            [self.errors addObject:qq_error_msg];
        }
    }
    
    [self processError];
}

#pragma mark - process request
-(NSMutableDictionary *)collectPostData
{
    NSDictionary *step1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"step1"];
    NSDictionary *step2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"step2"];
//    NSLog(@"step1: %@", step1);
//    NSLog(@"step2: %@", step2);
    //
    NSMutableDictionary *dParmas = [NSMutableDictionary dictionary];
    [dParmas setObject:[step1 objectForKey:@"username"] forKey:@"username"];
    [dParmas setObject:[step1 objectForKey:@"password"] forKey:@"password"];
    [dParmas setObject:[step1 objectForKey:@"password"] forKey:@"confirmpass"];
    
    [dParmas setObject:[step2 objectForKey:@"sex"] forKey:@"sex"];
    
    NSDate *birthday = [step2 objectForKey:@"birthday"];
    [dParmas setObject:[NSNumber numberWithInteger:birthday.year] forKey:@"year"];
    [dParmas setObject:[NSNumber numberWithInteger:birthday.month] forKey:@"month"];
    [dParmas setObject:[NSNumber numberWithInteger:birthday.day] forKey:@"day"];
    
    [dParmas setObject:[step2 objectForKey:@"height"] forKey:@"height"];
    [dParmas setObject:[step2 objectForKey:@"degree"] forKey:@"degree"];
    [dParmas setObject:[step2 objectForKey:@"income"] forKey:@"income"];
    
    NSDictionary *location = [step2 objectForKey:@"location"];
    [dParmas setObject:[location objectForKey:@"stateId"] forKey:@"province"];
    [dParmas setObject:[location objectForKey:@"cityId"] forKey:@"city"];
    [dParmas setObject:[location objectForKey:@"areaId"] forKey:@"area"];
    
    [dParmas setObject:@"1" forKey:@"marriage"];
    [dParmas setObject:@"qq" forKey:@"contact_type"];
    
    [dParmas setObject:self.nickText.text forKey:@"nickname"];
    [dParmas setObject:self.qqText.text forKey:@"contact"];
    
    return dParmas;
    
}

-(void)clearRegisterData
{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"step1"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"step2"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"step3"];
    self.notSave = YES;
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)registerRequest
{
    [[RKClient sharedClient] post:[@"/reg?" stringByAppendingFormat:@"appid=%@&key=%@&pass=%@&date=%@", APPID, KEY, PASS, [Utils curDateParam]]
                       usingBlock:^(RKRequest *request){
                           // set post params
                           request.params = [RKParams paramsWithDictionary:[self collectPostData]];
                           
                           [SVProgressHUD show];
                           [request setOnDidLoadResponse:^(RKResponse *resp){
                               
                               if (resp.isOK && resp.isJSON) {
                                   NSDictionary *data = [[resp bodyAsString] objectFromJSONString];
//                                   NSLog(@"data: %@", data);
                                   if ([[data objectForKey:@"error"] integerValue] == 0) {
                                       [SVProgressHUD showSuccessWithStatus:[data objectForKey:@"message"]];
                                       [self performSelector:@selector(loginRequest) withObject:nil afterDelay:0.5];
                                   } else{
                                       [SVProgressHUD showErrorWithStatus:[data objectForKey:@"message"]];
                                   }
                               }
                               
                           }];
                           
                           [request setOnDidFailLoadWithError:^(NSError *error){
                               NSLog(@"Register Error: %@", [error description]);
                               
                           }];
                       }];
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
    
    NSDictionary *step1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"step1"];
    NSDictionary *dParams = [NSDictionary dictionaryWithObjectsAndKeys:
                          model, @"devicename",
                          udid, @"deviceid",
                          [NSNumber numberWithFloat:curLocation.longitude], @"jin",
                          [NSNumber numberWithFloat:curLocation.latitude], @"wei",
                          step1[@"username"], @"username",
                          step1[@"password"], @"password",
                          nil];
    
    RKParams *params = [RKParams paramsWithDictionary:dParams];
    
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
                                       
                                       // save username & password
                                       NSDictionary *step1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"step1"];
                                       [[NSUserDefaults standardUserDefaults] setObject:step1
                                                                                 forKey:@"up"];
                                       [[NSUserDefaults standardUserDefaults] setObject:userinfo  forKey:@"user"];
                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                       [SVProgressHUD dismiss];
                                       

                                       [self.navigationController.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
                                       
                                   }
                                   else
                                   {
                                      [SVProgressHUD showErrorWithStatus:[data objectForKey:@"message"]];
                                       [self.navigationController dismissModalViewControllerAnimated:YES];

                                       
                                   }
                                   [self clearRegisterData];
                                   // clear data on here
//                                  [self performSelector:@selector(clearRegisterData) withObject:nil afterDelay:0.5];
                                   
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


@end
