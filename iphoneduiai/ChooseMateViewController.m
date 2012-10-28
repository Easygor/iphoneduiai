//
//  ChooseMateViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-16.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ChooseMateViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "CustomCellDelegate.h"

#import "HZNumberPickerView.h"
#import "HZAreaPickerView.h"
#import "HZPopPickerView.h"
#import "HZSectionPickerView.h"

#import "CustomBarButtonItem.h"

@interface ChooseMateViewController () <UITextFieldDelegate, HZSectionPickerDelegate, CustomCellDelegate, HZAreaPickerDatasource, HZAreaPickerDelegate, HZNumberPickerDelegate,  HZPopPickerDatasource, HZPopPickerDelegate>

@property (retain, nonatomic) IBOutlet UILabel *sexLabel;
@property (retain, nonatomic) IBOutlet UITextField *ageField;
@property (retain, nonatomic) IBOutlet UITextField *areaField;
@property (retain, nonatomic) IBOutlet UITextField *heightField;
@property (retain, nonatomic) IBOutlet UITextField *degreeField;
@property (retain, nonatomic) IBOutlet UITextField *incomeField;
@property (retain, nonatomic) IBOutlet UITextField *houseField;
@property (retain, nonatomic) IBOutlet UITextField *carField;

@property (strong, nonatomic) HZAreaPickerView *areaPicker;
@property (strong, nonatomic) HZLocation *location;
@property (strong, nonatomic) NSString *eduNum, *incomeNum, *houseNum, *carNum;
@property (strong, nonatomic) HZPopPickerView *incomePickerView, *degreePicker, *housePicker, *carPicker;
@property (nonatomic) NSInteger heightNum;
@property (nonatomic) NSInteger minAge, maxAge, minHeihgt, maxHeight;

@property (strong, nonatomic) HZSectionPickerView *ageSectionView, *heightSectionView;

@end

@implementation ChooseMateViewController

-(void)dealloc
{
    [_houseNum release];
    [_housePicker release];
    [_carPicker release];
    [_ageSectionView release];
    [_heightSectionView release];
    [_incomePickerView release];
    [_degreePicker release];
    [_incomeNum release];
    [_eduNum release];
    [_areaPicker release];
    [_location release];
    [_sexLabel release];
    [_ageField release];
    [_areaField release];
    [_heightField release];
    [_degreeField release];
    [_incomeField release];
    [_houseField release];
    [_carField release];
    [super dealloc];
}

- (HZSectionPickerView *)ageSectionView
{
    if (_ageSectionView == nil) {
        _ageSectionView = [[HZSectionPickerView alloc] initWithMinNum:18 maxNum:99];
        _ageSectionView.delegate = self;
        _ageSectionView.titleLabel.text = @"年龄段";
    }
    
    return _ageSectionView;
}

- (HZSectionPickerView *)heightSectionView
{
    if (_heightSectionView == nil) {
        _heightSectionView = [[HZSectionPickerView alloc] initWithMinNum:130 maxNum:250];
        _heightSectionView.delegate = self;
        _heightSectionView.titleLabel.text = @"身高";
    }
    
    return _heightSectionView;
}


- (HZPopPickerView *)degreePicker
{
    if (_degreePicker == nil) {
        _degreePicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _degreePicker;
}

- (HZPopPickerView *)housePicker
{
    if (_housePicker == nil) {
        _housePicker = [[HZPopPickerView alloc] initWithDelegate:self];
        
    }
    
    return _housePicker;
}

- (HZPopPickerView *)carPicker
{
    if (_carPicker == nil) {
        _carPicker = [[HZPopPickerView alloc] initWithDelegate:self];

    }
    
    return _carPicker;
}

- (HZPopPickerView *)incomePickerView
{
    if (_incomePickerView == nil) {
        _incomePickerView = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _incomePickerView;
}

- (HZAreaPickerView *)areaPicker
{
    if (_areaPicker == nil) {
        _areaPicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self];
    }
    return _areaPicker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"择偶条件"];

    self.sexLabel.text = self.marrayReq[@"sex"];
    self.ageField.text = self.marrayReq[@"age"];
    self.degreeField.text = self.marrayReq[@"degree"];
    self.heightField.text = self.marrayReq[@"height"];
    self.houseField.text = self.marrayReq[@"house"];
    self.incomeField.text = self.marrayReq[@"income"];
    self.carField.text = self.marrayReq[@"auto"];
    self.areaField.text = [NSString stringWithFormat:@"%@ %@", self.marrayReq[@"province"], self.marrayReq[@"city"]];
    
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"取消"target:self action:@selector(cancelAction)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"保存"target:self action:@selector(saveAction)] autorelease];
   
}

