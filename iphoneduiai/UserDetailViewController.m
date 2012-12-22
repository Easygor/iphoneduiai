//
//  UserDetailViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-28.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "UserDetailViewController.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "ShowPhotoView.h"
#import "AvatarView.h"
#import "MarrayReqView.h"
#import "MoreUserInfoView.h"
#import "WeiyuWordCell.h"
#import "CustomBarButtonItem.h"
#import "CopyQQViewController.h"
#import "SessionViewController.h"
#import "ShowCommentViewController.h"
#import "Notification.h"
#import "ForgetPasswordViewController.h"

#import "WeiyuContentCell.h"
#import "WeiyuFaqCell.h"
#import "WeiyuTextPicCell.h"
#import "WeiyuOnePicCell.h"
#import "WeiyuTwoAndMorePicCell.h"
#import "NSDate-Utilities.h"

static CGFloat dHeight = 0.0f;
static CGFloat dHeight2 = 0.0f;

@interface UserDetailViewController () <CustomCellDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet ShowPhotoView *showPhotoView;
@property (retain, nonatomic) IBOutlet AvatarView *avatarView;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSDictionary *userInfo, *userBody, *userLife, *userInterest, *userWork, *marrayReq, *searchIndex;
@property (retain, nonatomic) IBOutlet UILabel *nameAgeLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeDistanceLabel;

@property (retain, nonatomic) IBOutlet UILabel *heightLabel;
@property (retain, nonatomic) IBOutlet UILabel *areaLabel;
@property (retain, nonatomic) IBOutlet UILabel *incomeLabel;
@property (retain, nonatomic) IBOutlet UILabel *weightLabel;
@property (retain, nonatomic) IBOutlet UILabel *degreeLabel;
@property (retain, nonatomic) IBOutlet UILabel *careerLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *phoneLabel;
@property (retain, nonatomic) IBOutlet UIImageView *phoneImageView;
@property (retain, nonatomic) IBOutlet UIButton *snsbtn0;
@property (retain, nonatomic) IBOutlet UIButton *snsbtn1;
@property (retain, nonatomic) IBOutlet UIButton *snsbtn2;
@property (retain, nonatomic) IBOutlet MoreUserInfoView *moreUserInfoView;
@property (retain, nonatomic) IBOutlet MarrayReqView *marrayReqView;
@property (retain, nonatomic) IBOutlet UIView *move2View;
@property (retain, nonatomic) IBOutlet UIView *move1View;
@property (retain, nonatomic) IBOutlet UILabel *dySexLabel;
@property (retain, nonatomic) IBOutlet CountView *countView;

@property (strong, nonatomic) NSMutableArray *weiyus;
@property (strong, nonatomic) UITableViewCell *moreCell;
@property (nonatomic) NSInteger curPage, totalPage;
@property (nonatomic) BOOL loading;
@property (strong, nonatomic) NSMutableArray *digoList, *shitList;
@property (strong, nonatomic) NSDictionary *existedData;
@property (strong, nonatomic) NSArray *weiboList;
@property (strong, nonatomic) UIActionSheet *moreSheet, *descSheet;
@property (strong, nonatomic) NSArray *blockDescs;
@property (retain, nonatomic) IBOutlet UIButton *sendQQMsgBtn;
@property (retain, nonatomic) IBOutlet UIButton *sendMsgBtn;
@property (retain, nonatomic) IBOutlet UILabel *duiaiIDLabel;

@end

@implementation UserDetailViewController

- (void)dealloc
{
    [_blockDescs release];
    [_moreSheet release];
    [_descSheet release];
    [_existedData release];
    [_digoList release];
    [_shitList release];
    [_photos release];
    [_tableView release];
    [_user release];
    [_showPhotoView release];
    [_avatarView release];
    [_userInfo release];
    [_nameAgeLabel release];
    [_timeDistanceLabel release];
    [_heightLabel release];
    [_areaLabel release];
    [_incomeLabel release];
    [_weightLabel release];
    [_degreeLabel release];
    [_careerLabel release];
    [_addressLabel release];
    [_phoneLabel release];
    [_phoneImageView release];
    [_userBody release];
    [_userLife release];
    [_userInterest release];
    [_userWork release];
    [_marrayReq release];
    [_snsbtn0 release];
    [_snsbtn1 release];
    [_snsbtn2 release];
    [_marrayReqView release];
    [_move2View release];
    [_move1View release];
    [_dySexLabel release];
    [_moreUserInfoView release];
    [_weiyus release];
    [_moreCell release];
    [_countView release];
    [_searchIndex release];
    
    [_sendQQMsgBtn release];
    [_sendMsgBtn release];
    [_duiaiIDLabel release];
    [super dealloc];
}

