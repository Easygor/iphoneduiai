//
//  FeedListViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "FeedListViewController.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "FeedListCell.h"
@interface FeedListViewController ()

@property (strong, nonatomic) UITableViewCell *moreCell;
@property (nonatomic) NSInteger curPage, totalPage;
@property (nonatomic) BOOL loading;
@property (strong, nonatomic) NSMutableArray *feeds;

@end

@implementation FeedListViewController


- (void)dealloc
{
    [_moreCell release];
    [_feeds release];
    [super dealloc];
}

- (void)setFeeds:(NSMutableArray *)feeds
{
    if (![_feeds isEqualToArray:feeds]) {
        if (self.curPage > 1) {
            [_feeds addObjectsFromArray:feeds];
        } else{
            _feeds = [[NSMutableArray alloc] initWithArray:feeds];
        }
        
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.navigationController.navigationBar setHidden:NO];
    
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"我的动态"];
   rightBarButton = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"编辑"target:self action:@selector(editButton)] autorelease];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"target:self action:@selector(backAction)] autorelease];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    // do init things
    if (self.feeds.count <= 0) {
        
        [self requestFeedListWithPage:1];
    }
    
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.presentedViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.totalPage <= self.curPage) {
        return self.feeds.count;
    } else{
        return self.feeds.count + 1;
    }
    
}
-(void)editButton
{
    if (rightBarButton.title == @"编辑")
    {
        rightBarButton.title = @"确定";
        [rightBarButton setStyle:UIBarButtonItemStyleDone];
        [self setEditing:YES animated:YES];
    }else{
        rightBarButton.title = @"编辑";
        [rightBarButton setStyle:UIBarButtonItemStylePlain];
        [self setEditing:NO animated:YES];
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
    
    static NSString *CellIdentifier = @"feedCell";
    FeedListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[[FeedListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *n = [self.feeds objectAtIndex:indexPath.row];
    cell.contentLabel.text = n[@"addtime_text"];
    cell.titleLabel.text = n[@"content"];
    
    if ([n[@"info"][@"photo"] isEqualToString:@""]) {
        [cell.headImgView loadImage:@"http://img.zhuohun.com/sys/nopic-w.jpg"];
    } else{
        [cell.headImgView loadImage:n[@"uinfo"][@"photo"]];
    }
    return cell;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.feeds.count) {
        return [self createMoreCell:tableView cellForRowAtIndexPath:indexPath];
    }else {
        return [self creatNormalCell:tableView cellForRowAtIndexPath:indexPath];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.feeds.count) {
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
        [self requestFeedListWithPage:self.curPage+1];
        self.loading = YES;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == self.feeds.count) {
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - request for Feeds
- (void)requestFeedListWithPage:(NSInteger)page
{
    NSMutableDictionary *params = [Utils queryParams];
    
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObject:@"20" forKey:@"pagesize"];
    [params setObject:@"index" forKey:@"type"]; // view 查看资料 contact 查看联系方式 message faq 提问 comment 评论
    
    
    [SVProgressHUD show];
    [[RKClient sharedClient] get:[@"/uc/feed.api" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
        NSLog(@"url: %@", request.URL);
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSMutableDictionary *data = [[response bodyAsString] mutableObjectFromJSONString];
                NSInteger code = [data[@"error"] integerValue];
                if (code == 0) {
                    self.loading = NO;
                    self.totalPage = [[[data objectForKey:@"pager"] objectForKey:@"pagecount"] integerValue];
                    self.curPage = [[[data objectForKey:@"pager"] objectForKey:@"thispage"] integerValue];
                    // 此行须在前两行后面

                    self.feeds = data[@"data"];
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

@end
