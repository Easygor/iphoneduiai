//
//  NotificationListViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "NotificationListViewController.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"

@interface NotificationListViewController ()

@property (strong, nonatomic) UITableViewCell *moreCell;
@property (nonatomic) NSInteger curPage, totalPage;
@property (nonatomic) BOOL loading;
@property (strong, nonatomic) NSMutableArray *notifications;

@end

@implementation NotificationListViewController

- (void)dealloc
{
    [_moreCell release];
    [_notifications release];
    [super dealloc];
}

- (void)setNotifications:(NSMutableArray *)notifications
{
    if (![_notifications isEqualToArray:notifications]) {
        if (self.curPage > 1) {
            [_notifications addObjectsFromArray:notifications];
        } else{
            _notifications = [[NSMutableArray alloc] initWithArray:notifications];
        }
        
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    // do init things
    if (self.notifications.count <= 0) {
 
        [self requestNotificationListWithPage:1];
    }
    
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.totalPage <= self.curPage) {
        return self.notifications.count;
    } else{
        return self.notifications.count + 1;
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
    
    static NSString *CellIdentifier = @"noticeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];


    }
    
    NSDictionary *n = [self.notifications objectAtIndex:indexPath.row];
    cell.textLabel.text = n[@"title"];
    cell.detailTextLabel.text = n[@"content"];
    
    return cell;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.notifications.count) {
        return [self createMoreCell:tableView cellForRowAtIndexPath:indexPath];
    }else {
        return [self creatNormalCell:tableView cellForRowAtIndexPath:indexPath];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.notifications.count) {
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
        [self requestNotificationListWithPage:self.curPage+1];
        self.loading = YES;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (indexPath.row == self.notifications.count) {
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self loadNextInfoList];
        });
    } else{
        NSMutableDictionary *n = [self.notifications objectAtIndex:indexPath.row];

        if ([n[@"read"] integerValue] == 0) {
             NSMutableDictionary *params = [Utils queryParams];
            [params setObject:n[@"tid"] forKey:@"tid[]"];
//            [SVProgressHUD show];
            [[RKClient sharedClient] post:[@"/common/readnotice.api" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
                NSLog(@"url: %@", request.URL);
                
                request.params = [RKParams paramsWithDictionary:@{@"tid" : n[@"tid"], @"submitupdate": @"true"}];
                
                [request setOnDidLoadResponse:^(RKResponse *response){
                    if (response.isOK && response.isJSON) {
                        NSDictionary *data = [[response bodyAsString] objectFromJSONString];
//                        NSLog(@"read data: %@", data[@"message"]);
                        NSInteger code = [data[@"error"] integerValue];
                        if (code == 0) {
                            n[@"read"] = @"1";
//                            [SVProgressHUD dismiss];
                        } else{
//                            [SVProgressHUD showErrorWithStatus:data[@"message"]];
                        }
                        
                    } else{
//                        [SVProgressHUD showErrorWithStatus:@"获取失败"];
                    }
                }];
                [request setOnDidFailLoadWithError:^(NSError *error){
//                    [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
                    NSLog(@"Error: %@", [error description]);
                }];
            }];
        }
    }
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.row == self.notifications.count) {
        return NO;
    }
    
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *n = [self.notifications objectAtIndex:indexPath.row];
        // Delete the row from the data source
        NSMutableDictionary *params = [Utils queryParams];
//        [params setObject:n[@"tid"] forKey:@"tid[]"];
        [SVProgressHUD show];
        [[RKClient sharedClient] post:[@"/common/delnotice.api" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
            NSLog(@"url: %@", request.URL);
            
            request.params = [RKParams paramsWithDictionary:@{@"tid[]" : n[@"tid"], @"submitupdate": @"true"}];
            
            [request setOnDidLoadResponse:^(RKResponse *response){
                if (response.isOK && response.isJSON) {
                    NSDictionary *data = [[response bodyAsString] objectFromJSONString];
                    NSInteger code = [data[@"error"] integerValue];
                    if (code == 0) {
                        [self.notifications removeObjectAtIndex:indexPath.row];
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
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

#pragma mark - request for notifications
- (void)requestNotificationListWithPage:(NSInteger)page
{
    NSMutableDictionary *params = [Utils queryParams];

    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];    
    [params setObject:@"20" forKey:@"pagesize"];

    
    [SVProgressHUD show];
    [[RKClient sharedClient] get:[@"/uc/notice.api" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
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
                    self.notifications = [data objectForKey:@"data"];
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
