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

@interface SSViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *entries;

@end

@implementation SSViewController

- (NSArray *)entries
{
    if (_entries == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"seniorEntries" withExtension:@"plist"];
        _entries = [[NSArray alloc] initWithContentsOfURL:url];
    }
    
    return _entries;
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
        
        
        bigLabel = [[[UILabel alloc]initWithFrame:CGRectZero] autorelease];
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
    UIImage *img = nil;
    UIImage *arrowImg = [UIImage imageNamed:@"statusdetail_header_arrow.png"];
    
    if (![[data objectForKey:@"logo"] isEqualToString:@""]) {
        bigLabel.frame = CGRectMake(15, 0, 200, 44);
        img = [UIImage imageNamed:[data objectForKey:@"logo"]];
        
    } else{
        bigLabel.frame = CGRectMake(10, 0, 200, 44);
    }
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - text delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"OK: %d", textField.superview.tag);
    NSDictionary *entry = self.entries[textField.superview.tag/1000][textField.superview.tag - (textField.superview.tag/1000)*1000];
    NSString *label = entry[@"label"];
    
    if ([label isEqual:@"company_name"] || [label isEqual:@"speciality"]) {
        return YES;
    } else{
        // do here
        
        return NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
