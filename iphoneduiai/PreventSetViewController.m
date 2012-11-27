//
//  RemindViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "PreventSetViewController.h"
#import "CustomBarButtonItem.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "HZPopPickerView.h"
#import "HZNumberPickerView.h"
#import "HZTimeSectionPickerView.h"

@interface PreventSetViewController () <UITextFieldDelegate, HZTimeSectionDelegate, HZNumberPickerDelegate, HZPopPickerDatasource, HZPopPickerDelegate>
@property (retain, nonatomic) IBOutlet UITextField *timeSectionField;
@property (retain, nonatomic) IBOutlet UITextField *qqEableField;
@property (retain, nonatomic) IBOutlet UITextField *qqNumField;
@property (strong, nonatomic) HZTimePickerView *datePicker;

@property (strong, nonatomic) HZPopPickerView *qqEablePicker;
@property (strong, nonatomic) NSString *qqEableNum;
@property (nonatomic) NSInteger qqNumNum;
@property (strong, nonatomic) HZNumberPickerView *qqNumPicker;
@property (strong, nonatomic) NSDictionary *protectInfo;
@property (strong, nonatomic) HZTimeSectionPickerView *timeSectionPicker;
@end

@implementation PreventSetViewController
@synthesize datePicker = _datePicker;

- (void)dealloc
{
    [_qqNumPicker release];
    [_qqEablePicker release];
    [_qqEableNum release];
    [_datePicker release];
    [_timeSectionField release];
    [_qqEableField release];
    [_qqNumField release];
    [_protectInfo release];
    [_timeSectionPicker release];
    [super dealloc];
}

- (HZTimeSectionPickerView *)timeSectionPicker
{
    if (_timeSectionPicker == nil) {
        _timeSectionPicker = [[HZTimeSectionPickerView alloc] initTimeSection];
        _timeSectionPicker.delegate = self;
    }
    
    return _timeSectionPicker;
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

- (void)setProtectInfo:(NSDictionary *)protectInfo
{
    if (![_protectInfo isEqualToDictionary:protectInfo]) {
        _protectInfo = [protectInfo retain];
        NSInteger cc = [protectInfo[@"settheweek"] intValue];
        NSString *descc = nil;
        switch (cc) {

            case 1:
                descc = @"星期一";
                break;
            case 2:
                descc = @"星期二";
                break;
            case 3:
                descc = @"星期三";
                break;
            case 4:
                descc = @"星期四";
                break;
            case 5:
                descc = @"星期五";
                break;
            case 6:
                descc = @"星期六";
                break;
            case 7:
                descc = @"星期日";
                break;
            default:
                descc = @"每天";
                break;
 
        }
        self.qqEableField.text = descc;
        self.qqEableNum = protectInfo[@"settheweek"];
        self.qqNumField.text = [NSString stringWithFormat:@"%@次", protectInfo[@"setsmsdaymax"]];
        self.qqNumNum = [protectInfo[@"setsmsdaymax"] intValue];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"防骚扰设置"];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"保存"
                                                                                                target:self
                                                                                                action:@selector(saveAction)] autorelease];
    NSDictionary *msgTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"msg_time"];
    if (msgTime) {
        self.timeSectionField.text = [NSString stringWithFormat:@"%@~%@", msgTime[@"min_time"], msgTime[@"max_time"]];
    }

    [self getAllProtectInfo];
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

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction
{
    NSMutableDictionary *dp = [Utils queryParams];
    [SVProgressHUD show];
    [[RKClient sharedClient] post:[@"/uc/protect.api" stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){
        
        // 设置POST的form表单的参数
        NSMutableDictionary *updateArgs = [NSMutableDictionary dictionary];
        if (self.qqEableNum) {
            updateArgs[@"settheweek"] = self.qqEableNum;
        }
        
        if (self.qqNumNum) {
            updateArgs[@"setsmsdaymax"] = @(self.qqNumNum);
        }
        updateArgs[@"setcontact"] = @"2";
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

- (void)viewDidUnload {
    [self setTimeSectionField:nil];
    [self setQqEableField:nil];
    [self setQqNumField:nil];
    [super viewDidUnload];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if ([textField isEqual:self.qqEableField]) {

        [self.qqEablePicker show];
    } else if ([textField isEqual:self.qqNumField]){

        [self.qqNumPicker show];
    } else if ([textField isEqual:self.timeSectionField]){
        [self.timeSectionPicker show];
    }
    return NO;

}

#pragma mark time delegate 
-  (void)timeSectionPickerDidChange:(HZTimeSectionPickerView *)picker
{
    self.timeSectionField.text = [NSString stringWithFormat:@"%@~%@", picker.curMinDesc, picker.curMaxDesc];
    [[NSUserDefaults standardUserDefaults] setObject:@{@"min_time": picker.curMinDesc, @"max_time": picker.curMaxDesc} forKey:@"msg_time"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

- (void)getAllProtectInfo
{
    NSMutableDictionary *dParams = [Utils queryParams];
    
    [[RKClient sharedClient] get:[@"/uc/protect.api" stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSMutableDictionary *data = [[response bodyAsString] mutableObjectFromJSONString];

                NSInteger code = [[data objectForKey:@"error"] integerValue];
                if (code == 0) {
                    self.protectInfo = data[@"data"];
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
