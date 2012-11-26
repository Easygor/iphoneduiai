//
//  BlockUsersViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-22.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "BlockUsersViewController.h"
#import "CustomBarButtonItem.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "UserDetailViewController.h"
#import "BlockUserCell.h"

@interface BlockUsersViewController () <CustomCellDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableArray *users;
@property (retain, nonatomic) IBOutlet UIView *emptyDataView;
@property (nonatomic) NSInteger curPage, totalPage;
@property (strong, nonatomic) UITableViewCell *moreCell;
@property (nonatomic) BOOL loading, editing;
@property (strong, nonatomic) NSDictionary *curUser;
@property (strong, nonatomic) UIBarButtonItem *cancelItem, *editItem;

@end

@implementation BlockUsersViewController

- (void)dealloc
{
    [_emptyDataView release];
    [_users release];
    [_moreCell  release];
    [_curUser release];
    [_cancelItem release];
    [_editItem release];
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
        
        if (_users.count > 0) {
            [self.emptyDataView removeFromSuperview];
            [self.tableView reloadData];
        } else{
            [self.tableView addSubview:self.emptyDataView];
        }
        
    }
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
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"我的黑名单"];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    self.editItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"编辑"
                                                                       target:self
                                                                       action:@selector(editAction)] autorelease];
    self.cancelItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"取消"
                                                                       target:self
                                                                       action:@selector(editAction)] autorelease];

    self.navigationItem.rightBarButtonItem = self.editItem;

    [self blockReqeustWithPage:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.users.count <= 0) {
        [self.tableView addSubview:self.emptyDataView];
    }
}

- (void)editAction
{
    if (self.editing) {
        self.editing = NO;
        self.navigationItem.rightBarButtonItem = self.editItem;
    } else{
        self.editing = YES;
        self.navigationItem.rightBarButtonItem = self.cancelItem;
    }
    [self.tableView reloadData];
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.totalPage <= self.curPage) {
        return self.users.count/3 + (self.users.count%3 == 0 ? 0 : 1);
    } else{
        
        return self.users.count/3 + (self.users.count%3 == 0 ? 0 : 1)+1;
    }
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
    static NSString *CellIdenttifier = @"blockUserCell";
    BlockUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdenttifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:8];
        cell.delegate = self;
    }
    cell.users = users;
    cell.isEditing = self.editing;
    return cell;
    
}

- (void)loadNextInfoList
{
    UILabel *label = (UILabel*)[self.moreCell.contentView viewWithTag:1];
    label.text = @"正在加载..."; // bug no reload table not show it.
    
    if (!self.loading) {
        [self blockReqeustWithPage:self.curPage+1];
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
#pragma mark - request
- (void)blockReqeustWithPage:(NSInteger)page
{
    [SVProgressHUD show];
    NSMutableDictionary *dParams = [Utils queryParams];
    [dParams setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [self blockReqeustWithParams:dParams];
    
}

-(void)blockReqeustWithParams:(NSMutableDictionary*)params
{

    [[RKClient sharedClient] get:[@"/uc/black.api" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
        NSLog(@"url: %@", request.URL);
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSDictionary *data = [[response bodyAsString] objectFromJSONString];
//                NSLog(@"block data %@", data);
                NSInteger code = [data[@"error"] integerValue];
                if (code == 0 && [data[@"data"] isKindOfClass:[NSArray class]]) {
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
                [SVProgressHUD showErrorWithStatus:@"获取失败"];
            }
        }];
        [request setOnDidFailLoadWithError:^(NSError *error){
            [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
            NSLog(@"Error: %@", [error description]);
        }];
    }];
    
}

#pragma mark custom cell delegate
- (void)didChangeStatus:(UITableViewCell *)cell toStatus:(NSString *)status
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger index = indexPath.row*3 + [status integerValue];
    NSDictionary *user = [self.users objectAtIndex:index];
    self.curUser = user;
    if (self.editing) {
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:@"移出黑名单"
                                                       otherButtonTitles:nil];
        [actionsheet showInView:self.view.window];
    }
//    else{
//        UserDetailViewController *udvc = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
//        udvc.user = user;
//        [self.navigationController pushViewController:udvc animated:YES];
//        [udvc release];
//    }

}

# pragma mark - acitonsheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        NSMutableDictionary *dParams = [Utils queryParams];
        [dParams setObject:self.curUser[@"uid"] forKey:@"uid"];
        
        [SVProgressHUD show];
        // cancel the block user
        [[RKClient sharedClient] get:[@"/common/delblack.api" stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
            NSLog(@"url: %@", request.URL);
            [request setOnDidLoadResponse:^(RKResponse *response){
                if (response.isOK && response.isJSON) {
                    NSDictionary *data = [[response bodyAsString] objectFromJSONString];
//                    NSLog(@"block data %@", data);
                    NSInteger code = [data[@"error"] integerValue];
                    if (code == 0) {
                        [self blockReqeustWithPage:1];
                        
                        [SVProgressHUD dismiss];
                    } else{
                        [SVProgressHUD showErrorWithStatus:data[@"message"]];
                    }
                    
                } else{
                    [SVProgressHUD showErrorWithStatus:@"服务器错误"];
                }
            }];
            [request setOnDidFailLoadWithError:^(NSError *error){
                [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
                NSLog(@"Error: %@", [error description]);
            }];
        }];
    }
}
@end
