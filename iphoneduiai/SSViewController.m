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

@property (strong, nonatomic) NSMutableArray *entries;
@property (strong, nonatomic) NSString *rankNum, *companyTypeNum,*nationalNum,*religiousNum,*bestParNum,*bloodtypeNum,*houseNum,*childWantNum,*parentTogetherNum,*paihangNum,*mostCostNum;
@property (strong, nonatomic) NSString  *specialtyTypeNum,*autoNum,*childrenNum,*marriageNum,*smokeTypeNum,*drinkTypeNum,*liveCustNum;
@property (strong, nonatomic) HZPopPickerView *rankPicker, *companyTypePicker;
@property (strong, nonatomic) HZPopPickerView  *specialityTypePicker,*nationalPicker,*religiousPicker,*bestParPicker,*bloodtypePicker,*housePicker,*autoPicker,*childrenPicker,*marriagePicker,*smokeTypePicker,*drinkTypePicker,*liveCustPicker,*childWantPicker,*parentTogetherPicker,*paihangPicker,*mostCostPicker;
@property (strong, nonatomic) UITextField *curField;
@property (strong, nonatomic) HZAreaPickerView *homePicker, *nativePicker;
@property (strong, nonatomic) HZLocation *homeLocation, *nativeLocaiton;
@property (strong, nonatomic) NSMutableDictionary *curEntry;

@end

@implementation SSViewController

- (void)dealloc
{
    [_curEntry release];
    [_homeLocation release];
    [_nativeLocaiton release];
    [_nativePicker release];
    [_homePicker release];
    [_entries release];
    [_companyTypeNum release];
    [_rankPicker release];
    [_companyTypePicker release];
    [_specialityTypePicker release];
    [_nationalPicker release];
    [_religiousPicker release];
    [_bestParPicker release];
    [_nationalNum release];
    [_rankNum release];
    [_religiousNum release];
    [_bloodtypeNum release];
    [_bloodtypePicker release];
    [_houseNum release];
    [_housePicker release];
    [_autoNum release];
    [_autoPicker release];
    [_childrenPicker release];
    [_childrenNum release];
    [_marriageNum release];
    [_marriagePicker release];
    [_smokeTypeNum release];
    [_smokeTypePicker release];
    [_drinkTypePicker release];
    [_drinkTypeNum release];
    [_liveCustNum release];
    [_liveCustPicker release];
    [_childWantNum release];
    [_childWantPicker release];
    [_parentTogetherNum release];
    [_parentTogetherPicker release];
    [_paihangNum release];
    [_paihangPicker release];
    [_mostCostNum release];

    [super dealloc];
}

