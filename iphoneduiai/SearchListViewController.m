//
//  SearchListViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "SearchListViewController.h"
#import "LoginViewController.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "HZSementedControl.h"
#import "CustomBarButtonItem.h"
#import "UserCardTableCell.h"
#import "UserInfoTableCell.h"
#import "Utils.h"
#import "ConditionViewController.h"
#import "UserDetailViewController.h"
#import "LocationController.h"

@interface SearchListViewController () <HZSementdControlDelegate, LocationControllerDelegate, CustomCellDelegate>
{
    BOOL isWater;
}

@property (nonatomic) BOOL loading;
@property (retain, nonatomic) IBOutlet HZSementedControl *sementdView;
@property (retain, nonatomic) IBOutlet UITableView *waterTableView;
@property (retain, nonatomic) IBOutlet UITableView *infoTableView;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) UITableViewCell *moreCell;
@property (nonatomic) NSInteger curPage, totalPage;
@property (strong, nonatomic) NSString *orderField;

@end

@implementation SearchListViewController

- (void)dealloc {
    [_sementdView release];
    [_waterTableView release];
    [_infoTableView release];
    [_users release];
    [_moreCell release];
    [_orderField release];
    [super dealloc];
}

- (void)setUsers:(NSMutableArray *)users
{
    if (![_users isEqualToArray:users]) {
        if (self.curPage > 1) {
            [_users addObjectsFromArray:users];

        } else{
            _users = [[NSMutableArray alloc] initWithArray:users];
        }
        
        [self.infoTableView reloadData]; // reload which one?
        [self.waterTableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.waterTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.infoTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"换"
                                                                                              target:self
                                                                                              action:@selector(exchangeAction)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"搜索条件"
                                                                                              target:self
                                                                                              action:@selector(jumpAction)] autorelease];
    
    [LocationController sharedInstance].delegate = self;
  
}

- (void)jumpAction
{
    ConditionViewController *cvc = [[ConditionViewController alloc] initWithNibName:@"ConditionViewController" bundle:nil];
    [self.navigationController pushViewController:cvc animated:YES];
    [cvc release];
}

- (void)exchangeAction
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.3];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    NSInteger info = [self.view.subviews indexOfObject:self.infoTableView];
    NSInteger water = [self.view.subviews indexOfObject:self.waterTableView];
    if (isWater) {
        
        [self.view exchangeSubviewAtIndex:water withSubviewAtIndex:info];
        isWater = NO;
    } else {
        [self.view exchangeSubviewAtIndex:info withSubviewAtIndex:water];
        
    }
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用某个方法
    //[UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    
    [UIView commitAnimations];
}

- (void)viewDidUnload
{
    [self setSementdView:nil];
    [self setWaterTableView:nil];
    [self setInfoTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    if ([self checkLogin]) {

        // do init things
        [self performSelector:@selector(doInitWork)
                   withObject:nil
                   afterDelay:0.0001];
    }
}

- (void)doInitWork
{
    // do something here
    if (self.users.count <= 0 &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined) {
        [self.sementdView selectSegmentAtIndex:0];
    }

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([tableView isEqual:self.infoTableView]) {
        if (self.totalPage <= self.curPage) {

            return self.users.count;
        } else{

            return self.users.count+1;

        }
        
    } else if ([tableView isEqual:self.waterTableView]){

        if (self.totalPage <= self.curPage) {
            return self.users.count/3 + (self.users.count%3 == 0 ? 0 : 1);
        } else{

            return self.users.count/3 + (self.users.count%3 == 0 ? 0 : 1)+1;
        }
    }
    
    return 0;
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
  
    if ([tableView isEqual:self.infoTableView]) {
        NSDictionary *user = [self.users objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"userInfoCell";
         UserInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }

        // do on here
        cell.nameLabel.text = [user objectForKey:@"niname"];
        [cell.avatarImageView loadImage:[user objectForKey:@"photo"]];
        cell.ageHightLabel.text = [NSString stringWithFormat:@"%@岁·%@cm", [user objectForKey:@"age"], [user objectForKey:@"height"]];
        NSDate *actime = [NSDate dateWithTimeIntervalSince1970:[[user objectForKey:@"acctime"] integerValue]];
        NSInteger d = [[user objectForKey:@"distance"] integerValue];
        cell.timeDistanceLabel.text = [NSString stringWithFormat:@"%@·%@", [Utils descriptionForDistance:d], [Utils descriptionForTime:actime]];
        cell.pictureNum.text = [[user objectForKey:@"photocount"] description];
        cell.graphLabel.text = [[user objectForKey:@"last_weiyu"] description];
        
        return cell;
        
    } else {
        NSArray *users = [self.users objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row*3, MIN(3, self.users.count-indexPath.row*3))]];
        static NSString *CellIdentifier = @"userCardCell";
        UserCardTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
            cell = [nib objectAtIndex:1];
            cell.delegate = self;
        }
        
        cell.users = users;
        
        // do on here
        return cell;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.infoTableView]) {
        
        if (indexPath.row == self.users.count) {
            return [self createMoreCell:tableView cellForRowAtIndexPath:indexPath];
        }else {
            return [self creatNormalCell:tableView cellForRowAtIndexPath:indexPath];
        }
    } else{
        
        if (indexPath.row == (self.users.count/3 + (self.users.count%3 == 0 ? 0 : 1))) {
            return [self createMoreCell:tableView cellForRowAtIndexPath:indexPath];
        }else {
            return [self creatNormalCell:tableView cellForRowAtIndexPath:indexPath];
        }
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:self.infoTableView]) {
        
        if (indexPath.row == self.users.count) {

            return 40.0f;
        }else {
            return tableView.rowHeight;
           
        }
    } else{
        
        if (indexPath.row == (self.users.count/3 + (self.users.count%3 == 0 ? 0 : 1))) {
            return 40.0;           
        }else {
            return tableView.rowHeight;

        }
    }
    
}

