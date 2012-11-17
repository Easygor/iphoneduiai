//
//  ConditionViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-28.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ConditionViewController.h"
#import "HZSementedControl.h"
#import "CustomBarButtonItem.h"
#import "HZAreaPickerView.h"
//#import "HZDegreePickerView.h"
#import "HZLocation.h"
#import "HZSectionPickerView.h"
#import "HZPopPickerView.h"

@interface ConditionViewController () <HZSementdControlDelegate, UITextFieldDelegate, HZPopPickerDatasource, HZPopPickerDelegate, HZSectionPickerDelegate, HZAreaPickerDatasource, HZAreaPickerDelegate>
@property (retain, nonatomic) IBOutlet HZSementedControl *sementedControl;
@property (retain, nonatomic) IBOutlet UIButton *leftBtn;
@property (retain, nonatomic) IBOutlet UIButton *rightBtn;
@property (retain, nonatomic) IBOutlet HZSementedControl *sexSementedControl;
@property (retain, nonatomic) IBOutlet UITextField *ageField;
@property (retain, nonatomic) IBOutlet UITextField *areaField;
@property (retain, nonatomic) IBOutlet UITextField *heightField;
@property (retain, nonatomic) IBOutlet UITextField *incomeField;
@property (retain, nonatomic) IBOutlet UITextField *degreeField;
@property (retain, nonatomic) IBOutlet UIView *contianerView;
@property (retain, nonatomic) IBOutlet UITextField *idField;

@property (strong, nonatomic) HZAreaPickerView *areaPicker;
//@property (strong, nonatomic) HZDegreePickerView *degreePicker;
@property (strong, nonatomic) HZLocation *location;
@property (strong, nonatomic) NSString *eduNum, *incomeNum;
@property (nonatomic) NSInteger minAge, maxAge, minHeihgt, maxHeight;

@property (strong, nonatomic) HZSectionPickerView *ageSectionView, *heightSectionView;
@property (strong, nonatomic) HZPopPickerView *incomePickerView, *degreePicker;

@end

@implementation ConditionViewController
@synthesize idView,conditionView;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_sementedControl release];
    [_leftBtn release];
    [_rightBtn release];
    [_sexSementedControl release];
    [_ageField release];
    [_areaField release];
    [_heightField release];
    [_incomeField release];
    [_degreeField release];
    [_contianerView release];
    [_idField release];
    [_areaPicker release];
    [_degreePicker release];
    [_location release];
    [_eduNum release];
    [_ageSectionView release];
    [_heightSectionView release];
    [_incomePickerView release];
    [_incomeNum release];
    [idView release];
    [conditionView release];
    
    [super dealloc];
}

-(void)setLocation:(HZLocation *)location
{
    _location = [location retain];
    NSString *str = [NSString stringWithFormat:@"%@ %@", location.state, location.city];
    if (![str isEqualToString:self.areaField.text]) {
        self.areaField.text = str;
    }
}

- (HZAreaPickerView *)areaPicker
{
    if (_areaPicker == nil) {
        _areaPicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self];
    }
    return _areaPicker;
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

