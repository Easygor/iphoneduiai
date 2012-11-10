//
//  QQSetViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "QQSetViewController.h"
#import "CustomBarButtonItem.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "HZPopPickerView.h"
#import "HZNumberPickerView.h"

@interface QQSetViewController () <UITextFieldDelegate, HZNumberPickerDelegate, HZPopPickerDatasource, HZPopPickerDelegate>
@property (retain, nonatomic) IBOutlet UITextField *qqField;
@property (retain, nonatomic) IBOutlet UITextField *qqEableField;
@property (retain, nonatomic) IBOutlet UITextField *qqNumField;

@property (strong, nonatomic) HZPopPickerView *qqEablePicker;
@property (strong, nonatomic) NSString *qqEableNum;
@property (nonatomic) NSInteger qqNumNum;
@property (strong, nonatomic) HZNumberPickerView *qqNumPicker;
@property (strong, nonatomic) NSMutableDictionary *contacts;

@end

@implementation QQSetViewController

- (void)dealloc {
    [_contacts release];
    [_qqNumPicker release];
    [_qqEablePicker release];
    [_qqEableNum release];
    [_qqField release];
    [_qqEableField release];
    [_qqNumField release];
    [super dealloc];
}

- (HZPopPickerView *)qqEablePicker
{
    if (_qqEablePicker == nil) {
        _qqEablePicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _qqEablePicker;
}

- (HZNumberPickerView *)qqNumPicker
{
    if (_qqNumPicker == nil) {
        _qqNumPicker = [[HZNumberPickerView alloc] initWithMinNum:1 maxNum:11];
        _qqNumPicker.delegate = self;
        _qqNumPicker.titleLabel.text = @"查看次数";
    }
    
    return _qqNumPicker;
}

- (void)setContacts:(NSMutableDictionary *)contacts
{
    if (![_contacts isEqualToDictionary:contacts]) {
        _contacts = [contacts retain];
        
        self.qqField.text = contacts[@"contact"];
        self.qqNumField.text = [NSString stringWithFormat:@"%@次", contacts[@"maxview"]];
        // do here
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"保存"
                                                                                                target:self
                                                                                                action:@selector(saveAction)] autorelease];
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"QQ设置"];
    
    [self getAllContact];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction
{

    NSMutableDictionary *dp = [Utils queryParams];
    [SVProgressHUD show];
    [[RKClient sharedClient] post:[@"/uc/allcontact.api" stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){
        
        // 设置POST的form表单的参数 
        NSMutableDictionary *updateArgs = [NSMutableDictionary dictionary];
        if (self.qqEableNum) {
            updateArgs[@"settheweek"] = self.qqEableNum;
        }
        
        if (self.qqNumNum) {
            updateArgs[@"maxview"] = @(self.qqNumNum);
        }
        updateArgs[@"contact"] = self.qqField.text;
        updateArgs[@"contact_type"] = @"qq";
        updateArgs[@"submitupdate"] = @"true";
        
        request.params = [RKParams paramsWithDictionary:updateArgs];
        
        // 请求失败时
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"Error: %@", [error description]);
        }];
        
        // 请求成功时
        [request setOnDidLoadResponse:^(RKResponse *response){

            if (response.isOK && response.isJSON) { // 200的返回并且是JSON数据
                NSDictionary *data = [response.bodyAsString objectFromJSONString]; // 提交后返回的状态
                NSInteger code = [data[@"error"] integerValue];  // 返回的状态
                if (code == 1) {
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

- (void)viewDidUnload {
    [self setQqField:nil];
    [self setQqEableField:nil];
    [self setQqNumField:nil];
    [super viewDidUnload];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.qqField]) {
        return YES;
    } else{
        if ([textField isEqual:self.qqEableField]) {
            // here
            [self.qqEablePicker show];
        } else if ([textField isEqual:self.qqNumField]){
            // do here
            [self.qqNumPicker show];
        }
        return NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.qqField resignFirstResponder];
}


#pragma mark pop picker view
- (NSArray *)popPickerData:(HZPopPickerView *)picker
{
    
    if ([picker isEqual:self.qqEablePicker]) {
        
        return @[@{@"label": @"-1", @"desc": @"每天"}, @{@"label": @"1", @"desc": @"星期一"}, @{@"label": @"2", @"desc": @"星期二"},
        @{@"label": @"3", @"desc": @"星期三"}, @{@"label": @"4", @"desc": @"星期四"},
        @{@"label": @"5", @"desc": @"星期五"}, @{@"label": @"6", @"desc": @"星期六"}, @{@"label": @"7", @"desc": @"星期天"}];
    } 
    
    return nil;
    
}

- (NSString *)titleForPopPicker:(HZPopPickerView *)picker
{
    if ([picker isEqual:self.qqEablePicker]) {
        return @"哪天可查看";
    }
    
    return nil;
}

- (void)popPickerDidChangeStatus:(HZPopPickerView *)picker withLabel:(NSString *)label withDesc:(NSString *)desc
{
    if ([picker isEqual:self.qqEablePicker]) {
        self.qqEableNum = label;
        self.qqEableField.text = desc;
        
    }
}

#pragma mark - number delegate
- (void)numberPickerDidChange:(HZNumberPickerView *)picker
{
    if ([picker isEqual:self.qqNumPicker]) {
        self.qqNumField.text = [NSString stringWithFormat:@"%d次", picker.curNum];
        self.qqNumNum = picker.curNum;
    } 
    
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (void)getAllContact
{
    NSMutableDictionary *dParams = [Utils queryParams];
    
    [[RKClient sharedClient] get:[@"/uc/allcontact.api" stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSMutableDictionary *data = [[response bodyAsString] mutableObjectFromJSONString];
//                NSLog(@"qq data: %@", data);
                NSInteger code = [[data objectForKey:@"error"] integerValue];
                if (code == 0) {
                    self.contacts = data[@"data"];
//                    NSDictionary *dataData = [data objectForKey:@"data"];
                } else{
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
            }
        }];
        
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"error: %@", [error description]);
        }];
        
    }];
}

@end
