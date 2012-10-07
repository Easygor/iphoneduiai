//
//  HonorListViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "HonorListViewController.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "CustomBarButtonItem.h"
#import "UserDetailViewController.h"
#import "HonorTableCell.h"

#define CNUM 4

@interface HonorListViewController () <CustomCellDelegate>

@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) UITableViewCell *moreCell;
@property (nonatomic) NSInteger curPage, totalPage;
@property (nonatomic) BOOL loading;

@end

@implementation HonorListViewController

- (void)dealloc {



    [_users release];
    [_moreCell release];
    
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
        
        [self.tableView reloadData]; // reload which one?
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
      self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"我要升级"
                                                                                                target:self
                                                                                                action:@selector(jumpAction)] autorelease];
}

- (void)jumpAction
{
    NSLog(@"我要升级...");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
        
        // do init things
    [self requestHonorListWithPage:1];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
        
    if (self.totalPage <= self.curPage) {
        return self.users.count/CNUM + (self.users.count%CNUM == 0 ? 0 : 1);
    } else{
        
        return self.users.count/CNUM + (self.users.count%CNUM == 0 ? 0 : 1)+1;
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
    

    NSArray *users = [self.users objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row*CNUM, MIN(CNUM, self.users.count-indexPath.row*CNUM))]];
    static NSString *CellIdentifier = @"userCardCell";
    HonorTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:4];
        cell.delegate = self;
    }
    
    cell.users = users;

    return cell;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == (self.users.count/CNUM + (self.users.count%CNUM == 0 ? 0 : 1))) {
        return [self createMoreCell:tableView cellForRowAtIndexPath:indexPath];
    }else {
        return [self creatNormalCell:tableView cellForRowAtIndexPath:indexPath];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
            
    if (indexPath.row == (self.users.count/CNUM + (self.users.count%CNUM == 0 ? 0 : 1))) {
        return 40.0;
    }else {
        return tableView.rowHeight;
        
    }
    
}

- (void)loadNextInfoList
{
    UILabel *label = (UILabel*)[self.moreCell.contentView viewWithTag:1];
    label.text = @"正在加载..."; // bug no reload table not show it.
    
    if (!self.loading) {
        [self requestHonorListWithPage:self.curPage+1];
        self.loading = YES;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == (self.users.count/CNUM + (self.users.count%CNUM == 0 ? 0 : 1))) {
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self loadNextInfoList];
        });
    }

}

#pragma mark - request honor list
- (void)requestHonorListWithPage:(NSInteger)page
{
    NSMutableDictionary *params = [Utils queryParams];
    
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
    
    [params setObject:@"viplevel" forKey:@"order"];
    [params setObject:@"-1" forKey:@"ordasc"];
    // location distance
    
    [params setObject:@"18" forKey:@"minage"];
    [params setObject:@"30" forKey:@"maxage"];
    [params setObject:@"32" forKey:@"pagesize"];
    
    // have pics
    [params setObject:@"1" forKey:@"photo"];
    [params setObject:@"photo" forKey:@"fields"];
    
    
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

#pragma mark custom cell delegate
- (void)didChangeStatus:(UITableViewCell *)cell toStatus:(NSString *)status
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger index = indexPath.row*CNUM + [status integerValue];
    NSDictionary *user = [self.users objectAtIndex:index];
    
    UserDetailViewController *udvc = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    udvc.user = user;
    [self.navigationController pushViewController:udvc animated:YES];
    [udvc release];
}


@end