- (NSArray *)blockDescs
{
    if (_blockDescs == nil) {
        _blockDescs = [[NSArray alloc] initWithArray:@[@"骚扰信息", @"色情信息", @"个人资料不当", @"盗用他人资料"]];

    }
    
    return _blockDescs;
}

- (void)setExistedData:(NSDictionary *)existedData
{
    if (![_existedData isEqualToDictionary:existedData]) {
        _existedData = [existedData retain];
        
        self.moreUserInfoView.moreUserInfo = existedData;
    }
}

- (NSMutableArray *)digoList
{
    if (_digoList == nil) {
        _digoList = [[NSMutableArray alloc] init];
    }
    
    return _digoList;
}

- (NSMutableArray *)shitList
{
    if (_shitList == nil) {
        _shitList = [[NSMutableArray alloc] init];
    }
    
    return _shitList;
}

- (void)setWeiyus:(NSMutableArray *)weiyus
{
    if (![_weiyus isEqualToArray:weiyus]) {
        if (self.curPage > 1) {
            [_weiyus addObjectsFromArray:weiyus];
        } else{
            _weiyus = [[NSMutableArray alloc] initWithArray:weiyus];
        }
        if (weiyus.count > 0)
        {
            self.move2View.hidden = NO;
        }
        else
        {
            self.move2View.hidden = YES;
        }
        [self.tableView reloadData];
    }
}

- (void)setMarrayReq:(NSDictionary *)marrayReq
{
    if (![_marrayReq isEqualToDictionary:marrayReq]) {
        _marrayReq = [marrayReq retain];
        self.marrayReqView.marrayReq = marrayReq;
    }
}

- (void)setPhotos:(NSMutableArray *)photos
{
    if (![_photos isEqualToArray:photos]) {
        _photos = [photos retain];
        self.showPhotoView.photos = photos;
    }
}

- (void)setWeiboList:(NSArray *)weiboList
{
    if (![_weiboList isEqualToArray:weiboList]) {
        _weiboList = [weiboList retain];
        
        for (NSDictionary *sns in weiboList)
        {
            if ([sns[@"bindtype"] isEqualToString:@"opensinaweibo"])
            {
                self.snsbtn0.enabled = YES;
                self.snsbtn0.tag = [weiboList indexOfObject:sns];
            }
            else if([sns[@"bindtype"] isEqualToString:@"opentweibo"])
            {
                self.snsbtn1.enabled = YES;
                self.snsbtn1.tag = [weiboList indexOfObject:sns];
            }
        }
        
    }
}

