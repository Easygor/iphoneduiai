//
//  SSViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-20.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "SSViewController.h"
#import "CustomBarButtonItem.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "HZPopPickerView.h"
#import "HZAreaPickerView.h"
#import "HZLocation.h"

@interface SSViewController () <UITextFieldDelegate, HZPopPickerDatasource, HZPopPickerDelegate>

@property (strong, nonatomic) NSArray *entries;
@property (strong, nonatomic) NSString *rankNum, *companyTypeNum;
@property (strong, nonatomic) HZPopPickerView *rankPicker, *companyTypePicker;
@property (strong, nonatomic) UITextField *curField;
@property (strong, nonatomic) HZAreaPickerView *homePicker, *nativePicker;
@property (strong, nonatomic) HZLocation *homeLocation, *nativeLocaiton;

@end

@implementation SSViewController

- (void)dealloc
{
    [_homeLocation release];
    [_nativeLocaiton release];
    [_nativePicker release];
    [_homePicker release];
    [_entries release];
    [_companyTypeNum release];
    [_rankPicker release];
    [_companyTypePicker release];
    [super dealloc];
}

- (NSArray *)entries
{
    if (_entries == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"seniorEntries" withExtension:@"plist"];
        _entries = [[NSArray alloc] initWithContentsOfURL:url];
    }
    
    return _entries;
}

- (HZPopPickerView *)rankPicker
{
    if (_rankPicker == nil) {
        _rankPicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _rankPicker;
}

- (HZPopPickerView *)companyTypePicker
{
    if (_companyTypePicker == nil) {
        _companyTypePicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _companyTypePicker;
}

- (HZAreaPickerView *)homePicker
{
    if (_homePicker == nil) {
        _homePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self];
    }
    
    return _homePicker;
}

- (HZAreaPickerView *)nativePicker
{
    if (_nativePicker == nil) {
        _nativePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self];
    }
    
    return _nativePicker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.title = @"高级资料";
    
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"取消"
                                                                                               target:self
                                                                                               action:@selector(cancelAction)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"保存"
                                                                                                target:self
                                                                                                action:@selector(saveAction)] autorelease];
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
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
        //        NSMutableDictionary *updateArgs = [NSMutableDictionary dictionary];
        //        if (self.heightNum) {
        //            updateArgs[@"height"] = @(self.heightNum);
        //
        //        }
        //
        //        if (self.location) {
        //            updateArgs[@"province"] = @(self.location.stateId);
        //            updateArgs[@"city"] = @(self.location.cityId);
        //        }
        //
        //        if (self.incomeNum) {
        //            updateArgs[@"income"] = self.incomeNum;
        //
        //        }
        //
        //        if (self.minAge > 0 && self.maxAge >= self.minAge) {
        //            updateArgs[@"minage"] = @(self.minAge);
        //            updateArgs[@"maxage"] = @(self.maxAge);
        //
        //        }
        //
        //        if (self.minHeihgt > 0 && self.maxHeight >= self.minHeihgt) {
        //            updateArgs[@"minheight"] = @(self.minHeihgt);
        //            updateArgs[@"maxheight"] = @(self.maxHeight);
        //        }
        //
        //        if (self.houseNum) {
        //            updateArgs[@"house"] = self.houseNum;
        //        }
        //
        //        if (self.eduNum) {
        //            updateArgs[@"degree"] = self.eduNum;
        //        }
        //
        //        if (self.carNum) {
        //            updateArgs[@"auto"] = self.carNum;
        //        }
        //
        //        updateArgs[@"submitupdate"] = @"true";
        //
        //        NSLog(@"args: %@", updateArgs);
        //        request.params = [RKParams paramsWithDictionary:updateArgs];
        //
        //        [request setOnDidFailLoadWithError:^(NSError *error){
        //            NSLog(@"Error: %@", [error description]);
        //        }];
        //
        //        [request setOnDidLoadResponse:^(RKResponse *response){
        //            if (response.isOK && response.isJSON) {
        //                NSDictionary *data = [response.bodyAsString objectFromJSONString];
        //                NSInteger code = [data[@"error"] integerValue];
        //                if (code == 0) {
        //
        //                    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        //                    self.marrayReq[@"age"] = self.ageField.text;
        //                    self.marrayReq[@"auto"] = self.carField.text;
        //                    self.marrayReq[@"province"] = self.location.state;
        //                    self.marrayReq[@"height"] = self.heightField.text;
        //                    self.marrayReq[@"degree"] = self.degreeField.text;
        //                    self.marrayReq[@"income"] = self.incomeField.text;
        //                    self.marrayReq[@"house"] = self.houseField.text;
        //                    self.marrayReq[@"auto"] = self.carField.text;
        //                    [self cancelAction];
        //                } else{
        //                    [SVProgressHUD showErrorWithStatus:@"保存失败"];
        //                }
        //
        //            } else{
        //                [SVProgressHUD showErrorWithStatus:@"网络故障"];
        //            }
        //        }];
        //
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.entries.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [[self.entries objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    
    
    int bigLabelTag = 102;
    int arrowTag = 107;
    int textFieldTag = 108;
    
    UILabel* bigLabel=nil;
    UIImageView* lineView=nil;
    UIView* bgView = nil;
    UIImageView* arrowImgView = nil;
    UITextField* textField = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        bgView = [[[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 44)] autorelease];
        bgView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgView];
        
        lineView= [[[UIImageView alloc]initWithFrame:CGRectMake(0, 43, 300, 1)]autorelease];
        lineView.image =  [UIImage imageNamed:@"line.png"];
        [bgView addSubview:lineView];
        
        
        bigLabel = [[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 44)] autorelease];
        bigLabel.backgroundColor=[UIColor clearColor];
        bigLabel.tag = bigLabelTag;
        bigLabel.opaque = YES;
        bigLabel.font = [UIFont systemFontOfSize:14.0f];
        bigLabel.textColor = RGBCOLOR(164, 164, 164);
        [bgView addSubview:bigLabel];
        
        textField = [[[UITextField alloc]initWithFrame:CGRectMake(100, 15, 150, 18)]autorelease];
        textField.placeholder = @"未填写";
        textField.font = [UIFont systemFontOfSize:14.0f];
        textField.delegate = self;
        [bgView addSubview:textField];
        textField.tag = textFieldTag;
        textField.returnKeyType = UIReturnKeyDone;
        
        arrowImgView = [[[UIImageView alloc]initWithFrame:CGRectMake(280, 15, 14, 14)] autorelease];
        arrowImgView.tag = arrowTag;
        [cell addSubview:arrowImgView];
        
        
    }
    
    if (bigLabel == nil)
        bigLabel = (UILabel*)[cell viewWithTag:bigLabelTag];
    
    if (arrowImgView ==nil) {
        arrowImgView = (UIImageView*)[cell viewWithTag:arrowTag];
    }
    if (textField == nil) {
        textField = (UITextField*)[cell viewWithTag:textFieldTag];
    }
    NSDictionary *data = [[self.entries objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    UIImage *arrowImg = [UIImage imageNamed:@"statusdetail_header_arrow.png"];
    
    bigLabel.text = [data objectForKey:@"text"];
    [bgView addSubview:lineView];
    
    if ([[data objectForKey:@"haveNext"] boolValue]) {
        arrowImgView.image = arrowImg;
    } else{
        arrowImgView.image = nil;
    }
    
    textField.superview.tag = 1000*indexPath.section + indexPath.row;
    
   
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = self.tableView.sectionHeaderHeight; // note: the height is static.
    
    if (scrollView.contentOffset.y <= sectionHeaderHeight &&
        scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight-10, 0, 0, 0);
        
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header= [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)]autorelease];
    UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(20, 15, 100, 15)]autorelease];
    label.textColor = RGBCOLOR(127, 190, 228);
    label.font = [UIFont systemFontOfSize:16.0f];
    label.backgroundColor = [UIColor clearColor];
    
    if (section==0) {
        label.text = @"工作学习";
    }else if(section==1)
    {
        label.text = @"个人信息";
    }else if(section==2)
    {
        label.text = @"生活状况";
    }
    [header addSubview:label];
    
    return header;
}

