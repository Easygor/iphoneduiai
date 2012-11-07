//
//  DigoUsersViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-22.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "DigoUsersViewController.h"
#import "CustomBarButtonItem.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "UserDetailViewController.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "UserCardTableCell.h"


@interface DigoUsersViewController ()

@property (strong, nonatomic) NSMutableArray *users;
@property (retain, nonatomic) IBOutlet UIView *emptyDataView;
@property (nonatomic) NSInteger curPage, totalPage;
@property (strong, nonatomic) UITableViewCell *moreCell;
@property (nonatomic) BOOL loading;

@end

@implementation DigoUsersViewController

- (void)dealloc
{
    [_emptyDataView release];
    [_users release];
    [_moreCell  release];
    [super dealloc];
}

- (void)setUsers:(NSMutableArray *)users
{
    if (![_users isEqualToArray:users]) {
        _users = [users retain];
        
        [self.emptyDataView removeFromSuperview];
    }
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [self setEmptyDataView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"我的赞的用户"];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (self.users.count <= 0) {
//        [self.tableView addSubview:self.emptyDataView];
//    }
    
    [self digoReqeustWithPage:1];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return self.users.count;
    return self.users.count/3+(self.users.count%3==0?0:1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==(self.users.count/3 + (self.users.count%3 == 0 ? 0 : 1))) {
        return 40.0f;
    }else
    {
        return 110.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == (self.users.count/3 + (self.users.count%3 == 0 ? 0 : 1))) {
        return [self createMoreCell:tableView cellForRowAtIndexPath:indexPath];
    }else {
        return [self creatNormalCell:tableView cellForRowAtIndexPath:indexPath];
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
    NSArray *users = [self.users objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row*3, MIN(3, self.users.count-indexPath.row*3))]];
    static NSString *CellIdenttifier = @"userCardCell";
    UserCardTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdenttifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:1];
        cell.delegate = self;
    }
    cell.users = users;
    return cell;

}

- (void)loadNextInfoList
{
    UILabel *label = (UILabel*)[self.moreCell.contentView viewWithTag:1];
    label.text = @"正在加载..."; // bug no reload table not show it.
    
    if (!self.loading) {
        [self digoReqeustWithPage:self.curPage+1];
        self.loading = YES;
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == (self.users.count/3 + (self.users.count%3 == 0 ? 0 : 1))) {
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self loadNextInfoList];
        });
    }

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    UserDetailViewController *detailViewController = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    detailViewController.user = self.users[indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
}
#pragma mark - request
- (void)digoReqeustWithPage:(NSInteger)page
{
    [SVProgressHUD show];
    NSMutableDictionary *dParams = [Utils queryParams];
    [dParams setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
                [self digoReqeustWithParams:dParams];
    
}

-(void)digoReqeustWithParams:(NSMutableDictionary*)params
{
    [[RKClient sharedClient] get:[@"/usersearch" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
        NSLog(@"url: %@", request.URL);
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSDictionary *data = [[response bodyAsString] objectFromJSONString];
                NSLog(@"digo data %@", data);
                NSInteger code = [data[@"error"] integerValue];
                if (code == 0) {
                    self.loading = NO;
                    self.totalPage = [[[data objectForKey:@"pager"] objectForKey:@"pagecount"] integerValue];
                    self.curPage = [[[data objectForKey:@"pager"] objectForKey:@"thispage"] integerValue];
                    // 此行须在前两行后面
                    if ([data[@"data"] isEqual:[NSNull null]]) {
                        self.users = nil;
                    } else{
                        self.users = [data objectForKey:@"data"];
                    }
                    
                    [SVProgressHUD dismiss];
                } else{
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
                
            } else{
                //[SVProgressHUD showErrorWithStatus:@"获取失败"];
            }
        }];
        [request setOnDidFailLoadWithError:^(NSError *error){
            [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
            NSLog(@"Error: %@", [error description]);
        }];
    }];

}
@end