- (void)setSearchIndex:(NSDictionary *)searchIndex
{
    if (![_searchIndex isEqualToDictionary:searchIndex]) {
        _searchIndex = [searchIndex retain];
     
        self.timeDistanceLabel.text = [[NSDate dateWithTimeIntervalSince1970:[[searchIndex objectForKey:@"acctime"] integerValue]] stringForHuman];
        NSString *dname = [searchIndex[@"devicename"] description];
        if ([dname hasPrefix:@"iP"])
        {
            self.phoneImageView.image = [UIImage imageNamed:@"iPhone_icon"];
            self.phoneLabel.text = dname;
        }
        else if([[dname description] isEqualToString:@"0"])
        {
            self.phoneImageView.image = [UIImage imageNamed:@"pc_icon"];
            self.phoneLabel.text = @"PC";
        }
        else
        {
            self.phoneImageView.image = [UIImage imageNamed:@"andriod_icon"];
            self.phoneLabel.text = dname;
        }
        
        self.countView.count = [[searchIndex objectForKey:@"digocount"] description];

    }
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

- (void)setUserInfo:(NSDictionary *)userInfo
{
    if (![_userInfo isEqualToDictionary:userInfo]) {
        _userInfo = [userInfo retain];
        
        self.duiaiIDLabel.text = userInfo[@"uid"];
        self.avatarView.sex = [userInfo objectForKey:@"sex"];
        [self.avatarView.imageView loadImage:[userInfo objectForKey:@"photo"]];
        self.nameAgeLabel.text = [NSString stringWithFormat:@"%@, %@岁", [userInfo objectForKey:@"niname"], [userInfo objectForKey:@"age"]];

        
        self.heightLabel.text = [NSString stringWithFormat:@"%@CM", [userInfo objectForKey:@"height"]];

        self.incomeLabel.text = [userInfo objectForKey:@"income"];
        self.degreeLabel.text = [userInfo objectForKey:@"degree"];
        self.careerLabel.text = [userInfo objectForKey:@"industry"];
        
        // area process wtf
        if (![self.userInfo[@"area"] isEqualToString:@""])
        {
            self.areaLabel.text = [self.userInfo[@"city"] stringByAppendingString:[@" " stringByAppendingString:self.userInfo[@"area"]]];
        }
        else if(![self.userInfo[@"province"] isEqualToString:@""])
        {
            self.areaLabel.text = [self.userInfo[@"province"] stringByAppendingString:[@" " stringByAppendingString:self.userInfo[@"city"]]];
        }
        else
        {
            self.areaLabel.text = self.userInfo[@"city"];
        }
        
        self.dySexLabel.text = [NSString stringWithFormat:@"%@的动态", [userInfo objectForKey:@"ta"]];
        
        self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:userInfo[@"niname"]];

    }
}

- (void)setUserBody:(NSDictionary *)userBody
{
    if (![_userBody isEqualToDictionary:userBody]) {
        _userBody = [userBody retain];
        
        if ([[userBody objectForKey:@"weight"] isEqualToString:@"未填"]) {
            self.weightLabel.text = [userBody objectForKey:@"weight"];
        } else{
            self.weightLabel.text = [NSString stringWithFormat:@"%@kg", [userBody objectForKey:@"weight"]];
        }
    }
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setShowPhotoView:nil];
    [self setAvatarView:nil];
    [self setNameAgeLabel:nil];
    [self setTimeDistanceLabel:nil];
    [self setHeightLabel:nil];
    [self setAreaLabel:nil];
    [self setIncomeLabel:nil];
    [self setWeightLabel:nil];
    [self setDegreeLabel:nil];
    [self setCareerLabel:nil];
    [self setAddressLabel:nil];
    [self setPhoneLabel:nil];
    [self setPhoneImageView:nil];
    [self setSnsbtn0:nil];
    [self setSnsbtn1:nil];
    [self setSnsbtn2:nil];
    [self setMarrayReqView:nil];
    [self setMove2View:nil];
    [self setMove1View:nil];
    [self setDySexLabel:nil];
    [self setMoreUserInfoView:nil];
    [self setCountView:nil];

    [self setSendQQMsgBtn:nil];
    [self setSendMsgBtn:nil];
    [self setDuiaiIDLabel:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"user data:%@", self.user);
    dHeight = self.marrayReqView.frame.size.height;
    dHeight2 = self.moreUserInfoView.frame.size.height;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.tableView.alwaysBounceVertical = YES;
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initBarButtonWithImage:[UIImage imageNamed:@"etc"]
                                                                                          target:self
                                                                                          action:@selector(moreAction)] autorelease];
    [self.countView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scoreGestureAction:)] autorelease]];

    [self grabUserInfoDetailRequest];
    [self infoRequestFromRemote];
    [self grabMyWeiyuListReqeustWithPage:1];
}

