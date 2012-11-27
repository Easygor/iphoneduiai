//
//  ProfileListViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ProfileListViewController.h"
#import "CustomBarButtonItem.h"
#import "SettingViewController.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "ShowPhotoView.h"
#import "AvatarView.h"
#import "MarrayReqView.h"
#import "MoreUserInfoView.h"
#import "WeiyuWordCell.h"
#import "WeiboBindingViewController.h"
#import "QQSetViewController.h"
#import "ChooseMateViewController.h"
#import "SSViewController.h"
#import "ShowCommentViewController.h"
#import "CommentViewController.h"

#import "HZNumberPickerView.h"
#import "HZAreaPickerView.h"
#import "HZPopPickerView.h"
#import "ForgetPasswordViewController.h"

#import "WeiyuContentCell.h"
#import "WeiyuFaqCell.h"
#import "WeiyuTextPicCell.h"
#import "WeiyuOnePicCell.h"
#import "WeiyuTwoAndMorePicCell.h"

static CGFloat dHeight = 0.0f;
static CGFloat dHeight2 = 0.0f;
static NSInteger kActionChooseImageTag = 201;
static NSInteger kDelWeiyuTag = 204;

@interface ProfileListViewController () <CustomCellDelegate, HZAreaPickerDatasource, HZAreaPickerDelegate, HZNumberPickerDelegate, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ShowPhotoDelegate, HZPopPickerDatasource, HZPopPickerDelegate>

@property (retain, nonatomic) IBOutlet ShowPhotoView *showPhotoView;
@property (retain, nonatomic) IBOutlet AvatarView *avatarView;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSDictionary *userInfo, *userBody, *userLife, *userInterest, *userWork, *searchIndex;
@property (strong, nonatomic) NSMutableDictionary *marrayReq;
@property (retain, nonatomic) IBOutlet UILabel *nameAgeLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeDistanceLabel;

@property (retain, nonatomic) IBOutlet UITextField *incomeField, *areaField, *heightField, *weightField, *degreeField, *careerField;
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
@property (retain, nonatomic) IBOutlet UIView *basicView;
@property (retain, nonatomic) IBOutlet UIView *snsBtnView;
@property (retain, nonatomic) IBOutlet UIView *moreView;
@property (retain, nonatomic) IBOutlet UIView *nameView;
@property (retain, nonatomic) IBOutlet UIView *posView;
@property (retain, nonatomic) IBOutlet UIView *mobileView;
@property (retain, nonatomic) IBOutlet UIView *careerView;

@property (strong, nonatomic) NSMutableArray *weiyus;
@property (strong, nonatomic) UITableViewCell *moreCell;
@property (nonatomic) NSInteger curPage, totalPage;
@property (nonatomic) BOOL loading;
@property (retain, nonatomic) IBOutlet UIView *editorBtnsView;
@property (retain, nonatomic) IBOutlet UIImageView *img1;
@property (retain, nonatomic) IBOutlet UIImageView *img2;
@property (retain, nonatomic) IBOutlet UIImageView *img3;
@property (retain, nonatomic) IBOutlet UIImageView *img4;
@property (retain, nonatomic) IBOutlet UIImageView *img5;
@property (retain, nonatomic) IBOutlet UIImageView *img6;

@property (strong, nonatomic) UIBarButtonItem *cancelBarItem, *saveBarItem, *settingBarItem, *changeBaritem;
@property (nonatomic) BOOL isUploadPhoto;
@property (nonatomic) NSInteger heightNum, weightNum;

@property (strong, nonatomic) HZNumberPickerView *heightPicker, *weightPicker;
@property (strong, nonatomic) HZAreaPickerView *areaPicker;
@property (strong, nonatomic) HZLocation *location;
@property (strong, nonatomic) NSString *eduNum, *incomeNum, *jobNum;
@property (strong, nonatomic) HZPopPickerView *incomePickerView, *degreePicker, *jobPicker;

@property (strong, nonatomic) NSIndexPath *curIndexPath;
@property (nonatomic) BOOL isEditing;
@property (strong, nonatomic) NSDictionary *existedData;

@property (strong, nonatomic) NSMutableArray *digoList, *shitList;
@property (strong, nonatomic) NSArray *weiboList;

@property (strong, nonatomic) NSDate *lastWeiyuUpdateTime, *lastUserInfoUpdateTime, *lastBasicInfoUpdateTime;
@property (retain, nonatomic) IBOutlet UILabel *duiaiIDLabel;
@property (retain, nonatomic) IBOutlet UIButton *moreDetailBtn;
@property (retain, nonatomic) IBOutlet UIButton *chooseMateBtn;

@end