- (void)viewDidUnload {
    [self setSexLabel:nil];
    [self setAgeField:nil];
    [self setAreaField:nil];
    [self setHeightField:nil];
    [self setDegreeField:nil];
    [self setIncomeField:nil];
    [self setHouseField:nil];
    [self setCarField:nil];
    [super viewDidUnload];
}

- (void)cancelAction
{
     [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)saveAction
{
    // do some save here
    NSMutableDictionary *dp = [Utils queryParams];
    [SVProgressHUD show];
    [[RKClient sharedClient] post:[@"/uc/marrayreq.api" stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){
        NSMutableDictionary *updateArgs = [NSMutableDictionary dictionary];
        if (self.heightNum) {
            updateArgs[@"height"] = @(self.heightNum);
            
        }
        
        if (self.location) {
            updateArgs[@"province"] = @(self.location.stateId);
            updateArgs[@"city"] = @(self.location.cityId);
        }
        
        if (self.incomeNum) {
            updateArgs[@"income"] = self.incomeNum;
            
        }
        
        if (self.minAge > 0 && self.maxAge >= self.minAge) {
            updateArgs[@"minage"] = @(self.minAge);
            updateArgs[@"maxage"] = @(self.maxAge);
            
        }
        
        if (self.minHeihgt > 0 && self.maxHeight >= self.minHeihgt) {
            updateArgs[@"minheight"] = @(self.minHeihgt);
            updateArgs[@"maxheight"] = @(self.maxHeight);
        }
        
        if (self.houseNum) {
            updateArgs[@"house"] = self.houseNum;
        }
        
        if (self.eduNum) {
            updateArgs[@"degree"] = self.eduNum;
        }
        
        if (self.carNum) {
            updateArgs[@"auto"] = self.carNum;
        }
        
        updateArgs[@"submitupdate"] = @"true";
        
        NSLog(@"args: %@", updateArgs);
        request.params = [RKParams paramsWithDictionary:updateArgs];
        
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"Error: %@", [error description]);
        }];
        
        [request setOnDidLoadResponse:^(RKResponse *response){
            NSLog(@"save zeou %@", response.bodyAsString);
            if (response.isOK && response.isJSON) {
                NSDictionary *data = [response.bodyAsString objectFromJSONString];
                NSInteger code = [data[@"error"] integerValue];
                if (code == 0) {

                    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                    self.marrayReq[@"age"] = self.ageField.text;
                    self.marrayReq[@"auto"] = self.carField.text;
                    self.marrayReq[@"province"] = self.location.state;
                    self.marrayReq[@"height"] = self.heightField.text;
                    self.marrayReq[@"degree"] = self.degreeField.text;
                    self.marrayReq[@"income"] = self.incomeField.text;
                    self.marrayReq[@"house"] = self.houseField.text;
                    self.marrayReq[@"auto"] = self.carField.text;
                    [self cancelAction];
                } else{
                    [SVProgressHUD showErrorWithStatus:@"保存失败"];
                }
                
            } else{
                [SVProgressHUD showErrorWithStatus:@"网络故障"];
            }
        }];
        
    }];
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

#pragma mark - text delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.heightField]) {
        [self.heightSectionView show];
    }else if ([textField isEqual:self.ageField]){
        [self.ageSectionView show];
    }
    else if ([textField isEqual:self.areaField]){
        [self.areaPicker show];
    } else if ([textField isEqual:self.incomeField]){
        [self.incomePickerView show];
    } else if ([textField isEqual:self.degreeField]){
        [self.degreePicker show];
    } else if ([textField isEqual:self.carField]){
        [self.carPicker show];
    } else if ([textField isEqual:self.houseField]){
        [self.housePicker show];
    }
    
    return NO;
}


