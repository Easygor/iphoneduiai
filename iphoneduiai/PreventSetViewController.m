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

@interface PreventSetViewController () <UITextFieldDelegate, HZNumberPickerDelegate, HZPopPickerDatasource, HZPopPickerDelegate>
@property (retain, nonatomic) IBOutlet UITextField *timeSectionField;
@property (retain, nonatomic) IBOutlet UITextField *qqEableField;
@property (retain, nonatomic) IBOutlet UITextField *qqNumField;
@property (strong, nonatomic) HZTimePickerView *datePicker;

@property (strong, nonatomic) HZPopPickerView *qqEablePicker;
@property (strong, nonatomic) NSString *qqEableNum;
@property (nonatomic) NSInteger qqNumNum;
@property (strong, nonatomic) HZNumberPickerView *qqNumPicker;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.title = @"防骚扰设置";
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"保存"
                                                                                                target:self
                                                                                                action:@selector(saveAction)] autorelease];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction
{
    // ok
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
        // todo
    }
    return NO;

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


@end