@implementation ProfileListViewController

- (void)dealloc
{
    [_lastBasicInfoUpdateTime release];
    [_lastUserInfoUpdateTime release];
    [_lastWeiyuUpdateTime release];
    [_digoList release];
    [_shitList release];
    [_existedData release];
    [_curIndexPath release];
    [_jobPicker release];
    [_jobNum release];
    [_incomePickerView release];
    [_degreePicker release];
    [_incomeNum release];
    [_eduNum release];
    [_areaPicker release];
    [_location release];
    [_photos release];
    [_showPhotoView release];
    [_avatarView release];
    [_userInfo release];
    [_nameAgeLabel release];
    [_timeDistanceLabel release];
    [_heightField release];
    [_areaField release];
    [_incomeField release];
    [_weightField release];
    [_degreeField release];
    [_careerField release];
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
    [_editorBtnsView release];
    [_basicView release];
    [_snsBtnView release];
    [_moreView release];
    [_nameView release];
    [_posView release];
    [_mobileView release];
    [_careerView release];
    [_img1 release];
    [_img2 release];
    [_img3 release];
    [_img4 release];
    [_img5 release];
    [_img6 release];
    [_heightPicker release];
    [_weightPicker release];
    [_duiaiIDLabel release];
    [_moreDetailBtn release];
    [_chooseMateBtn release];
    [super dealloc];
}

