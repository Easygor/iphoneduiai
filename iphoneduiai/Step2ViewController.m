//
//  Step2ViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "Step2ViewController.h"
#import "Step3ViewController.h"
#import "CustomBarButtonItem.h"
#import "HZSementedControl.h"
#import "HZAreaPickerView.h"
#import "HZDatePickerView.h"
#import "HZDegreePickerView.h"
#import "HZLocation.h"
#import "Utils.h"
#import "RegexKitLite.h"
#import "SVProgressHUD.h"
#import "HZNumberPickerView.h"
#import "HZPopPickerView.h"

static NSString *const wRegex = @"\\w+";

@interface Step2ViewController () <HZSementdControlDelegate, HZNumberPickerDelegate, HZAreaPickerDelegate, HZDatePickerDelegate, HZDegreePickerDelegate, HZAreaPickerDatasource>
@property (retain, nonatomic) IBOutlet HZSementedControl *sexSegemnter;
@property (retain, nonatomic) IBOutlet UITextField *birthdayText;
@property (retain, nonatomic) IBOutlet UITextField *areaText;
@property (retain, nonatomic) IBOutlet UITextField *heighText;
@property (retain, nonatomic) IBOutlet UITextField *eduText;
@property (retain, nonatomic) IBOutlet UITextField *salaryText;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property (strong, nonatomic) HZDatePickerView *datePicker;
@property (strong, nonatomic) HZDegreePickerView *degreePicker;
@property (strong, nonatomic) HZLocation *location;
@property (retain, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSString *eduNum;
@property (strong, nonatomic) HZNumberPickerView *heightPicker;
@property (nonatomic) NSInteger heightNum;
@property (strong, nonatomic) NSString *incomeNum;
@property (strong, nonatomic) HZPopPickerView *incomePickerView;

@end

@implementation Step2ViewController
@synthesize sexSegemnter;
@synthesize birthdayText;
@synthesize areaText;
@synthesize heighText;
@synthesize eduText;
@synthesize salaryText;
@synthesize sex=_sex;
@synthesize locatePicker=_locatePicker;
@synthesize datePicker=_datePicker;
@synthesize location=_location;
@synthesize containerView;
@synthesize eduNum;


- (void)dealloc {
    [_incomeNum release];
    [_incomePickerView release];
    [_datePicker release];
    [_location release];
    [_sex release];
    [sexSegemnter release];
    [birthdayText release];
    [areaText release];
    [heighText release];
    [eduText release];
    [salaryText release];
    [_locatePicker release];
    [containerView release];
    [_heightPicker release];
    [super dealloc];
}

- (HZNumberPickerView *)heightPicker
{
    if (_heightPicker == nil) {
        _heightPicker = [[HZNumberPickerView alloc] initWithMinNum:140 maxNum:250];
        _heightPicker.titleLabel.text = @"你的身高(cm)";
        _heightPicker.delegate = self;
    }
    
    return _heightPicker;
}

- (HZDatePickerView *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[HZDatePickerView alloc] initWithDelegate:self];
    }
    
    return _datePicker;
}

- (HZAreaPickerView *)locatePicker
{
    if (_locatePicker == nil) {
        _locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
    }
    
    return _locatePicker;
}

- (HZPopPickerView *)incomePickerView
{
    if (_incomePickerView == nil) {
        _incomePickerView = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _incomePickerView;
}

- (HZDegreePickerView *)degreePicker
{
    if (_degreePicker == nil) {
        _degreePicker = [[HZDegreePickerView alloc] initWithDelegate:self];
    }
    
    return _degreePicker;
}

-(void)setLocation:(HZLocation *)location
{
    _location = [location retain];
    NSString *str = [NSString stringWithFormat:@"%@ %@ %@", location.state, location.city, location.district];
    if (![str isEqualToString:self.areaText.text]) {
        self.areaText.text = str;
    }
}

-(void)setBirthday:(NSDate *)birthday
{
    if (![_birthday isEqual:birthday]) {
        _birthday = [birthday retain];
        self.birthdayText.text = [Utils dateDescWithDate:birthday];
    }
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
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"下一步"
                                                                                                target:self
                                                                                                action:@selector(nextAction)] autorelease];