- (NSMutableArray *)entries
{
    if (_entries == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"seniorEntries" withExtension:@"plist"];
        _entries = [[NSMutableArray alloc] initWithContentsOfURL:url];
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
- (HZPopPickerView *)mostCostPicker
{
    if (_mostCostPicker == nil) {
        _mostCostPicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _mostCostPicker;
}


- (HZPopPickerView *)specialityTypePicker
{
    if (_specialityTypePicker == nil) {
        _specialityTypePicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _specialityTypePicker;
}

- (HZPopPickerView *)marriagePicker
{
    if (_marriagePicker == nil) {
        _marriagePicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _marriagePicker;
}

- (HZPopPickerView *)paihangPicker
{
    if (_paihangPicker == nil) {
        _paihangPicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _paihangPicker;
}

- (HZPopPickerView *)smokeTypePicker
{
    if (_smokeTypePicker == nil) {
        _smokeTypePicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _smokeTypePicker;
}
- (HZPopPickerView *)parentTogetherPicker
{
    if (_parentTogetherPicker == nil) {
        _parentTogetherPicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _parentTogetherPicker;
}


- (HZPopPickerView *)nationalPicker
{
    if (_nationalPicker == nil) {
        _nationalPicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _nationalPicker;
}

- (HZPopPickerView *)childWantPicker
{
    if (_childWantPicker == nil) {
        _childWantPicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _childWantPicker;
}


- (HZPopPickerView *)drinkTypePicker
{
    if (_drinkTypePicker == nil) {
        _drinkTypePicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _drinkTypePicker;
}

- (HZPopPickerView *)autoPicker
{
    if (_autoPicker == nil) {
        _autoPicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _autoPicker;
}

- (HZPopPickerView *)childrenPicker
{
    if (_childrenPicker == nil) {
        _childrenPicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _childrenPicker;
}
- (HZPopPickerView *)liveCustPicker
{
    if (_liveCustPicker == nil) {
        _liveCustPicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _liveCustPicker;
}


- (HZPopPickerView *)bloodtypePicker
{
    if (_bloodtypePicker == nil) {
        _bloodtypePicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _bloodtypePicker;
}

- (HZPopPickerView *)housePicker
{
    if (_housePicker == nil) {
        _housePicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _housePicker;
}

- (HZPopPickerView *)religiousPicker
{
    if (_religiousPicker == nil) {
        _religiousPicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _religiousPicker;
}
- (HZPopPickerView *)bestParPicker
{
    if (_bestParPicker == nil) {
        _bestParPicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _bestParPicker;
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

    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"高级资料"];
    
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
    /*
    // do some save here
    NSMutableDictionary *dp = [Utils queryParams];
    [SVProgressHUD show];
    [[RKClient sharedClient] post:[@"/uc/userinfo.api" stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){
        NSMutableDictionary *updateArgs = [NSMutableDictionary dictionary];
        if (self.heightNum) {
            updateArgs[@"height"] = @(self.heightNum);
            
        } else{
            updateArgs[@"height"] = self.searchIndex[@"height"];
        }
        
        if (self.location) {
            updateArgs[@"province"] = @(self.location.stateId);
            updateArgs[@"city"] = @(self.location.cityId);
            updateArgs[@"area"] = @(self.location.areaId);
        } else{
            updateArgs[@"province"] = self.searchIndex[@"province"];
            updateArgs[@"city"] = self.searchIndex[@"city"];
            updateArgs[@"area"] = self.searchIndex[@"area"];
        }
        
        if (self.incomeNum) {
            updateArgs[@"income"] = self.incomeNum;
            
        } else{
            updateArgs[@"income"] = self.searchIndex[@"income"];
        }
        
        if (self.eduNum) {
            updateArgs[@"degree"] = self.eduNum;
        } else{
            updateArgs[@"degree"] = self.searchIndex[@"degree"];
        }
        
        if (self.jobNum) {
            updateArgs[@"industry"] = self.jobNum;
        } else{
            updateArgs[@"industry"] = self.searchIndex[@"industry"];
        }
        
        if (self.weightNum) {
            updateArgs[@"weight"] = @(self.weightNum);
        }
        
        
        updateArgs[@"constellation"] = self.searchIndex[@"constellation"];
        updateArgs[@"marriage"] = self.searchIndex[@"marriage"];
        updateArgs[@"zodiac"] = self.searchIndex[@"zodiac"];
        updateArgs[@"submitupdate"] = @"true";
        
        NSLog(@"args: %@", updateArgs);
        request.params = [RKParams paramsWithDictionary:updateArgs];
        
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"Error: %@", [error description]);
        }];
        
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSDictionary *data = [response.bodyAsString objectFromJSONString];
                NSInteger code = [data[@"error"] integerValue];
                if (code == 0) {
                    [self grabUserInfoDetailRequest];
                    [self.tableView setEditing:NO animated:YES];
                    
                    [self changeToNonEditingView];
                    
                    self.navigationItem.leftBarButtonItem = self.changeBaritem;
                    self.navigationItem.rightBarButtonItem = self.settingBarItem;
                    
                    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                } else{
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
            } else{
                [SVProgressHUD showErrorWithStatus:@"网络故障"];
            }
        }];
        
    }];
     */
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
        
        arrowImgView = [[[UIImageView alloc]initWithFrame:CGRectMake(290, 14, 9, 16)] autorelease];
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

    UIImage *arrowImg = [UIImage imageNamed:@"arrow_more"];
    
    bigLabel.text = [data objectForKey:@"text"];
    [bgView addSubview:lineView];
    
    if ([[data objectForKey:@"haveNext"] boolValue]) {
        arrowImgView.image = arrowImg;
    } else{
        arrowImgView.image = nil;
    }
    
    textField.superview.tag = 1000*indexPath.section + indexPath.row;
    if (data[@"value"]) {
        textField.text = data[@"value"];
    } else{
        textField.text = nil;
    }
   
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
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.curEntry[@"value"] = textField.text;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.curField = textField;

    self.curEntry = self.entries[textField.superview.tag/1000][textField.superview.tag - (textField.superview.tag/1000)*1000];
    NSString *label = self.curEntry[@"label"];
    
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
        }else if ([label isEqualToString:@"speciality"]) {
            [self.specialityTypePicker show];
        }else if ([label isEqualToString:@"nation"]) {
            [self.nationalPicker show];
        }else if([label isEqualToString:@"belief"]){
            [self.religiousPicker show];
        }else if([label isEqualToString:@"best_par"]){
            [self.bestParPicker show];
        }else if([label isEqualToString:@"bloodtype"]){
            [self.bloodtypePicker show];
        }else if([label isEqualToString:@"house"]){
            [self.housePicker show];
        }else if([label isEqualToString:@"auto"]){
            [self.autoPicker show];
        }else if([label isEqualToString:@"children"]){
            [self.childrenPicker show];
        }else if([label isEqualToString:@"marriage"]){
            [self.marriagePicker show];
        }else if([label isEqualToString:@"smoke_type"]){
            [self.smokeTypePicker show];
        }else if([label isEqualToString:@"drink_type"]){
            [self.drinkTypePicker show];
        }else if([label isEqualToString:@"live_cust"]){
            [self.liveCustPicker show];
        }else if([label isEqualToString:@"child_want"]){
            [self.childWantPicker show];
        }else if([label isEqualToString:@"parent_together"]){
            [self.parentTogetherPicker show];
        }else if([label isEqualToString:@"paihang"]){
            [self.paihangPicker show];
        }else if([label isEqualToString:@"most_cost"]){
            [self.mostCostPicker show];
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
    }else if([picker isEqual:self.specialityTypePicker]){
        return @[@{@"label": @"1", @"desc": @"计算机类"}, @{@"label": @"2", @"desc": @"电子信息类"},
        @{@"label": @"3", @"desc": @"中文类"}, @{@"label": @"4", @"desc": @"外文类"},
        @{@"label": @"5", @"desc": @"经济学类"}, @{@"label": @"6", @"desc": @"金融类"}, @{@"label": @"7", @"desc": @"管理类"},
        @{@"label": @"8", @"desc": @"市场营销类"}, @{@"label": @"9", @"desc": @"法学类"}, @{@"label": @"10", @"desc": @"教育类"}, @{@"label": @"11", @"desc": @"社会学类"}, @{@"label": @"12", @"desc": @"历史类"}, @{@"label": @"13", @"desc": @"哲学类"}, @{@"label": @"14", @"desc": @"艺术类"}, @{@"label": @"15", @"desc": @"图书馆类"}, @{@"label": @"16", @"desc": @"情报档案类"}, @{@"label": @"17", @"desc": @"政治类"}, @{@"label": @"18", @"desc": @"数学类"}, @{@"label": @"19", @"desc": @"统计类"}, @{@"label": @"20", @"desc": @"物理类"}, @{@"label": @"21", @"desc": @"化学类"}, @{@"label": @"22", @"desc": @"生物类"},@{@"label": @"23", @"desc": @"食品类"},@{@"label": @"24", @"desc": @"医学类"},@{@"label": @"25", @"desc": @"环境类"},@{@"label": @"26", @"desc": @"地理类"},@{@"label": @"27", @"desc": @"建筑类"},@{@"label": @"28", @"desc": @"测绘类"},@{@"label": @"29", @"desc": @"电气类"},@{@"label": @"30", @"desc": @"机械类"},@{@"label": @"31", @"desc": @"体育类"},];
    }else if([picker isEqual:self.nationalPicker]){
        return @[@{@"label": @"1", @"desc": @"汉族"}, @{@"label": @"2", @"desc": @"藏族"},
        @{@"label": @"3", @"desc": @"朝鲜族"}, @{@"label": @"4", @"desc": @"蒙古族"},
        @{@"label": @"5", @"desc": @"回族"}, @{@"label": @"6", @"desc": @"满族"}, @{@"label": @"7", @"desc": @"维吾尔族"},
        @{@"label": @"8", @"desc": @"壮族"}, @{@"label": @"9", @"desc": @"彝族"}, @{@"label": @"10", @"desc": @"苗族"}, @{@"label": @"12", @"desc": @"其他民族"}, @{@"label": @"11", @"desc": @"白族"}];
    }else if([picker isEqual:self.religiousPicker]){
        return @[@{@"label": @"1", @"desc": @"无宗教信仰"}, @{@"label": @"2", @"desc": @"大乘佛教显宗"},
        @{@"label": @"3", @"desc": @"大乘佛教密宗"}, @{@"label": @"4", @"desc": @"小乘佛教"},
        @{@"label": @"5", @"desc": @"道教"}, @{@"label": @"6", @"desc": @"儒教"}, @{@"label": @"7", @"desc": @"基督教天主教派"},
        @{@"label": @"8", @"desc": @"基督教东正教派"}, @{@"label": @"9", @"desc": @"基督教新教派"}, @{@"label": @"10", @"desc": @"犹太教"}, @{@"label": @"11", @"desc": @"伊斯兰教什叶派"}, @{@"label": @"12", @"desc": @"伊斯兰教逊尼派"}, @{@"label": @"13", @"desc": @"印度教"}, @{@"label": @"14", @"desc": @"神道教"}, @{@"label": @"15", @"desc": @"萨满教"}, @{@"label": @"16", @"desc": @"其他宗教信仰"}];
    }else if([picker isEqual:self.bestParPicker]){
        return @[@{@"label": @"1", @"desc": @"笑容"}, @{@"label": @"2", @"desc": @"眉毛"},
        @{@"label": @"3", @"desc": @"眼睛"}, @{@"label": @"4", @"desc": @"头发"},
        @{@"label": @"5", @"desc": @"鼻梁"}, @{@"label": @"6", @"desc": @"嘴唇"}, @{@"label": @"7", @"desc": @"牙齿"},
        @{@"label": @"8", @"desc": @"颈部"}, @{@"label": @"9", @"desc": @"耳朵"}, @{@"label": @"10", @"desc": @"手"}, @{@"label": @"12", @"desc": @"胳膊"}, @{@"label": @"11", @"desc": @"腰部"},@{@"label": @"12", @"desc": @"胸部"}, @{@"label": @"17", @"desc": @"腰部"}, @{@"label": @"13", @"desc": @"臀部"}, @{@"label": @"14", @"desc": @"腿"}, @{@"label": @"15", @"desc": @"脚"}, @{@"label": @"16", @"desc": @"没有太特别"}];

    }else if([picker isEqual:self.bloodtypePicker]){
        return @[@{@"label": @"1", @"desc": @"A型"}, @{@"label": @"2", @"desc": @"B型"},
        @{@"label": @"3", @"desc": @"O型"}, @{@"label": @"4", @"desc": @"AB型"},
        @{@"label": @"5", @"desc": @"其他"}, @{@"label": @"6", @"desc": @"保密"}];

    }else if([picker isEqual:self.housePicker]){
        return @[@{@"label": @"1", @"desc": @"暂未购房"}, @{@"label": @"8", @"desc": @"需要时购置"},
        @{@"label": @"2", @"desc": @"已购住房"}, @{@"label": @"3", @"desc": @"与人合租"},
        @{@"label": @"4", @"desc": @"独自租房"}, @{@"label": @"5", @"desc": @"与父母同住"},@{@"label": @"6", @"desc": @"住亲朋家"}, @{@"label": @"7", @"desc": @"住单位房"}];
        
    }else if([picker isEqual:self.autoPicker]){
        return @[@{@"label": @"1", @"desc": @"暂时还没有"}, @{@"label": @"2", @"desc": @"已经购车"},
        @{@"label": @"2", @"desc": @"还没想好"}];
        
    }else if([picker isEqual:self.childrenPicker]){
        return @[@{@"label": @"1", @"desc": @"无小孩"}, @{@"label": @"2", @"desc": @"有小孩归自己"},
        @{@"label": @"3", @"desc": @"有小孩归对方"}];
        
    }else if([picker isEqual:self.marriagePicker]){
        return @[@{@"label": @"1", @"desc": @"未婚"}, @{@"label": @"2", @"desc": @"离异"},
        @{@"label": @"3", @"desc": @"丧偶"}];
        
    }else if([picker isEqual:self.smokeTypePicker]){
        return @[@{@"label": @"1", @"desc": @"不吸,很反感吸烟"}, @{@"label": @"2", @"desc": @"不吸烟,但不反感"},
        @{@"label": @"3", @"desc": @"社交时偶尔吸"}, @{@"label": @"4", @"desc": @"每周吸几次"}, @{@"label": @"5", @"desc": @"每天都吸"},@{@"label": @"6", @"desc": @"有烟瘾"}];
    }else if([picker isEqual:self.drinkTypePicker]){
        return @[@{@"label": @"1", @"desc": @"不喝"}, @{@"label": @"2", @"desc": @"社交需要时喝"},
        @{@"label": @"3", @"desc": @"有兴致时喝"}, @{@"label": @"4", @"desc": @"每天都离不开酒"}];
    }else if([picker isEqual:self.liveCustPicker]){
        return @[@{@"label": @"1", @"desc": @"早睡早期很规律"}, @{@"label": @"2", @"desc": @"经常夜猫子"},
        @{@"label": @"3", @"desc": @"总是早起鸟"}, @{@"label": @"4", @"desc": @"偶尔懒散一下"}, @{@"label": @"5", @"desc": @"没有规律"}];
     }else if([picker isEqual:self.childWantPicker]){
        return @[@{@"label": @"1", @"desc": @"愿意"}, @{@"label": @"2", @"desc": @"不愿意"},
        @{@"label": @"3", @"desc": @"视情况而定"}];
     }else if([picker isEqual:self.parentTogetherPicker]){
         return @[@{@"label": @"1", @"desc": @"愿意"}, @{@"label": @"2", @"desc": @"不愿意"},
         @{@"label": @"3", @"desc": @"视情况而定"}];
     }else if([picker isEqual:self.paihangPicker]){
         return @[@{@"label": @"1", @"desc": @"独生子女"}, @{@"label": @"2", @"desc": @"老大"},
         @{@"label": @"3", @"desc": @"老二"}, @{@"label": @"4", @"desc": @"老三"}, @{@"label": @"5", @"desc": @"老四"}, @{@"label": @"6", @"desc": @"老五及更小"}, @{@"label": @"7", @"desc": @"老幺"}];
     }else if([picker isEqual:self.mostCostPicker]){
         return @[@{@"label": @"1", @"desc": @"美食"}, @{@"label": @"2", @"desc": @"服装"},
         @{@"label": @"3", @"desc": @"娱乐"}, @{@"label": @"4", @"desc": @"出行"}, @{@"label": @"5", @"desc": @"交友"}, @{@"label": @"6", @"desc": @"文化"}, @{@"label": @"7", @"desc": @"教育"}, @{@"label": @"8", @"desc": @"其他"}];
     }

    return nil;
    
}

- (NSString *)titleForPopPicker:(HZPopPickerView *)picker
{
    if ([picker isEqual:self.rankPicker]) {
        return @"公司行业";
    } else if([picker isEqual:self.companyTypePicker]){
        return @"公司类型";
    } else if([picker isEqual:self.specialityTypePicker])
        return @"专业类型";
    else if([picker isEqual:self.nationalPicker])
        return @"民族";
    else if([picker isEqual:self.religiousPicker])
        return @"宗教信仰";
    else if([picker isEqual:self.bestParPicker])
        return @"魅力部位";
    else if([picker isEqual:self.bloodtypePicker])
        return @"血型";
    else if([picker isEqual:self.housePicker])
        return @"居住情况";
    else if([picker isEqual:self.autoPicker])
        return @"购车情况";
    else if([picker isEqual:self.childrenPicker])
        return @"有无子女";
    else if([picker isEqual:self.marriagePicker])
        return @"婚姻状况";
    else if([picker isEqual:self.smokeTypePicker])
        return @"吸烟";
    else if([picker isEqual:self.drinkTypePicker])
        return @"饮酒";
    else if([picker isEqual:self.liveCustPicker])
        return @"作息习惯";
    else if([picker isEqual:self.childWantPicker])
        return @"想要小孩";
    else if([picker isEqual:self.parentTogetherPicker])
        return @"同父母同住";
    else if([picker isEqual:self.paihangPicker])
        return @"家中排行";
    else if([picker isEqual:self.mostCostPicker])
        return @"最大消费";
    
    return nil;
}

- (void)popPickerDidChangeStatus:(HZPopPickerView *)picker withLabel:(NSString *)label withDesc:(NSString *)desc
{
    self.curField.text = desc;
    self.curEntry[@"value"] = desc;
    if ([picker isEqual:self.rankPicker]) {
        self.rankNum = label;
 
    } else if ([picker isEqual:self.companyTypePicker]){
        self.companyTypeNum = label;
    } else if([picker isEqual:self.specialityTypePicker]){
        self.specialtyTypeNum =label;
    }else if([picker isEqual:self.nationalPicker]){
        self.nationalNum =label;
    }else if([picker isEqual:self.religiousPicker]){
        self.religiousNum =label;
    }else if([picker isEqual:self.bestParPicker]){
        self.bestParNum = label;
    }else if([picker isEqual:self.bloodtypePicker]){
        self.bloodtypeNum = label;
    }else if([picker isEqual:self.housePicker]){
        self.houseNum = label;
    }else if([picker isEqual:self.autoPicker]){
        self.autoNum = label;
    }else if([picker isEqual:self.childrenPicker]){
        self.childrenNum = label;
    }else if([picker isEqual:self.marriagePicker]){
        self.marriageNum = label;
    }else if([picker isEqual:self.smokeTypePicker]){
        self.smokeTypeNum = label;
    }else if([picker isEqual:self.drinkTypePicker]){
        self.drinkTypeNum = label;
    }else if([picker isEqual:self.liveCustPicker]){
        self.liveCustNum = label;
    }else if([picker isEqual:self.childWantPicker]){
        self.childWantNum = label;
    }else if([picker isEqual:self.parentTogetherPicker]){
        self.parentTogetherNum = label;
    }else if([picker isEqual:self.paihangPicker]){
        self.paihangNum = label;
    }else if([picker isEqual:self.mostCostPicker]){
        self.mostCostNum = label;
    }
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    self.curField.text = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    self.curEntry[@"value"] = self.curField.text;
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