- (void)setWeiboList:(NSArray *)weiboList
{
    if (![_weiboList isEqualToArray:weiboList])
    {
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

- (HZNumberPickerView *)heightPicker
{
    if (_heightPicker == nil) {
        _heightPicker = [[HZNumberPickerView alloc] initWithMinNum:140 maxNum:250];
        _heightPicker.titleLabel.text = @"你的身高(cm)";
        _heightPicker.delegate = self;
    }
    
    return _heightPicker;
}

- (HZNumberPickerView *)weightPicker
{
    if (_weightPicker == nil) {
        _weightPicker = [[HZNumberPickerView alloc] initWithMinNum:35 maxNum:200];
        _weightPicker.titleLabel.text = @"你的体重(kg)";
        _weightPicker.delegate = self;
    }
    
    return _weightPicker;
}

- (HZPopPickerView *)degreePicker
{
    if (_degreePicker == nil) {
        _degreePicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _degreePicker;
}

- (HZPopPickerView *)jobPicker
{
    if (_jobPicker == nil) {
        _jobPicker = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _jobPicker;
}

- (HZPopPickerView *)incomePickerView
{
    if (_incomePickerView == nil) {
        _incomePickerView = [[HZPopPickerView alloc] initWithDelegate:self];
    }
    
    return _incomePickerView;
}

- (void)setSearchIndex:(NSDictionary *)searchIndex
{
    if (![_searchIndex isEqualToDictionary:searchIndex]) {
        _searchIndex = [searchIndex retain];
        
        self.timeDistanceLabel.text = [NSString stringWithFormat:@"%@", [Utils descriptionForTime:[NSDate dateWithTimeIntervalSince1970:[[searchIndex objectForKey:@"acctime"] integerValue]]]];
        self.countView.count = [[searchIndex objectForKey:@"digocount"] description];
        
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

- (void)setWeiyus:(NSMutableArray *)weiyus
{
    if (![_weiyus isEqualToArray:weiyus]) {
        if (self.curPage > 1)
        {
            [_weiyus addObjectsFromArray:weiyus];
        } else
        {
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

- (void)setMarrayReq:(NSMutableDictionary *)marrayReq
{
    if (![_marrayReq isEqualToDictionary:marrayReq]) {
        _marrayReq = [marrayReq retain];
        self.marrayReqView.marrayReq = marrayReq;
    }
}

- (void)setUserInterest:(NSDictionary *)userInterest
{
    if (![_userInterest isEqualToDictionary:userInterest])
    {
        _userInterest = [userInterest retain];
        self.moreUserInfoView.moreUserInfo = userInterest;
    }
}

- (void)setPhotos:(NSMutableArray *)photos
{
    if (![_photos isEqualToArray:photos])
    {
        _photos = [photos retain];
        self.showPhotoView.photos = photos;
    }
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    if (![_userInfo isEqualToDictionary:userInfo]) {
        _userInfo = [userInfo retain];
        
        self.duiaiIDLabel.text = userInfo[@"uid"];
        
        self.avatarView.sex = [userInfo objectForKey:@"sex"];
        [self.avatarView.imageView loadImage:[userInfo objectForKey:@"photo"]];
        self.nameAgeLabel.text = [NSString stringWithFormat:@"%@, %@岁", [userInfo objectForKey:@"niname"], [userInfo objectForKey:@"age"]];
        
        self.heightField.text = [NSString stringWithFormat:@"%@cm", [userInfo objectForKey:@"height"]];

        self.incomeField.text = [userInfo objectForKey:@"income"];
        self.degreeField.text = [userInfo objectForKey:@"degree"];
        self.careerField.text = [userInfo objectForKey:@"industry"];
        
        
        if (![userInfo[@"area"] isEqualToString:@""])
        {
            self.areaField.text = [userInfo[@"city"] stringByAppendingString:[@" " stringByAppendingString:userInfo[@"area"]]];
        }
        else
        {
            self.areaField.text = userInfo[@"city"];
        }
        
        self.dySexLabel.text = @"我的动态"/*[NSString stringWithFormat:@"%@的动态", [userInfo objectForKey:@"ta"]]*/;
        
        self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:userInfo[@"niname"]];
    }
}

- (void)setUserBody:(NSDictionary *)userBody
{
    if (![_userBody isEqualToDictionary:userBody]) {
        _userBody = [userBody retain];
        
        if ([[userBody objectForKey:@"weight"] isEqualToString:@"未填"]) {
            self.weightField.text = [userBody objectForKey:@"weight"];
        } else{
            self.weightField.text = [NSString stringWithFormat:@"%@kg", [userBody objectForKey:@"weight"]];
        }
        
    }
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
        _areaPicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
    }
    return _areaPicker;
}

- (void)viewDidUnload
{

    [self setShowPhotoView:nil];
    [self setAvatarView:nil];
    [self setNameAgeLabel:nil];
    [self setTimeDistanceLabel:nil];
    [self setHeightField:nil];
    [self setAreaField:nil];
    [self setIncomeField:nil];
    [self setWeightField:nil];
    [self setDegreeField:nil];
    [self setCareerField:nil];
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
    [self setEditorBtnsView:nil];
    [self setBasicView:nil];
    [self setSnsBtnView:nil];
    [self setMoreView:nil];
    [self setNameView:nil];
    [self setPosView:nil];
    [self setMobileView:nil];
    [self setCareerView:nil];
    [self setImg1:nil];
    [self setImg2:nil];
    [self setImg3:nil];
    [self setImg4:nil];
    [self setImg5:nil];
    [self setImg6:nil];
    [self setDuiaiIDLabel:nil];
    [self setMoreDetailBtn:nil];
    [self setChooseMateBtn:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dHeight = self.marrayReqView.frame.size.height;
    dHeight2 = self.moreUserInfoView.frame.size.height;
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.changeBaritem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"编辑"target:self action:@selector(settingModeAction)] autorelease];
    self.cancelBarItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"取消"target:self action:@selector(cancelModeAction)] autorelease];
    self.saveBarItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"保存"target:self action:@selector(saveAction)] autorelease];
    self.settingBarItem = [[[CustomBarButtonItem alloc] initBarButtonWithImage:[UIImage imageNamed:@"set_icon"] target:self action:@selector(settingAction)] autorelease];
    self.navigationItem.leftBarButtonItem = self.changeBaritem;
    self.navigationItem.rightBarButtonItem = self.settingBarItem;
    
    self.showPhotoView.delegate = self;
    
//    [self grabUserInfoDetailRequest];
//    [self grabMyWeiyuListReqeustWithPage:1];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.marrayReq) {
        self.marrayReqView.marrayReq = self.marrayReq;
    }
    
    if (self.weiyus == nil ||
        abs([self.lastWeiyuUpdateTime timeIntervalSinceNow]) > 300)
    {
        [self grabMyWeiyuListReqeustWithPage:1];
    }
    
    if (self.userInfo == nil ||
        abs([self.lastUserInfoUpdateTime timeIntervalSinceNow]) > 300)
    {
        [self grabUserInfoDetailRequest];
    }
    
    if (self.existedData == nil ||
        abs([self.lastBasicInfoUpdateTime timeIntervalSinceNow]) > 300)
    {
        [self infoRequestFromRemote];
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

- (void)saveAction
{
    // do some save here
    NSMutableDictionary *dp = [Utils queryParams];
    [SVProgressHUD show];
    [[RKClient sharedClient] post:[@"/uc/userinfo.api" stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){
        NSMutableDictionary *updateArgs = [NSMutableDictionary dictionary];
        if(self.existedData[@"rank_condition"]){
            
            updateArgs[@"rank_condition"] = self.existedData[@"rank_condition"][@"val"];
        }
        
        if(self.existedData[@"company"]){
            updateArgs[@"company"] = self.existedData[@"company"][@"val"];
        }
        
        if(self.existedData[@"nation"]){
            updateArgs[@"nation"] = self.existedData[@"nation"][@"val"];
        }
        
        if(self.existedData[@"belief"]){
            updateArgs[@"belief"] = self.existedData[@"belief"][@"val"];
        }
        
        if(self.existedData[@"best_par"]){
            updateArgs[@"best_par"] = self.existedData[@"best_par"][@"val"];
        }
        
        if(self.existedData[@"bloodtype"]){
            updateArgs[@"bloodtype"] = self.existedData[@"bloodtype"][@"val"];
        }
        
        if(self.existedData[@"house"]){
            updateArgs[@"house"] = self.existedData[@"house"][@"val"];
        }
        
        if(self.existedData[@"children"]){
            updateArgs[@"children"] = self.existedData[@"children"][@"val"];
        }
        
        if(self.existedData[@"parent_together"]){
            updateArgs[@"parent_together"] = self.existedData[@"parent_together"][@"val"];
        }
        
        if(self.existedData[@"paihang"]){
            updateArgs[@"paihang"] = self.existedData[@"paihang"][@"val"];
        }
        
        if(self.existedData[@"most_cost"]){
            updateArgs[@"most_cost"] = self.existedData[@"most_cost"][@"val"];
        }
        
        if(self.existedData[@"speciality"]){
            updateArgs[@"speciality"] = self.existedData[@"speciality"][@"val"];
        }
        
        if(self.existedData[@"auto"]){
            updateArgs[@"auto"] = self.existedData[@"auto"][@"val"];
        }
        
        if(self.existedData[@"company_name"]){
            updateArgs[@"company_name"] = self.existedData[@"company_name"][@"val"];
        }
        
        if(self.existedData[@"university"]){
            updateArgs[@"university"] = self.existedData[@"university"][@"val"];
        }
        
        if(updateArgs[@"home_location"] && updateArgs[@"home_sublocation"]){
            updateArgs[@"home_location"] = self.existedData[@"home_location"][@"val"];
            updateArgs[@"home_sublocation"] = self.existedData[@"home_sublocation"][@"val"];
        }
        
        if(self.existedData[@"child_want"]){
            updateArgs[@"child_want"] = self.existedData[@"child_want"][@"val"];
        }
        
        if(self.existedData[@"marriage"]){
            updateArgs[@"marriage"] = self.existedData[@"marriage"][@"val"];
        }
        
        if(self.existedData[@"smoke_typ"]){
            updateArgs[@"smoke_typ"] = self.existedData[@"smoke_typ"][@"val"];
        }
        
        if(self.existedData[@"drink_type"]){
            updateArgs[@"drink_type"] = self.existedData[@"drink_type"][@"val"];
        }
        
        if(self.existedData[@"live_cust"]){
            updateArgs[@"live_cust"] = self.existedData[@"live_cust"][@"val"];
        }

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
    
}

- (void)settingModeAction
{

//    [self.tableView setEditing:YES animated:YES];


    [self changeToEditingView];
    self.navigationItem.leftBarButtonItem = self.cancelBarItem;
    self.navigationItem.rightBarButtonItem = self.saveBarItem;
    
    self.isEditing = YES;
}

- (void)cancelModeAction
{
//    [self.tableView setEditing:NO animated:YES];

    
    [self changeToNonEditingView];
    
    self.navigationItem.leftBarButtonItem = self.changeBaritem;
    self.navigationItem.rightBarButtonItem = self.settingBarItem;
    
    // reset from remote
    self.heightField.text = [NSString stringWithFormat:@"%@cm", [self.userInfo objectForKey:@"height"]];
    self.areaField.text = [self.userInfo objectForKey:@"area"];
    self.incomeField.text = [self.userInfo objectForKey:@"income"];
    self.degreeField.text = [self.userInfo objectForKey:@"degree"];
    self.careerField.text = [self.userInfo objectForKey:@"industry"];
    self.weightField.text = [NSString stringWithFormat:@"%@kg", [self.userBody objectForKey:@"weight"]];
    
    self.isEditing = NO;
}

- (void)settingAction
{
    
    SettingViewController *settingViewController = [[[SettingViewController alloc]initWithStyle:UITableViewStylePlain] autorelease];
//    settingViewController.photos = self.showPhotoView.photos;
    settingViewController.showPhotoView = self.showPhotoView;
    settingViewController.avatarView = self.avatarView;
    [self.navigationController pushViewController:settingViewController animated:YES];
    
}

- (void)changeToEditingView
{
    // close the two views
    if (self.moreDetailBtn.tag)
    {
        [self moreDetailAction:self.moreDetailBtn];
    }
    
    if (self.chooseMateBtn.tag)
    {
        [self friendConditionAction:self.chooseMateBtn];
    }
    
    // remove some things
    [self.nameView removeFromSuperview];
    [self.moreView removeFromSuperview];
    [self.move1View removeFromSuperview];
    [self.snsBtnView removeFromSuperview];
    [self.posView removeFromSuperview];
    [self.mobileView removeFromSuperview];
    
    self.heightField.enabled = YES;
    self.incomeField.enabled = YES;
    self.degreeField.enabled = YES;
    self.areaField.enabled = YES;
    self.weightField.enabled = YES;
    self.careerField.enabled = YES;
    
    self.img1.hidden = NO;
    self.img2.hidden = NO;
    self.img3.hidden = NO;
    self.img4.hidden = NO;
    self.img5.hidden = NO;
    self.img6.hidden = NO;
    
    // add some
    self.editorBtnsView.frame = CGRectMake(self.nameView.frame.origin.x, self.nameView.frame.origin.y, self.editorBtnsView.frame.size.width, self.editorBtnsView.frame.size.height);
    // move some
    CGRect basicFrame = self.basicView.frame;
    basicFrame.origin.y = self.editorBtnsView.frame.origin.y + self.editorBtnsView.frame.size.height + 20;
    basicFrame.size.height = self.careerView.frame.origin.y + self.careerView.frame.size.height + 1;
    self.basicView.frame = basicFrame;
    // add ...
    [self.tableView.tableHeaderView addSubview:self.editorBtnsView];
    
    CGRect move2Frame = self.move2View.frame;
    move2Frame.origin.y = self.basicView.frame.origin.y + self.basicView.frame.size.height + 20;
    self.move2View.frame = move2Frame;
    
    UIView *headerView = self.tableView.tableHeaderView;
    CGRect frame = headerView.frame;
    frame.size.height = self.move2View.frame.origin.y + self.move2View.frame.size.height + 10;
    headerView.frame = frame;
    self.tableView.tableHeaderView = headerView;
    
    // avatar
    self.avatarView.editing = YES;
    // show images
    self.showPhotoView.editing = YES;
}

- (void)changeToNonEditingView
{
   // add some
    [self.editorBtnsView removeFromSuperview];
    
    [self.tableView.tableHeaderView addSubview:self.nameView];
    [self.tableView.tableHeaderView addSubview:self.moreView];
    [self.tableView.tableHeaderView addSubview:self.move1View];
    [self.tableView.tableHeaderView addSubview:self.snsBtnView];
    [self.basicView addSubview:self.posView];
    [self.basicView addSubview:self.mobileView];
    
    self.heightField.enabled = NO;
    self.incomeField.enabled = NO;
    self.degreeField.enabled = NO;
    self.areaField.enabled = NO;
    self.weightField.enabled = NO;
    self.careerField.enabled = NO;
    
    self.img1.hidden = YES;
    self.img2.hidden = YES;
    self.img3.hidden = YES;
    self.img4.hidden = YES;
    self.img5.hidden = YES;
    self.img6.hidden = YES;
    
    // move some
    CGRect basicFrame = self.basicView.frame;
    basicFrame.origin.y = self.nameView.frame.origin.y + self.nameView.frame.size.height + 20;
    basicFrame.size.height = self.mobileView.frame.origin.y + self.mobileView.frame.size.height + 1;
    self.basicView.frame = basicFrame;
    
    CGRect move2Frame = self.move2View.frame;
    move2Frame.origin.y = self.move1View.frame.origin.y + self.move1View.frame.size.height + 20;
    self.move2View.frame = move2Frame;
    
    UIView *headerView = self.tableView.tableHeaderView;
    CGRect frame = headerView.frame;
    frame.size.height = self.move2View.frame.origin.y + self.move2View.frame.size.height + 10;
    headerView.frame = frame;
    self.tableView.tableHeaderView = headerView;
    
    // avatar
    self.avatarView.editing = NO;
    // showimages
    self.showPhotoView.editing = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.heightField resignFirstResponder];
    [self.incomeField resignFirstResponder];
    [self.degreeField resignFirstResponder];
    [self.areaField resignFirstResponder];
    [self.weightField resignFirstResponder];
    [self.careerField resignFirstResponder];
    

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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
//    if (self.weiyus.count == indexPath.row) {
//        return NO;
//    }
//    
//    return YES;
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *weiyu = self.weiyus[indexPath.row];

        NSMutableDictionary *dParams = [Utils queryParams];
        [dParams setObject:weiyu[@"id"] forKey:@"id"];
        [SVProgressHUD show];
        [[RKClient sharedClient] get:[@"/v/delete.api" stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
            [request setOnDidFailLoadWithError:^(NSError *error){
                NSLog(@"delete weiyu error: %@", [error description]);
                [SVProgressHUD showErrorWithStatus:@"网络链接错误"];
            }];
            [request setOnDidLoadResponse:^(RKResponse *response){
                if (response.isOK && response.isJSON) {
                    NSDictionary *data = [[response bodyAsString] objectFromJSONString];
                    NSInteger code = [data[@"error"] integerValue];
                    if (code == 0) {
                        [self.weiyus removeObject:weiyu];
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [SVProgressHUD dismiss];
                    } else{
                        [SVProgressHUD showErrorWithStatus:data[@"message"]];
                    }
                } else{
                    [SVProgressHUD showErrorWithStatus:@"错误返回"];
                }
            }];
        }];
        
    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isEditing && indexPath.row < self.weiyus.count) {
        
        self.curIndexPath = indexPath;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"删除微语"
                                      otherButtonTitles:nil];
        
        actionSheet.tag = kDelWeiyuTag;
        [actionSheet showInView:self.view.window];
        [actionSheet release];

    }
}


- (void)grabUserInfoDetailRequest
{
    NSMutableDictionary *dParams = [Utils queryParams];
    NSDictionary *info = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"info"];

    [dParams setObject:[info objectForKey:@"uid"] forKey:@"uid"];
    
    [[RKClient sharedClient] get:[@"/user" stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSMutableDictionary *data = [[response bodyAsString] mutableObjectFromJSONString];
//                NSLog(@"user data: %@", data);
                NSInteger code = [[data objectForKey:@"error"] integerValue];
                if (code == 0) {
                    NSDictionary *dataData = [data objectForKey:@"data"];
                    self.photos = [dataData objectForKey:@"photo"];
                    self.userInfo = [dataData objectForKey:@"user_info"];
                    self.userBody = [dataData objectForKey:@"user_body"];
                    self.userLife = [dataData objectForKey:@"user_life"];
                    self.userInterest = [dataData objectForKey:@"user_interest"];
                    self.userWork = [dataData objectForKey:@"user_work"];
                    self.marrayReq = [dataData objectForKey:@"marray_req"];
                    self.searchIndex = [dataData objectForKey:@"searchindex"];
                    self.weiboList = dataData[@"bindlist"];
                    self.lastUserInfoUpdateTime = [NSDate date];
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

- (void)grabMyWeiyuListReqeustWithPage:(NSInteger)page
{
    NSMutableDictionary *dParams = [Utils queryParams];
    //    [dParams setObject:@"photo" forKey:@"a"];
    [dParams setObject:@"myv" forKey:@"a"];
    [dParams setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dParams setObject:@"10" forKey:@"pagesize"];
    
    [[RKClient sharedClient] get:[@"/v" stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSMutableDictionary *data = [[response bodyAsString] mutableObjectFromJSONString];
//                NSLog(@"my weiyu data: %@", data);
                NSInteger code = [data[@"error"] integerValue];
                if (code == 0) {
                    if (![[data objectForKey:@"data"] isKindOfClass:[NSString class]]) {
                        self.loading = NO;
                        self.totalPage = [[[data objectForKey:@"pager"] objectForKey:@"pagecount"] integerValue];
                        self.curPage = [[[data objectForKey:@"pager"] objectForKey:@"thispage"] integerValue];
                        // 此行须在前两行后面
                        self.weiyus = [data objectForKey:@"data"];
                        self.lastWeiyuUpdateTime = [NSDate date];
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
    
    if (sender.tag == 0)
    {
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
    }
    else
    {
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
        NSLog(@"url: %@", request.URL);
        
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

- (IBAction)contractAction
{
    NSLog(@"contract...");
    QQSetViewController *qqSetViewController = [[[QQSetViewController alloc]init]autorelease];
    [self.navigationController pushViewController:qqSetViewController animated:YES];
    
}

- (IBAction)bindingAction
{
    WeiboBindingViewController *weiboBindingViewController = [[[WeiboBindingViewController alloc]init]autorelease];
    [self.navigationController pushViewController:weiboBindingViewController animated:YES];
}

- (IBAction)seniorAction
{
//    SeniorSettingViewController *seniorViewController = [[[SeniorSettingViewController alloc]initWithStyle:UITableViewStylePlain] autorelease];
//    [self.navigationController pushViewController:seniorViewController animated:YES];
    SSViewController *svc = [[[SSViewController alloc] initWithNibName:@"SSViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:svc animated:YES];

}

- (IBAction)friendAction
{
    ChooseMateViewController *cmvc = [[ChooseMateViewController alloc] initWithNibName:@"ChooseMateViewController" bundle:nil];
    cmvc.marrayReq = self.marrayReq;
    [self.navigationController pushViewController:cmvc animated:YES];
    [cmvc release];

}

- (IBAction)uploadAvatarAction
{
    // upload
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"从资源库",@"拍照",nil];
        actionSheet.tag=kActionChooseImageTag;
        [actionSheet showInView:self.view.window];
        [actionSheet release];
        
    } else {
        
        UIImagePickerController *picker = [[[UIImagePickerController alloc] init]autorelease];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        if (!self.isUploadPhoto) {
            picker.allowsEditing = YES;
        }

        [self presentModalViewController:picker animated:YES];
    }
}

#pragma mark - ActionSheet Delegate Methods
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([actionSheet cancelButtonIndex] == buttonIndex) {
        return;
    }
    
    if (actionSheet.tag==kActionChooseImageTag) {
        UIImagePickerController* imagePickerController = [[[UIImagePickerController alloc] init]autorelease];
        
        if (buttonIndex == 0)
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        else  if(buttonIndex==1)
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
        imagePickerController.delegate=self;
        if (!self.isUploadPhoto) {
            imagePickerController.allowsEditing = YES;
        }
        [self presentModalViewController: imagePickerController
                                animated: YES];
    } else if (actionSheet.tag == kDelWeiyuTag){
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            
            NSMutableDictionary *weiyu = self.weiyus[self.curIndexPath.row];
            
            NSMutableDictionary *dParams = [Utils queryParams];
            [dParams setObject:weiyu[@"id"] forKey:@"id"];
            [SVProgressHUD show];
            [[RKClient sharedClient] get:[@"/v/delete.api" stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
                [request setOnDidFailLoadWithError:^(NSError *error){
                    NSLog(@"delete weiyu error: %@", [error description]);
                    [SVProgressHUD showErrorWithStatus:@"网络链接错误"];
                }];
                [request setOnDidLoadResponse:^(RKResponse *response){
                    if (response.isOK && response.isJSON) {
                        NSDictionary *data = [[response bodyAsString] objectFromJSONString];
                        NSInteger code = [data[@"error"] integerValue];
                        if (code == 0) {
                            [self.weiyus removeObject:weiyu];
                            [self.tableView deleteRowsAtIndexPaths:@[self.curIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                            [SVProgressHUD dismiss];
                        } else{
                            [SVProgressHUD showErrorWithStatus:data[@"message"]];
                        }
                    } else{
                        [SVProgressHUD showErrorWithStatus:@"错误返回"];
                    }
                }];
            }];
        }
    }else{
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            NSDictionary *photo = [self.showPhotoView.photos objectAtIndex:actionSheet.tag];
            [Utils deleteImage:photo[@"pid"] block:^{
                [self.showPhotoView removePhotoAt:actionSheet.tag];
            }];
        }
    }
}

#pragma mark –  Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /*添加处理选中图像代码*/
    if (self.isUploadPhoto) {
         NSData *data = UIImageJPEGRepresentation(([Utils thumbnailWithImage:[info objectForKey:UIImagePickerControllerOriginalImage] size:CGSizeMake(640, 960)]), 0.9);
        [Utils uploadImage:data type:@"userphoto" block:^(NSMutableDictionary *res){
            if (res) {
                [self.showPhotoView insertPhoto:res atIndex:1];
                [self.showPhotoView selectRoundAt:1];
            }
        }];
        self.isUploadPhoto = NO;
        
    } else{
        UIImage *thumbImage = [Utils thumbnailWithImage:[info objectForKey:UIImagePickerControllerEditedImage] size:CGSizeMake(181, 181)];
        NSData *data = UIImageJPEGRepresentation(thumbImage, 0.9);
        
        [Utils uploadImage:data type:@"userface" block:^(NSDictionary *res){

            if (res) {
                self.avatarView.imageView.image = [UIImage imageWithData:data];
                NSMutableDictionary *user = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] mutableCopy];
                user[@"avatar"] = data;
                [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }

    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
     self.isUploadPhoto = NO;
}

#pragma mark - show photo delegate
- (void)didTriggerAddPhotoAction:(ShowPhotoView *)view
{
    self.isUploadPhoto = YES;
    [self uploadAvatarAction];
}

- (void)didTriggerDelPhotoAction:(ShowPhotoView *)view at:(NSInteger)index
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"删除照片"
                                  otherButtonTitles:nil];
    actionSheet.tag=index;
    [actionSheet showInView:self.view.window];
    [actionSheet release];
}

#pragma mark - text delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.heightField]) {
        [self.heightPicker show];
    } else if ([textField isEqual:self.weightField]){
        [self.weightPicker show];
    } else if ([textField isEqual:self.areaField]){
        [self.areaPicker show];
    } else if ([textField isEqual:self.incomeField]){
        [self.incomePickerView show];
    } else if ([textField isEqual:self.degreeField]){
        [self.degreePicker show];
    } else if ([textField isEqual:self.careerField]){
        [self.jobPicker show];
    }
    
    return NO;
}

#pragma mark - number delegate
- (void)numberPickerDidChange:(HZNumberPickerView *)picker
{
    if ([picker isEqual:self.heightPicker]) {
        self.heightField.text = [NSString stringWithFormat:@"%dCM", picker.curNum];
        self.heightNum = picker.curNum;
    } else if ([picker isEqual:self.weightPicker]){
        self.weightField.text = [NSString stringWithFormat:@"%dkg", picker.curNum];
        self.weightNum = picker.curNum;
    }
    
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        self.location = picker.locate;
        self.areaField.text = self.location.district;
//        self.conditions[@"province"] = @(self.location.stateId);
//        self.conditions[@"city"] = @(self.location.cityId);
//        self.conditions[@"provincedesc"] = self.location.state;
//        self.conditions[@"citydesc"] = self.location.city;
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

#pragma mark pop picker view
- (NSArray *)popPickerData:(HZPopPickerView *)picker
{
    
    if ([picker isEqual:self.incomePickerView]) {
        
        return @[@{@"label": @"10", @"desc": @"2000元以下"}, @{@"label": @"20", @"desc": @"2000~5000元"},
        @{@"label": @"30", @"desc": @"5000~10000元"}, @{@"label": @"40", @"desc": @"10000~20000元"},
        @{@"label": @"50", @"desc": @"20000元以上"}];
    } else if ([picker isEqual:self.degreePicker]){
        return @[@{@"label": @"1", @"desc": @"中专或以下"}, @{@"label": @"2", @"desc": @"大专"},
        @{@"label": @"3", @"desc": @"本科"}, @{@"label": @"4", @"desc": @"双学士"},
        @{@"label": @"5", @"desc": @"硕士"}, @{@"label": @"6", @"desc": @"博士"}, @{@"label": @"7", @"desc": @"博士后"}];
    } else if ([picker isEqual:self.jobPicker]){
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"jobs" withExtension:@"plist"];
        NSMutableArray *tmp = [NSMutableArray arrayWithContentsOfURL:url];
        [tmp removeObjectAtIndex:0];
        return tmp;
    }
    
    return nil;
    
}

- (NSString *)titleForPopPicker:(HZPopPickerView *)picker
{
    if ([picker isEqual:self.incomePickerView]) {
        return @"工资收入(元)";
    } else if ([picker isEqual:self.degreePicker]){
        return @"学历";
    } else if ([picker isEqual:self.jobPicker]){
        return @"职业";
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

    } else if ([picker isEqual:self.jobPicker]){
        self.jobNum = label;
        self.careerField.text = desc;
    }
    
}

-(void)infoRequestFromRemote
{
    

    [[RKClient sharedClient] get:[@"/uc/userinfo.api" stringByAppendingQueryParameters:[Utils queryParams]] usingBlock:^(RKRequest *request){
        //        NSLog(@"url: %@", request.URL);
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSDictionary *data = [[response bodyAsString] objectFromJSONString];
                //                NSLog(@"digo data %@", data);
                NSInteger code = [data[@"error"] integerValue];
                if (code == 0) {
                    // 此行须在前两行后面
//                    NSLog(@"all user info: %@", data);
                    self.existedData = data[@"data"][@"issetlist"];
                    self.lastBasicInfoUpdateTime = [NSDate date];

                } else{
//                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
            } else{
                //[SVProgressHUD showErrorWithStatus:@"获取失败"];
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
    NSString *urlString;
    if ([t[@"bindtype"] isEqualToString:@"opensinaweibo"]) {
        urlString = [t[@"url"] stringByReplacingOccurrencesOfString:@"weibo.com" withString:@"m.weibo.cn"];
    }
    else if ([t[@"bindtype"] isEqualToString:@"opentweibo"])
    {
        urlString = [t[@"url"] stringByReplacingOccurrencesOfString:@"t.qq.com/" withString:@"ti.3g.qq.com/touch/iphone/#guest_home/u="];
    }
    
    //    NSURL *url = [NSURL URLWithString:urlString];
    //    if (url) {
    //        [[UIApplication sharedApplication] openURL:url];
    //    }
    
    ForgetPasswordViewController *fpvc = [[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:nil];
    fpvc.urlString = urlString;
    [self.navigationController pushViewController:fpvc animated:YES];
    [fpvc release];
    
}

@end