#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCity) {
        self.location = picker.locate;
        self.areaField.text = [NSString stringWithFormat:@"%@ %@", self.location.state, self.location.city];
//        self.areaField.text = self.location.city;

    }
}

-(NSArray *)areaPickerData:(HZAreaPickerView *)picker
{
    NSArray *data;
    if (picker.pickerStyle == HZAreaPickerWithStateAndCity) {
        data = [[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]] autorelease];
    } else {
        data = [[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]] autorelease];
    }
    
    return data;
}

#pragma mark pop picker view
- (NSArray *)popPickerData:(HZPopPickerView *)picker
{
    
    if ([picker isEqual:self.incomePickerView]) {
        
        return @[@{@"label": @"0", @"desc": @"不限"}, @{@"label": @"10", @"desc": @"2000元以下"}, @{@"label": @"20", @"desc": @"2000~50000元"},
        @{@"label": @"30", @"desc": @"5000~10000元"}, @{@"label": @"40", @"desc": @"10000~20000元"},
        @{@"label": @"50", @"desc": @"20000元以上"}];
    } else if ([picker isEqual:self.degreePicker]){
        return @[@{@"label": @"0", @"desc": @"不限"}, @{@"label": @"1", @"desc": @"中专或以下"}, @{@"label": @"2", @"desc": @"大专"},
        @{@"label": @"3", @"desc": @"本科"}, @{@"label": @"4", @"desc": @"双学士"},
        @{@"label": @"5", @"desc": @"硕士"}, @{@"label": @"6", @"desc": @"博士"}, @{@"label": @"7", @"desc": @"博士后"}];
    }else if ([picker isEqual:self.housePicker]){
        return @[@{@"label": @"0", @"desc": @"不限"}, @{@"label": @"1", @"desc": @"暂未购房"}, @{@"label": @"8", @"desc": @"需要时购置"},
        @{@"label": @"2", @"desc": @"已购住房"}, @{@"label": @"3", @"desc": @"与人合租"},
        @{@"label": @"4", @"desc": @"独自租房"}, @{@"label": @"5", @"desc": @"与父母同住"}, @{@"label": @"6", @"desc": @"住亲朋家"}, @{@"label": @"7", @"desc": @"住单位房"}];
    } else if ([picker isEqual:self.carPicker]){
        return @[@{@"label": @"0", @"desc": @"未购车"}, @{@"label": @"1", @"desc": @"已购车"}];
    }
    
    return nil;
    
}

- (NSString *)titleForPopPicker:(HZPopPickerView *)picker
{
    if ([picker isEqual:self.incomePickerView]) {
        return @"工资收入(元)";
    } else if ([picker isEqual:self.degreePicker]){
        return @"学历";
    } else if ([picker isEqual:self.housePicker]){
        return @"住房情况";
    } else if ([picker isEqual:self.carPicker]){
        return @"购车情况";
    }
    
    return nil;
}

- (void)popPickerDidChangeStatus:(HZPopPickerView *)picker withLabel:(NSString *)label withDesc:(NSString *)desc
{
    if ([picker isEqual:self.incomePickerView]) {
        self.incomeNum = label;
        self.incomeField.text = desc;
        
    } else if ([picker isEqual:self.degreePicker]){
        self.eduNum = label;
        self.degreeField.text = desc;
        
    }else if ([picker isEqual:self.housePicker]){
        self.houseNum = label;
        self.houseField.text = desc;
    }else if ([picker isEqual:self.carPicker]){
        self.carNum = label;
        self.carField.text = desc;
    }
    
}


- (void)sectionPickerDidChange:(HZSectionPickerView *)picker
{
    if ([picker isEqual:self.ageSectionView]) {
        self.minAge = picker.curMinNum;
        self.maxAge = picker.curMaxNum;
        self.ageField.text = [NSString stringWithFormat:@"%d~%d岁", picker.curMinNum, picker.curMaxNum];

    } else if ([picker isEqual:self.heightSectionView]){
        self.minHeihgt = picker.curMinNum;
        self.maxHeight = picker.curMaxNum;
        self.heightField.text = [NSString stringWithFormat:@"%d~%dCM", picker.curMinNum, picker.curMaxNum];

    }
    
}



@end