#pragma mark - text delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.curField = textField;

    NSDictionary *entry = self.entries[textField.superview.tag/1000][textField.superview.tag - (textField.superview.tag/1000)*1000];
    NSString *label = entry[@"label"];
    
    if ([label isEqual:@"company_name"] || [label isEqual:@"university"]) {
        return YES;
    } else{
        // do here
        if ([label isEqualToString:@"rank_condition"]) {
            [self.rankPicker show];
           
        } else if ([label isEqualToString:@"company"]) {
            [self.companyTypePicker show];
            
        } else if ([label isEqualToString:@"rank_condition"]) {
            [self.rankPicker show];
            
        } else if ([label isEqualToString:@"home_location,home_sublocation"])
        {
            [self.homePicker show];
        } else if ([label isEqualToString:@"love_location,love_sublocation"]){
            [self.nativePicker show];
        }
        
        return NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark pop picker view
- (NSArray *)popPickerData:(HZPopPickerView *)picker
{
    
    if ([picker isEqual:self.rankPicker]) {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"jobs" withExtension:@"plist"];
        NSMutableArray *tmp = [NSMutableArray arrayWithContentsOfURL:url];
        [tmp removeObjectAtIndex:0];
        return tmp;
    } else if([picker isEqual:self.companyTypePicker]){
        return @[@{@"label": @"1", @"desc": @"政府机关"}, @{@"label": @"2", @"desc": @"事业单位"},
        @{@"label": @"3", @"desc": @"外企企业"}, @{@"label": @"4", @"desc": @"世界500强"},
        @{@"label": @"5", @"desc": @"上市公司"}, @{@"label": @"6", @"desc": @"国有企业"}, @{@"label": @"7", @"desc": @"私营企业"},
        @{@"label": @"8", @"desc": @"自有公司"}];
    }
    
    return nil;
    
}

- (NSString *)titleForPopPicker:(HZPopPickerView *)picker
{
    if ([picker isEqual:self.rankPicker]) {
        return @"公司行业";
    } else if([picker isEqual:self.companyTypePicker]){
        return @"公司类型";
    }
    
    return nil;
}

- (void)popPickerDidChangeStatus:(HZPopPickerView *)picker withLabel:(NSString *)label withDesc:(NSString *)desc
{
   self.curField.text = desc;
    if ([picker isEqual:self.rankPicker]) {
        self.rankNum = label;
 
    } else if ([picker isEqual:self.companyTypePicker]){
        self.companyTypeNum = label;
    }
    
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    self.curField.text = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    if ([picker isEqual:self.homeLocation]) {
         self.homeLocation = picker.locate;
    } else if ([picker isEqual:self.nativePicker]){
        self.nativeLocaiton = picker.locate;
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

@end