- (void)scoreGestureAction:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        
        [Utils scoreUserWithUid:[self.user objectForKey:@"_id"] block:^{
            NSString *scoreString = [NSString stringWithFormat:@"%d", [self.countView.count integerValue]+1];
            self.countView.count = scoreString;
        }];
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreAction
{
    self.moreSheet = [[[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"拉黑", @"拉黑并举报", nil] autorelease];
    [self.moreSheet showInView:self.view.window];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        return;
    }
    
    if ([actionSheet isEqual:self.moreSheet]) {
        // eeqq
        if (0 == buttonIndex) {
            NSMutableDictionary *params = [Utils queryParams];
            params[@"uid"] = self.user[@"_id"];

            [SVProgressHUD show];
            [[RKClient sharedClient] get:[@"/common/addblack.api" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
//                NSLog(@"url: %@", request.URL);
                [request setOnDidLoadResponse:^(RKResponse *response){
                    if (response.isOK && response.isJSON) {
                        NSMutableDictionary *data = [[response bodyAsString] mutableObjectFromJSONString];
                        NSInteger code = [data[@"error"] integerValue];
                        if (code == 0) {

                            // 此行须在前两行后面
                            [SVProgressHUD showSuccessWithStatus:data[@"message"]];
                        } else{
                            [SVProgressHUD showErrorWithStatus:data[@"message"]];
                        }
                    } else{
                        [SVProgressHUD showErrorWithStatus:@"拉黑失败"];
                    }
                }];
                [request setOnDidFailLoadWithError:^(NSError *error){
                    [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
                    NSLog(@"lahei Error: %@", [error description]);
                }];
            }];

        } else if (1 == buttonIndex){
            self.descSheet = [[[UIActionSheet alloc] initWithTitle:@"举报"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"骚扰信息", @"色情信息", @"个人资料不当", @"盗用他人资料", nil] autorelease];
            [self.descSheet showInView:self.view.window];
        }
    } else if ([actionSheet isEqual:self.descSheet]){
        NSString *desc = self.blockDescs[buttonIndex];
        NSMutableDictionary *params = [Utils queryParams];

        //        [params setObject:n[@"tid"] forKey:@"tid[]"];
        [SVProgressHUD show];

        [[RKClient sharedClient] post:[@"/uc/complaints.api" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
//            NSLog(@"url: %@", request.URL);
            
            request.params = [RKParams paramsWithDictionary:@{@"type" : @"1", @"comuid": self.user[@"_id"], @"content": desc, @"submitupdate": @"true"}];
            
            [request setOnDidLoadResponse:^(RKResponse *response){
                if (response.isOK && response.isJSON) {
                    NSDictionary *data = [[response bodyAsString] objectFromJSONString];
                    NSInteger code = [data[@"error"] integerValue];
                    if (code == 0) {

                        [SVProgressHUD showSuccessWithStatus:data[@"message"]];
                    } else{
                        [SVProgressHUD showErrorWithStatus:data[@"message"]];
                    }
                    
                } else{
                    [SVProgressHUD showErrorWithStatus:@"获取失败"];
                }
            }];
            [request setOnDidFailLoadWithError:^(NSError *error){
                [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
                NSLog(@"Error: %@", [error description]);
            }];
        }];

        
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.totalPage <= self.curPage) {
        return self.weiyus.count;
    } else{
        return self.weiyus.count + 1;
    }

}

-(UITableViewCell *)createMoreCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moretag"] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UILabel *labelNumber = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 100, 20)];
    labelNumber.textAlignment = UITextAlignmentCenter;
    
    if (self.totalPage <= self.curPage){
        labelNumber.text = @"";
    } else {
        labelNumber.text = @"更多";
    }
    
	[labelNumber setTag:1];
	labelNumber.backgroundColor = [UIColor clearColor];
	labelNumber.font = [UIFont boldSystemFontOfSize:18];
	[cell.contentView addSubview:labelNumber];
	[labelNumber release];
	
    self.moreCell = cell;
    
    return self.moreCell;
}

- (UITableViewCell *)creatNormalCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *weiyu = self.weiyus[indexPath.row];
    if ([weiyu[@"vtype"] isEqualToString:@"photo"])
    {
        NSArray *photolist = weiyu[@"photolist"];
        
        if(1 < photolist.count && 4 > photolist.count)
        {
            static NSString *CellIdentifier = @"WeiyuThreeCell";
            [tableView registerNib:[UINib nibWithNibName:@"WeiyuThreeCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            WeiyuTwoAndMorePicCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.delegate = self;
            cell.weiyu = weiyu;
            
            return cell;
        }
        else if(4 == photolist.count)
        {
            static NSString *CellIdentifier = @"WeiyuFourCell";
            [tableView registerNib:[UINib nibWithNibName:@"WeiyuFourCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            WeiyuTwoAndMorePicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.delegate = self;
            
            cell.weiyu = weiyu;
            
            return cell;
        }
        else if(4 < photolist.count && 7 > photolist.count)
        {
            static NSString *CellIdentifier = @"WeiyuSixCell";
            [tableView registerNib:[UINib nibWithNibName:@"WeiyuSixCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            WeiyuTwoAndMorePicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.delegate= self;
            
            cell.weiyu = weiyu;
            
            return cell;
        }
        else if(6 < photolist.count && 10 > photolist.count)
        {
            static NSString *CellIdentifier = @"WeiyuNineCell";
            [tableView registerNib:[UINib nibWithNibName:@"WeiyuNineCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            WeiyuTwoAndMorePicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.delegate = self;
            
            cell.weiyu = weiyu;
            
            return cell;
        } else {
            static NSString *CellIdentifier = @"WeiyuOnePicCell";
            [tableView registerNib:[UINib nibWithNibName:@"WeiyuOnePicCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            WeiyuOnePicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.delegate = self;
            
            cell.weiyu = weiyu;
            
            return cell;
        }
        
    }
    else if ([weiyu[@"vtype"] isEqualToString:@"textpic"])
    {
        static NSString *CellIdentifier = @"WeiyuTextPicCell";
        [tableView registerNib:[UINib nibWithNibName:@"WeiyuTextPicCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        WeiyuTextPicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        
        cell.weiyu = weiyu;
        
        return cell;
    }
    else if ([weiyu[@"vtype"] isEqualToString:@"faq"])
    {
        static NSString *CellIdentifier = @"WeiyuFaqCell";
        [tableView registerNib:[UINib nibWithNibName:@"WeiyuFaqCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        WeiyuFaqCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        
        cell.weiyu = weiyu;
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"WeiyuContentCell";
        [tableView registerNib:[UINib nibWithNibName:@"WeiyuContentCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        WeiyuContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        
        cell.weiyu = weiyu;
        
        return cell;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.weiyus.count) {
        return [self createMoreCell:tableView cellForRowAtIndexPath:indexPath];
    }else {
        return [self creatNormalCell:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.weiyus.count) {
        
        return 40.0f;
    }else {
        WeiyuWordCell *cell = (WeiyuWordCell *)[self creatNormalCell:tableView cellForRowAtIndexPath:indexPath];
        return [cell requiredHeight];
        
    }
}

- (void)loadNextInfoList
{
    UILabel *label = (UILabel*)[self.moreCell.contentView viewWithTag:1];
    label.text = @"正在加载..."; // bug no reload table not show it.
    
    if (!self.loading) {
        [self grabMyWeiyuListReqeustWithPage:self.curPage+1];
        self.loading = YES;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.weiyus.count) {
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self loadNextInfoList];
        });
    }
}

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

#pragma mark - Table view delegate

- (void)grabUserInfoDetailRequest
{
    NSMutableDictionary *dParams = [Utils queryParams];
    [dParams setObject:[self.user objectForKey:@"_id"] forKey:@"uid"];
    
    [[RKClient sharedClient] get:[@"user" stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSMutableDictionary *data = [[response bodyAsString] mutableObjectFromJSONString];
//                NSLog(@"user data: %@", data);
                NSInteger code = [[data objectForKey:@"error"] integerValue];
                if (code == 0)
                {
                    NSDictionary *dataData = [data objectForKey:@"data"];
                    self.photos = [dataData objectForKey:@"photo"];
                    self.userInfo = [dataData objectForKey:@"user_info"];
                    self.userBody = [dataData objectForKey:@"user_body"];
                    self.userLife = [dataData objectForKey:@"user_life"];
                    self.userInterest = [dataData objectForKey:@"user_interest"];
                    self.userWork = [dataData objectForKey:@"user_work"];
                    self.marrayReq = [dataData objectForKey:@"marray_req"];
                    if (dataData[@"searchindex"] != [NSNull null]) {
                        self.searchIndex = [dataData objectForKey:@"searchindex"];
                    }
                    self.weiboList = dataData[@"bindlist"];
                    self.sendMsgBtn.enabled = YES;
                    self.sendQQMsgBtn.enabled = YES;
                }
                else
                {
                    // alertview
                    UIAlertView *noInfoAlertView = [[UIAlertView alloc]
                                                    initWithTitle:nil
                                                    message:data[@"message"]
                                                    delegate:self
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"确定", nil];
                    [noInfoAlertView show];
                    [noInfoAlertView release];
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"获取信息出错"];
            }
        }];
        
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"Get user info detail error: %@, url: %@", [error description], request.URL);
        }];
        
    }];
}

#pragma mark - alertview delegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex) {
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)grabMyWeiyuListReqeustWithPage:(NSInteger)page
{
    NSMutableDictionary *dParams = [Utils queryParams];

//    [dParams setObject:@"myv" forKey:@"a"];
    [dParams setObject:[self.user objectForKey:@"_id"] forKey:@"uid"];
    [dParams setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dParams setObject:@"10" forKey:@"pagesize"];
    
    [[RKClient sharedClient] get:[@"/v" stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSMutableDictionary *data = [[response bodyAsString] mutableObjectFromJSONString];
                NSInteger code = [data[@"error"] integerValue];
                //                NSLog(@"my weiyu data: %@", data);
                if (code == 0) {
                    if (![[data objectForKey:@"data"] isKindOfClass:[NSString class]]) {
                        self.loading = NO;
                        self.totalPage = [[[data objectForKey:@"pager"] objectForKey:@"pagecount"] integerValue];
                        self.curPage = [[[data objectForKey:@"pager"] objectForKey:@"thispage"] integerValue];
                        // 此行须在前两行后面
                        self.weiyus = [data objectForKey:@"data"];
                    }
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

#pragma mark - event actions

- (IBAction)sendMsgAction
{

    SessionViewController *svc = [[SessionViewController alloc] initWithNibName:@"SessionViewController" bundle:nil];
    NSMutableDictionary *msgTmp = [[Notification sharedInstance] getMessageWithUid:self.user[@"_id"]];
    if (msgTmp == nil) {
        NSMutableDictionary *info = [[[NSMutableDictionary alloc] init] autorelease];
        msgTmp = [[[NSMutableDictionary alloc] init] autorelease];
        info[@"niname"] = self.user[@"niname"];
        info[@"photo"] = self.user[@"photo"];
        msgTmp[@"senduid"] = self.user[@"_id"];
        msgTmp[@"uinfo"] = info;
    }
    
    svc.messageData = msgTmp;
    svc.senduid = self.user[@"_id"];
    [self.navigationController pushViewController:svc animated:YES];
    [svc release];
    
}

- (IBAction)checkQQAction
{
    
    NSMutableDictionary *dp = [Utils queryParams];
    [SVProgressHUD show];
    [[RKClient sharedClient] post:[@"/common/contact.api" stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){
        
        // 设置POST的form表单的参数
        NSMutableDictionary *updateArgs = [NSMutableDictionary dictionary];
        
        updateArgs[@"uid"] = self.user[@"_id"];
        updateArgs[@"agree"] = @"0";
        
        request.params = [RKParams paramsWithDictionary:updateArgs];
        
        // 请求失败时
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"Error: %@", [error description]);
        }];
        
        // 请求成功时
        [request setOnDidLoadResponse:^(RKResponse *response){
            NSLog(@"error: %@", response.bodyAsString);
            if (response.isOK && response.isJSON) { // 200的返回并且是JSON数据
                NSDictionary *data = [response.bodyAsString objectFromJSONString]; // 提交后返回的状态
                NSInteger code = [data[@"error"] integerValue];  // 返回的状态
                if (code == 0) {
                    // 成功提交的情况
                    // ....
                    CopyQQViewController *copyQQViewController = [[[CopyQQViewController alloc]init]autorelease];
                    copyQQViewController.QQdata = data;
                    [self.navigationController pushViewController:copyQQViewController animated:YES];
                    [SVProgressHUD dismiss];

                } else{
                    // 失败的情况
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
            } else{
                [SVProgressHUD showErrorWithStatus:@"获取失败"];
            }
        }];
        
    }];
   
}

- (IBAction)moreDetailAction:(UIButton *)sender
{

    if (sender.tag == 0) {
        UIView *view = sender.superview;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect move1 = self.move1View.frame;
            CGRect move2 = self.move2View.frame;
            move1.origin.y += dHeight2;
            move2.origin.y += dHeight2;
            self.move1View.frame = move1;
            self.move2View.frame = move2;
            
            UIView *headerView = self.tableView.tableHeaderView;
            CGRect frame = headerView.frame;
            frame.size.height += dHeight2;
            headerView.frame = frame;
            self.tableView.tableHeaderView = headerView;
            
            if ([self.marrayReqView superview] != nil) {
                CGRect marray = self.marrayReqView.frame;
                marray.origin.y += dHeight2;
                self.marrayReqView.frame = marray;
            }
            
        }];
        [self.moreUserInfoView showMeInView:self.tableView.tableHeaderView
                                    atPoint:CGPointMake(view.frame.origin.x, view.frame.origin.y+view.frame.size.height)
                                   animated:YES];
        
        
        sender.tag = 1;
    } else{
        [self.moreUserInfoView removeMeWithAnimated:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect move1 = self.move1View.frame;
            CGRect move2 = self.move2View.frame;
            move1.origin.y -= dHeight2;
            move2.origin.y -= dHeight2;
            self.move1View.frame = move1;
            self.move2View.frame = move2;
            
            UIView *headerView = self.tableView.tableHeaderView;
            CGRect frame = headerView.frame;
            frame.size.height -= dHeight2;
            headerView.frame = frame;
            self.tableView.tableHeaderView = headerView;
            
            if ([self.marrayReqView superview] != nil) {
                CGRect marray = self.marrayReqView.frame;
                marray.origin.y -= dHeight2;
                self.marrayReqView.frame = marray;
            }
        }];
        sender.tag = 0;
    }
    
}

- (IBAction)friendConditionAction:(UIButton *)sender
{

    if (sender.tag == 0) {  
        UIView *view = sender.superview;
        [UIView animateWithDuration:0.3 animations:^{
            //            CGRect move1 = self.move1View.frame;
            CGRect move2 = self.move2View.frame;
            //            move1.origin.y += dHeight;
            move2.origin.y += dHeight;
            //            self.move1View.frame = move1;
            self.move2View.frame = move2;
            
            UIView *headerView = self.tableView.tableHeaderView;
            CGRect frame = headerView.frame;
            frame.size.height += dHeight;
            headerView.frame = frame;
            self.tableView.tableHeaderView = headerView;
            
        }];
        [self.marrayReqView showMeInView:self.tableView.tableHeaderView
                                 atPoint:CGPointMake(view.frame.origin.x, view.frame.origin.y+view.frame.size.height)
                                animated:YES];

        
        sender.tag = 1;
    } else{
        [self.marrayReqView removeMeWithAnimated:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            //            CGRect move1 = self.move1View.frame;
            CGRect move2 = self.move2View.frame;
            //            move1.origin.y += dHeight;
            move2.origin.y -= dHeight;
            //            self.move1View.frame = move1;
            self.move2View.frame = move2;
            
            UIView *headerView = self.tableView.tableHeaderView;
            CGRect frame = headerView.frame;
            frame.size.height -= dHeight;
            headerView.frame = frame;
            self.tableView.tableHeaderView = headerView;
        }];
        sender.tag = 0;
    }
    
}

- (void)digoWeiyu:(NSMutableDictionary*)weiyu cell:(WeiyuWordCell*)cell shit:(BOOL)isShit
{
    NSMutableDictionary *params = [Utils queryParams];
    
    [SVProgressHUD show];
    [[RKClient sharedClient] post:[@"/v/digo.api" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
//        NSLog(@"url: %@", request.URL);
        
        request.params = [RKParams paramsWithDictionary:@{@"id" : weiyu[@"id"], @"shit": @(isShit), @"submitupdate": @"true"}];
        
        [request setOnDidLoadResponse:^(RKResponse *response){
            
            if (response.isOK && response.isJSON) {
                NSDictionary *data = [[response bodyAsString] objectFromJSONString];
                //                        NSLog(@"read data: %@", data[@"message"]);
                NSInteger code = [data[@"error"] integerValue];
                if (code == 0) {
                    if (isShit) {
                        
                        cell.shitNum += 1;
                        [self.shitList addObject:weiyu[@"id"]];
                    } else{
                        if ([self.digoList containsObject:weiyu[@"id"]]) {
                            [self.digoList removeObject:weiyu[@"id"]];
                            cell.digoNum -= 1;
                        } else{
                            [self.digoList addObject:weiyu[@"id"]];
                            cell.digoNum += 1;
                        }
                        
                    }
                    
                    [SVProgressHUD dismiss];
                } else{
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
            } else{
                [SVProgressHUD showErrorWithStatus:@"获取失败"];
            }
        }];
        [request setOnDidFailLoadWithError:^(NSError *error){
            [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
            NSLog(@"Error: %@", [error description]);
        }];
    }];
}

#pragma mark - cell delegate
- (void)didChangeStatus:(UITableViewCell *)cell toStatus:(NSString *)status
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //    NSLog(@"status: %@", status);
    NSMutableDictionary *weiyu = self.weiyus[indexPath.row];
    //    NSString *idStr = weiyu[@"id"];
    if ([status isEqualToString:@"comment"]) {
        
        ShowCommentViewController *showCommentViewController = [[ShowCommentViewController alloc]initWithNibName:@"ShowCommentViewController" bundle:nil];
        showCommentViewController.weiYuDic = weiyu;
        [self.navigationController pushViewController:showCommentViewController animated:YES];
        [showCommentViewController release];
        
    } else if ([status isEqualToString:@"minus"]){
        // minus
        if (![self.shitList containsObject:weiyu[@"id"]]) {
            [self digoWeiyu:weiyu cell:(WeiyuWordCell*)cell shit:YES];
        }
        
    } else if ([status isEqualToString:@"plus"]){
        // plus
        
        [self digoWeiyu:weiyu cell:(WeiyuWordCell*)cell shit:NO];
        
        
    }
    
}

-(void)infoRequestFromRemote
{
    
    NSMutableDictionary *dParams  = [Utils queryParams];
    dParams[@"uid"] = self.user[@"_id"];
    
    [[RKClient sharedClient] get:[@"/uc/userinfo.api" stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
        //        NSLog(@"url: %@", request.URL);
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSDictionary *data = [[response bodyAsString] objectFromJSONString];
                //                NSLog(@"digo data %@", data);
                NSInteger code = [data[@"error"] integerValue];
                if (code == 0) {
                    // 此行须在前两行后面
//                    NSLog(@"all user profile info: %@", data);
                    self.existedData = data[@"data"][@"issetlist"];
                    
                } else{
                    //                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
            } else{
                [SVProgressHUD showErrorWithStatus:@"获取失败"];
            }
        }];
        [request setOnDidFailLoadWithError:^(NSError *error){
            //            [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
            NSLog(@"Error: %@", [error description]);
        }];
    }];
    
}

- (IBAction)snsBtnAction:(UIButton*)btn
{
    NSDictionary *t = self.weiboList[btn.tag];
    NSString *aUrlString = @"";
    if ([t[@"bindtype"] isEqualToString:@"opensinaweibo"]) {
        aUrlString = [t[@"url"] stringByReplacingOccurrencesOfString:@"weibo.com" withString:@"m.weibo.cn"];
    }
    else if ([t[@"bindtype"] isEqualToString:@"opentweibo"])
    {
        aUrlString = [t[@"url"] stringByReplacingOccurrencesOfString:@"t.qq.com/" withString:@"ti.3g.qq.com/touch/iphone/#guest_home/u="];
    }
    
//    NSURL *url = [NSURL URLWithString:urlString];
//    if (url) {
//        [[UIApplication sharedApplication] openURL:url];
//    }
    
    ForgetPasswordViewController *fpvc = [[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:nil];
    fpvc.urlString = aUrlString;
    [self.navigationController pushViewController:fpvc animated:YES];
    [fpvc release];

}

@end