- (void)loadNextInfoList
{
    UILabel *label = (UILabel*)[self.moreCell.contentView viewWithTag:1];
    label.text = @"正在加载..."; // bug no reload table not show it.
    
    if (!self.loading) {
    [self searchReqeustWithPage:self.curPage+1];
        self.loading = YES;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:self.infoTableView]) {
        
        if (indexPath.row == self.users.count) {
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self loadNextInfoList];
            });
        }
    } else{
        
        if (indexPath.row == (self.users.count/3 + (self.users.count%3 == 0 ? 0 : 1))) {
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self loadNextInfoList];
            });
         }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.infoTableView]) {
        if (indexPath.row < self.users.count) {
            UserDetailViewController *udvc = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
            udvc.user = [self.users objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:udvc animated:YES];
            [udvc release];
        }
    } else{
        
        
    }

}

#pragma mark - Other
- (BOOL)checkLogin
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user"]) {

        return YES;
    }
    
    LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self presentModalViewController:lvc animated:NO];
    [lvc release];
    
    return NO;
}



#pragma mark - semented delegate
- (void)didChange:(HZSementedControl *)segment atIndex:(NSInteger)index forValue:(NSString *)text
{
    NSLog(@"text: %@", text);

    switch (index) {
        case 0:
            // go next
            self.orderField = nil;
            break;
        case 1:
            self.orderField = @"distance";
            break;
        case 2:
            self.orderField = @"viewcount";
            break;
        case 3:
            self.orderField = @"regtime";
            break;
        default:
            self.orderField = nil;
            break;
    }
    
    [self reloadList];
}

- (void)reloadList
{
    [self searchReqeustWithPage:1];
}

#pragma mark - request 
- (void)searchReqeustWithPage:(NSInteger)page
{
    [SVProgressHUD show];
    NSMutableDictionary *dParams = [Utils queryParams];
    [dParams setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    if ([[LocationController sharedInstance] allow] && [self.orderField isEqualToString:@"distance"]) {
        [[[LocationController sharedInstance] locationManager] startUpdatingLocation];
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            CLLocationCoordinate2D location2D = [LocationController sharedInstance].location.coordinate;
            [[[LocationController sharedInstance] locationManager] stopUpdatingLocation];
            
            [dParams setObject:[NSNumber numberWithInteger:ceil(location2D.latitude*1000000)] forKey:@"wei"];
            [dParams setObject:[NSNumber numberWithInteger:ceil(location2D.longitude*1000000)] forKey:@"jin"];
            [dParams setObject:@"0.5" forKey:@"maxdis"];
            [self searchReqeustWithParams:dParams];
        });
        
    } else {
        [self searchReqeustWithParams:dParams];
    }
}

- (void)searchReqeustWithParams:(NSMutableDictionary*)params
{


    NSDictionary *info = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"info"];
    
    // select sex
    if ([info[@"sex"] isEqualToString:@"m"]) {
         [params setObject:@"w" forKey:@"sex"];
    } else{
         [params setObject:@"m" forKey:@"sex"];
    }
    
    // area info
    [params setObject:info[@"province"] forKey:@"province"];
    [params setObject:info[@"city"] forKey:@"city"];

    if (self.orderField && ![self.orderField isEqualToString:@"distance"]) {
        [params setObject:self.orderField forKey:@"order"];
        [params setObject:@"-1" forKey:@"ordasc"];
    }
    
    // location distance
    
    [params setObject:@"18" forKey:@"minage"];
    [params setObject:@"30" forKey:@"maxage"];
    [params setObject:@"21" forKey:@"pagesize"];
    
    // have pics
    [params setObject:@"1" forKey:@"photo"];
    [params setObject:@"niname,age,height,photo,photocount,sex,acctime,distance,weibolist,position,last_weiyu" forKey:@"fields"];
    

    [[RKClient sharedClient] get:[@"/usersearch" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
        NSLog(@"url: %@", request.URL);
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSDictionary *data = [[response bodyAsString] objectFromJSONString];
//                NSLog(@"data %@", data);
                self.loading = NO;
                self.totalPage = [[[data objectForKey:@"pager"] objectForKey:@"pagecount"] integerValue];
                self.curPage = [[[data objectForKey:@"pager"] objectForKey:@"thispage"] integerValue];
                  // 此行须在前两行后面
                self.users = [data objectForKey:@"data"];
                [SVProgressHUD dismiss];

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

- (void)doOnLocationStrategy
{
    if ([self checkLogin]) {
        if ([self.orderField isEqualToString:@"distance"]) {
            [self reloadList];
        } else{
            if (self.users.count <= 0) {
                [self.sementdView selectSegmentAtIndex:0];
            }
        }
    }

}

#pragma mark - location controller delegate
-(void)didOnChangeStatusToAllow:(CLLocationManager *)manager
{
    [self doOnLocationStrategy];
}

-(void)didOnChangeStatusToUneabled:(CLLocationManager *)manager
{
    
    [self doOnLocationStrategy];
    
}

#pragma mark custom cell delegate
- (void)didChangeStatus:(UITableViewCell *)cell toStatus:(NSString *)status
{
    NSIndexPath *indexPath = [self.waterTableView indexPathForCell:cell];
    NSInteger index = indexPath.row*3 + [status integerValue];
    NSDictionary *user = [self.users objectAtIndex:index];
    
    UserDetailViewController *udvc = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    udvc.user = user;
    [self.navigationController pushViewController:udvc animated:YES];
    [udvc release];
}

@end
