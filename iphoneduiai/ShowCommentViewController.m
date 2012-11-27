//
//  ShowCommentViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-26.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ShowCommentViewController.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "CustomBarButtonItem.h"
#import "WeiyuWordCell.h"
#import "ShowCommentCell.h"
#import "CustomCellDelegate.h"
#import "UserDetailViewController.h"
#import "CommentViewController.h"

@interface ShowCommentViewController () <CustomCellDelegate>
@property (nonatomic, retain) NSMutableArray *contents;
@property (strong, nonatomic) UITableViewCell *moreCell;
@property (nonatomic) NSInteger curPage, totalPage;
@property (nonatomic) BOOL loading;
@end

@implementation ShowCommentViewController
@synthesize contents=_contents;

-(void)dealloc
{
    [_contents release];
    [_moreCell release];
    [_weiYuDic release];
    [super dealloc];
}

- (NSMutableArray *)contents
{
    if (_contents == nil) {
        _contents = [[NSMutableArray alloc] initWithObjects:self.weiYuDic, nil];
    }
    
    return  _contents;
}

- (void)setContents:(NSMutableArray *)contents
{
//    if (![_contents isEqualToArray:contents]) {

        if (self.curPage <= 1 && (_contents == nil || _contents.count > 1)) {
            _contents = [[NSMutableArray alloc] initWithObjects:self.weiYuDic, nil];
        }
        
        [_contents addObjectsFromArray:contents];
        [self.tableView reloadData];
//    }
}

- (id)initWithStyle:(UITableViewStyle)style 
{
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"评论微语"];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"评论"
                                                                                                target:self
                                                                                                action:@selector(addAction)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];

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

#pragma mark - actions
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addAction
{
    CommentViewController *commentViewController = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
    commentViewController.idStr = self.weiYuDic[@"id"];
    //
    [self.navigationController pushViewController:commentViewController animated:YES];
    [commentViewController release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.contents.count <= 1) {
        [self getCommentListWithPage:1];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.totalPage <= self.curPage && self.contents.count > 1) {
        return self.contents.count;
        
    } else{
        return self.contents.count + 1;
    }
    
}

-(UITableViewCell *)createNoDataCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"noDataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"没有评论";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.indentationLevel = 1;
        cell.indentationWidth = 20;
    }
    
    return cell;
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
    static NSString *CellIdentifier = @"commentCell";
    static NSString *CellIdentifierForWeiyu = @"weiyuWordCell";
     
    if ([indexPath row] == 0) {
        WeiyuWordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierForWeiyu];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
            cell = [nib objectAtIndex:2];
            UILabel *bottomLine = [[[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, 320, 1)] autorelease];
            bottomLine.backgroundColor = RGBCOLOR(201, 201, 201);
            bottomLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            [cell addSubview:bottomLine];
            cell.delegate = self;
        }
        cell.weiyu = self.contents[[indexPath row]];
        return cell;

    }else {
        ShowCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[ShowCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.delegate = self;
        }
        NSDictionary *comment = self.contents[[indexPath row]];
        cell.content = comment[@"content"];
        cell.titleLabel.text = comment[@"uinfo"][@"niname"];
        cell.timeLabel.text =comment[@"addtime_text"];
        if ([comment[@"unifo"][@"photo"] isEqualToString:@""]) {
            [cell.headImgView loadImage:DEFAULTAVATAR];
        } else{
            [cell.headImgView loadImage:comment[@"uinfo"][@"photo"]];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.contents.count == indexPath.row) {
        return 40.0f;
    } else{
        id cell = [self creatNormalCell:tableView cellForRowAtIndexPath:indexPath];
        
        return [cell requiredHeight];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.contents.count == 1 && indexPath.row == 1) {
//        NSLog(@"in herer");
        return [self createNoDataCell:tableView cellForRowAtIndexPath:indexPath];
    }
    
    if (self.contents.count > 1 && indexPath.row == self.contents.count) {
        return [self createMoreCell:tableView cellForRowAtIndexPath:indexPath];
    }else {
        return [self creatNormalCell:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)loadNextInfoList
{
    UILabel *label = (UILabel*)[self.moreCell.contentView viewWithTag:1];
    label.text = @"正在加载..."; // bug no reload table not show it.
    
    if (!self.loading) {
        [self getCommentListWithPage:self.curPage+1];
        self.loading = YES;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.contents.count > 1 && indexPath.row == self.contents.count) {
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self loadNextInfoList];
        });
    }
}


- (void)getCommentListWithPage:(NSInteger)page
{
    NSMutableDictionary *dParams = [Utils queryParams];
    dParams[@"id"] = self.weiYuDic[@"id"];
    dParams[@"page"] = @(page);
    dParams[@"page_size"] = @"10";
    
    [SVProgressHUD show];
    [[RKClient sharedClient] get:[@"/v/getreply.api" stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSMutableDictionary *data = [[response bodyAsString] mutableObjectFromJSONString];
                NSInteger code = [[data objectForKey:@"error"] integerValue];
                if (code == 0) {
                    if (data[@"data"] != [NSNull null])
                    {
                        self.loading = NO;
                        self.totalPage = [[[data objectForKey:@"pager"] objectForKey:@"pagecount"] integerValue];
                        self.curPage = [[[data objectForKey:@"pager"] objectForKey:@"thispage"] integerValue];
                        self.contents = data[@"data"];
                    }
                    [SVProgressHUD dismiss];
                } else{
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
            }
        }];
        
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"error: %@", [error description]);
            [SVProgressHUD dismiss];
        }];
        
    }];
    
}

#pragma mark - cell delegate
- (void)didChangeStatus:(UITableViewCell *)cell toStatus:(NSString *)status
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    NSMutableDictionary *item = self.contents[indexPath.row];

    if ([status isEqualToString:@"tap_avatar"]){
        UserDetailViewController *udvc = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
        udvc.user = @{@"_id": item[@"uid"], @"niname": item[@"uinfo"][@"niname"], @"photo": item[@"uinfo"][@"photo"]};
        [self.navigationController pushViewController:udvc animated:YES];
        [udvc release];
    }    
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