- (void)viewDidUnload
{
    [self setSementedControl:nil];
    [self setLeftBtn:nil];
    [self setRightBtn:nil];
    [self setSexSementedControl:nil];
    [self setAgeField:nil];
    [self setAreaField:nil];
    [self setHeightField:nil];
    [self setIncomeField:nil];
    [self setDegreeField:nil];
    [self setContianerView:nil];
    [self setIdField:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"筛选条件"];

    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"确定"
                                                                                                target:self
                                                                                                action:@selector(searchAction)] autorelease];
    
    UIImage *btnBg = [[UIImage imageNamed:@"search_choice_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *selectedBtnBg = [[UIImage imageNamed:@"search_choice_bg_select"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [self.leftBtn setBackgroundImage:btnBg forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:selectedBtnBg forState:UIControlStateHighlighted];
    [self.leftBtn setBackgroundImage:selectedBtnBg forState:UIControlStateSelected];
    [self.rightBtn setBackgroundImage:btnBg forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:selectedBtnBg forState:UIControlStateHighlighted];
    [self.rightBtn setBackgroundImage:selectedBtnBg forState:UIControlStateSelected];
    
    
    self.incomePickerView = [[[HZPopPickerView alloc] initWithDelegate:self] autorelease];

    self.degreePicker = [[[HZPopPickerView alloc] initWithDelegate:self] autorelease];
    
    // init the updae
    if ([self.conditions[@"sex"] isEqualToString:@"w"]) {
        [self.sexSementedControl selectSegmentAtIndex:1];
    } else{
        [self.sexSementedControl selectSegmentAtIndex:0];
    }
    
    if ([self.conditions[@"searchtype"] isEqualToString:@"id"]) {
        [self.sementedControl selectSegmentAtIndex:1];
    } else{
        [self.sementedControl selectSegmentAtIndex:0];
    }
    
    if (self.conditions[@"minage"] && self.conditions[@"maxage"]) {
        self.ageField.text = [NSString stringWithFormat:@"%@~%@岁", self.conditions[@"minage"], self.conditions[@"maxage"]];
    }
    
    if (self.conditions[@"minheight"] && self.conditions[@"maxheight"]) {
        self.heightField.text = [NSString stringWithFormat:@"%@~%@CM", self.conditions[@"minheight"], self.conditions[@"maxheight"]];
    }
    
    if (self.conditions[@"incomedesc"]) {
        self.incomeField.text = self.conditions[@"incomedesc"];
    }
    
    if (self.conditions[@"degreedesc"]) {
        self.incomeField.text = self.conditions[@"degreedesc"];
    }
    
    if (self.conditions[@"id"]) {
        self.idField.text = self.conditions[@"id"];
    }
    
    if (self.conditions[@"provincedesc"] && self.conditions[@"citydesc"]) {
        self.areaField.text = [NSString stringWithFormat:@"%@ %@", self.conditions[@"provincedesc"], self.conditions[@"citydesc"]];
    }
    
    [self.conditionView setHidden:NO];
    [self.idView setHidden:YES];
}

- (void)backAction
{
    self.conditions[@"id"] = self.idField.text;
    self.conditions[@"search"] = @NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)searchAction
{
    self.conditions[@"id"] = self.idField.text;
    self.conditions[@"search"] = @YES;
    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (BOOL)hidesBottomBarWhenPushed
{
    return  YES;
}
-(IBAction)conditionChange:(id)sender
{
    UIButton * curButton = (UIButton*)sender;
    if (curButton.tag==101) {
        [self.idView setHidden:YES];
        [self.conditionView setHidden:NO];
    }else if( curButton.tag ==102)
    {
        [self.conditionView setHidden:YES];
         [self.idView setHidden:NO];
    }
}
#pragma mark - delegate sememnted
- (void)didChange:(HZSementedControl *)segment atIndex:(NSInteger)index forValue:(NSString *)text
{
    if ([segment isEqual:self.sementedControl]) {
        if (index == 1) {
         
            self.conditions[@"searchtype"] = @"id"; 
        } else{
            self.conditions[@"searchtype"] = @"detail";
        }

    } else if([segment isEqual:self.sexSementedControl]){
        NSString *sexString = nil;
        if (index == 0) {
            sexString = @"m";
        }else if(index == 1){
            sexString = @"w";
        }else{
            sexString = @"";
        }
        
        self.conditions[@"sex"] = sexString;
        
    }
}

#pragma mark text field delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.idField]) {
        return YES;
    } else if([textField isEqual:self.ageField]){
        [self.ageSectionView show];

    } else if ([textField isEqual:self.areaField]){
        [self.areaPicker show];
    } else if ([textField isEqual:self.heightField]){
        [self.heightSectionView show];
    } else if ([textField isEqual:self.incomeField]){

        [self.incomePickerView show];
    } else if ([textField isEqual:self.degreeField]){

        [self.degreePicker show];
    }
    
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.idField resignFirstResponder];
}

# pragma mark - keyboard show event for resize the UI
- (void)keyboardWillShow:(NSNotification *)notif
{
    //keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
    
    NSValue *endingFrame = [[notif userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame;
    [endingFrame getValue:&frame];
    
    CGRect containerFrame = self.contianerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (frame.size.height + containerFrame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contianerView.frame = containerFrame;
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    [UIView animateWithDuration:0.2 animations:^{
        self.contianerView.frame = CGRectMake(0, 0, self.contianerView.bounds.size.width, self.contianerView.bounds.size.height);
    }];
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCity) {
        self.location = picker.locate;
        
        self.conditions[@"province"] = @(self.location.stateId);
        self.conditions[@"city"] = @(self.location.cityId);
        self.conditions[@"provincedesc"] = self.location.state;
        self.conditions[@"citydesc"] = self.location.city;
    }
}

-(NSArray *)areaPickerData:(HZAreaPickerView *)picker
{
    NSArray *data;
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        data = [[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]] autorelease];
    } else {
        data = [[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]] autorelease];
    }
    
    return data;
}

#pragma mark section
- (void)sectionPickerDidChange:(HZSectionPickerView *)picker
{
    if ([picker isEqual:self.ageSectionView]) {
        self.minAge = picker.curMinNum;
        self.maxAge = picker.curMaxNum;
        self.ageField.text = [NSString stringWithFormat:@"%d~%d岁", picker.curMinNum, picker.curMaxNum];
        self.conditions[@"minage"] = @(self.minAge);
        self.conditions[@"maxage"] = @(self.maxAge);
    } else if ([picker isEqual:self.heightSectionView]){
        self.minHeihgt = picker.curMinNum;
        self.maxHeight = picker.curMaxNum;
        self.heightField.text = [NSString stringWithFormat:@"%d~%dCM", picker.curMinNum, picker.curMaxNum];
        self.conditions[@"minheight"] = @(self.minHeihgt);
        self.conditions[@"maxheight"] = @(self.maxHeight);
    }
    
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
    }

    return nil;

}

- (NSString *)titleForPopPicker:(HZPopPickerView *)picker
{
    if ([picker isEqual:self.incomePickerView]) {
       return @"工资收入";
    } else if ([picker isEqual:self.degreePicker]){
        return @"学历";
    }

    return nil;
}

- (void)popPickerDidChangeStatus:(HZPopPickerView *)picker withLabel:(NSString *)label withDesc:(NSString *)desc
{
    if ([picker isEqual:self.incomePickerView]) {
        self.incomeNum = label;
        self.incomeField.text = desc;
        self.conditions[@"income"] = self.incomeNum;
        self.conditions[@"incomedesc"] = desc;
    } else if ([picker isEqual:self.degreePicker]){
        self.eduNum = label;
        self.degreeField.text = desc;
        self.conditions[@"degree"] = self.eduNum;
        self.conditions[@"degreedesc"] = desc;
    }

}

@end