//    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSDictionary *d = [[NSUserDefaults standardUserDefaults] objectForKey:@"step2"];
    if (d) {
        NSString *sex = [d objectForKey:@"sex"];
        if ([sex isEqualToString:@"m"]) {
            [self.sexSegemnter selectSegmentAtIndex:0];
        } else if ([sex isEqualToString:@"w"]) {
            [self.sexSegemnter selectSegmentAtIndex:1];
        }
        HZLocation *loc = [[[HZLocation alloc] init] autorelease];
        [loc fromDictionary:[d objectForKey:@"location"]];
        self.location =loc;
        self.birthday = [d objectForKey:@"birthday"];
        self.eduText.text = [d objectForKey:@"edu"];
        self.eduNum = [d objectForKey:@"degree"];
        self.heighText.text = [d objectForKey:@"height"];
        self.salaryText.text = [d objectForKey:@"income"];
        
//        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)viewDidUnload
{
    [self setSexSegemnter:nil];
    [self setBirthdayText:nil];
    [self setAreaText:nil];
    [self setHeighText:nil];
    [self setEduText:nil];
    [self setSalaryText:nil];
    [self setContainerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:self.view.window];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:7];
    if (self.sex) {
        [d setObject:self.sex forKey:@"sex"];
    }
    if (self.birthday) {
        [d setObject:self.birthday forKey:@"birthday"];
    }
    if (self.location) {
        [d setObject:[self.location toDictionary] forKey:@"location"];
    }
    if (self.heightNum) {
        d[@"height"] = @(self.heightNum);
    }
    if (self.eduNum) {
        [d setObject:self.eduNum forKey:@"degree"];
        [d setObject:self.eduText.text forKey:@"edu"];
    }
    if (self.incomeNum) {
        d[@"income"] = self.incomeNum;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"step2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super viewWillDisappear:animated];
}

#pragma mark - actions
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.presentedViewController dismissModalViewControllerAnimated:YES];
}

- (void)nextAction
{
    if ([self checkinputs]) {
        Step3ViewController *s3vc = [[Step3ViewController alloc] initWithNibName:@"Step3ViewController" bundle:nil];
        [self.navigationController pushViewController:s3vc animated:YES];
        [s3vc release];
    } else{
        [SVProgressHUD showErrorWithStatus:@"请填写信息"];
    }

}

- (BOOL)checkinputs
{
    if (self.birthday && self.location &&
        self.heightNum && self.eduNum &&
        self.incomeNum && self.sex) {
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{


    if ([textField isEqual:self.birthdayText]){

        [self.datePicker show];
    } else if ([textField isEqual:self.areaText]){
        // area
        [self.locatePicker show];

    } else if ([textField isEqual:self.eduText]){
        // edu
        [self.degreePicker show];
    } else if([textField isEqual:self.salaryText]){
        [self.incomePickerView show];
    } else if([textField isEqual:self.heighText]){
        [self.heightPicker show];
    }

    return NO;
    

}


#pragma mark pop picker view
- (NSArray *)popPickerData:(HZPopPickerView *)picker
{
    
    if ([picker isEqual:self.incomePickerView]) {
        
        return @[@{@"label": @"0", @"desc": @"不限"}, @{@"label": @"10", @"desc": @"2000元以下"}, @{@"label": @"20", @"desc": @"2000~50000元"},
        @{@"label": @"30", @"desc": @"5000~10000元"}, @{@"label": @"40", @"desc": @"10000~20000元"},
        @{@"label": @"50", @"desc": @"20000元以上"}];
    } 
    
    return nil;
    
}

- (NSString *)titleForPopPicker:(HZPopPickerView *)picker
{
    if ([picker isEqual:self.incomePickerView]) {
        return @"工资收入(元)";
    }
    
    return nil;
}

- (void)popPickerDidChangeStatus:(HZPopPickerView *)picker withLabel:(NSString *)label withDesc:(NSString *)desc
{
    if ([picker isEqual:self.incomePickerView]) {
        self.incomeNum = label;
        self.salaryText.text = desc;
        
    } 
    
}

#pragma mark - number delegate
- (void)numberPickerDidChange:(HZNumberPickerView *)picker
{
    if ([picker isEqual:self.heightPicker]) {
        self.heighText.text = [NSString stringWithFormat:@"%dCM", picker.curNum];
        self.heightNum = picker.curNum;
    }
    
}

#pragma mark HZ segment 
-(void)didChange:(HZSementedControl *)segment atIndex:(NSInteger)index forValue:(NSString *)text
{
    if (index == 0) {
        self.sex = @"m";
    }else if(index == 1){
        self.sex = @"w";
    }else{
        self.sex = @"";
    }
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        self.location = picker.locate;
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

-(void)datePickerDidChangeStatus:(HZDatePickerView *)picker withDate:(NSDate *)date
{
    self.birthday = date;
}

-(void)dgreePickerDidChangeStatus:(HZDegreePickerView *)picker withNum:(NSString *)numStr withDesc:(NSString *)desc
{
    self.eduNum = numStr;
    self.eduText.text = desc;
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

-(void)cancelDatePicker
{
    [self.datePicker cancelPicker];
    self.datePicker.delegate = nil;
    self.datePicker = nil;
}

-(void)cancelDegreePicker
{
    [self.degreePicker cancelPicker];
    self.degreePicker.delegate = nil;
    self.degreePicker = nil;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.heighText resignFirstResponder];
    [self.salaryText resignFirstResponder];
    
    [self cancelLocatePicker];
    [self cancelDatePicker];
    [self cancelDegreePicker];
}

# pragma mark - keyboard show event for resize the UI
- (void)keyboardWillShow:(NSNotification *)notif
{
    //keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
    
    NSValue *endingFrame = [[notif userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame;
    [endingFrame getValue:&frame];
    
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (frame.size.height + containerFrame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.frame = containerFrame;
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    [UIView animateWithDuration:0.2 animations:^{
        self.containerView.frame = CGRectMake(0, 0, self.containerView.bounds.size.width, self.containerView.bounds.size.height);
    }];
}



@end
