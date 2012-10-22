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
#import "DropMenuView.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "TasksViewController.h"
#import "TagView.h"

#define CNUM 4

@interface HonorListViewController () <CustomCellDelegate, DropMenuViewDataSource, DropMenuViewDelegate>

@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) UITableViewCell *moreCell;
@property (nonatomic) NSInteger curPage, totalPage;
@property (nonatomic) BOOL loading;

@property (strong, nonatomic) NSString *selectedSex;
@property (strong, nonatomic) NSArray *filterEntries;
@property (strong, nonatomic) UIButton *tilteBtn;
@property (retain, nonatomic) IBOutlet DropMenuView *dropMenuView;
@property (retain, nonatomic) IBOutlet AsyncImageView *avatarImageView;
@property (retain, nonatomic) IBOutlet TagView *bigLevelView;
@property (retain, nonatomic) IBOutlet TagView *levelTagView;
@property (retain, nonatomic) IBOutlet UIButton *btn;
@property (retain, nonatomic) IBOutlet UILabel *levelLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) NSDictionary *vipData;

@end

@implementation HonorListViewController

- (void)dealloc {
    
    [_selectedSex release];
    [_users release];
    [_moreCell release];
    [_filterEntries release];
    [_tilteBtn release];
    [_selectedSex release];
    [_dropMenuView release];
    [_avatarImageView release];
    [_btn release];
    [_levelLabel release];
    [_nameLabel release];
    [_bottomView release];
    [_vipData release];
    [_bigLevelView release];
    [_levelTagView release];
    [super dealloc];
}

- (void)setVipData:(NSDictionary *)vipData
{
    if (![_vipData isEqualToDictionary:vipData]) {
        _vipData = [vipData retain];
        CGSize size = [vipData[@"txt"] sizeWithFont:self.levelLabel.font
                                  constrainedToSize:CGSizeMake(self.levelLabel.frame.size.width, 60)
                                      lineBreakMode:UILineBreakModeCharacterWrap];
        CGRect lFrame = self.levelLabel.frame;
        lFrame.size.height = size.height;
        self.levelLabel.frame = lFrame;
        NSLog(@"vip data: %@", vipData);
        self.levelTagView.content = @"Lv888888";
        self.bigLevelView.content = @"Lv 888888";
        self.levelLabel.text = vipData[@"txt"];
        
        [self.btn setTitle:vipData[@"bt"] forState:UIControlStateNormal];
        [self.btn setTitle:vipData[@"bt"] forState:UIControlStateHighlighted];
    }
}

- (NSArray *)filterEntries
{
    if (_filterEntries == nil) {
        _filterEntries = [[NSArray alloc] initWithArray:@[
                          @{@"tag":@"w", @"name":@"同城女生"},
                          @{@"tag":@"m", @"name":@"同城男生"}]];
    }
    
    return _filterEntries;
}

- (void)setSelectedSex:(NSString *)selectedSex
{
    if (![_selectedSex isEqualToString:selectedSex]) {
        _selectedSex = [selectedSex retain];

        
        NSString *name = nil;
        for (NSDictionary *d in self.filterEntries) {
            if ([[d objectForKey:@"tag"] isEqualToString:selectedSex]) {
                name = [d objectForKey:@"name"];
                break;
            }
            
        }
        
        [self.tilteBtn setTitle:name forState:UIControlStateNormal];
        [self.tilteBtn setTitle:name forState:UIControlStateHighlighted];
        
        [self requestHonorListWithPage:1];
    }
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 44);
    [btn setImage:[UIImage imageNamed:@"top_arrow"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"top_arrow"] forState:UIControlStateHighlighted];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -160);
    [btn addTarget:self action:@selector(selectAeraAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = btn;
    self.tilteBtn = btn;
    
    self.bottomView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0, 1.0);
    self.bottomView.layer.shadowOpacity = 0.45;
    self.bottomView.layer.shadowRadius = 1.0;
    self.bottomView.layer.shouldRasterize = YES;
    
    NSDictionary *info = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"info"];
    [self.avatarImageView loadImage:info[@"photo"]];
    self.nameLabel.text = info[@"niname"];
    [self.nameLabel sizeToFit];
    
    CGRect levelFrame = self.levelTagView.frame;
    levelFrame.origin.x = self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width + 2;
    self.levelTagView.frame = levelFrame;
    
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 5.0f;
    
}

- (void)selectAeraAction:(UIButton*)btn
{
    CGRect posFrame = [self.navigationItem.titleView.superview convertRect:self.navigationItem.titleView.frame toView:self.view.window];
    [self.dropMenuView showMeAtView:self.view
                            atPoint:CGPointMake(posFrame.origin.x, posFrame.origin.y+posFrame.size.height)
                           animated:YES];
    
}

- (void)jumpAction
{

    TasksViewController *tvc = [[TasksViewController alloc] initWithNibName:@"TasksViewController" bundle:nil];
    [self.navigationController pushViewController:tvc animated:YES];
    [tvc release];
}

- (void)viewDidUnload
{
    [self setDropMenuView:nil];
    [self setAvatarImageView:nil];
    [self setBtn:nil];
    [self setLevelLabel:nil];
    [self setNameLabel:nil];
    [self setBottomView:nil];
    [self setBigLevelView:nil];
    [self setLevelTagView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
        
        // do init things
    if (self.users.count <= 0) {
        NSDictionary *info = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"info"];
        if ([info[@"sex"] isEqualToString:@"m"]) {
            self.selectedSex = @"w";
        } else{
            self.selectedSex = @"m";
        }
        [self requestHonorListWithPage:1];
    }

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
    static NSString *CellIdentifier = @"honorCell";
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
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObject:self.selectedSex forKey:@"sex"];
    // area info
    [params setObject:info[@"province"] forKey:@"province"];
    [params setObject:info[@"city"] forKey:@"city"];
    
    [params setObject:@"viplevel" forKey:@"order"];
    [params setObject:@"-1" forKey:@"ordasc"];
    // location distance
    
    [params setObject:@"40" forKey:@"pagesize"];
    
    // have pics
//    [params setObject:@"1" forKey:@"photo"];
    [params setObject:@"photo" forKey:@"fields"];
    
    [SVProgressHUD show];
    [[RKClient sharedClient] get:[@"/usersearch" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
        NSLog(@"url: %@", request.URL);
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSDictionary *data = [[response bodyAsString] objectFromJSONString];
                NSInteger code = [data[@"error"] integerValue];
                if (code == 0) {
                    //                NSLog(@"data %@", data);
                    self.loading = NO;
                    self.totalPage = [[[data objectForKey:@"pager"] objectForKey:@"pagecount"] integerValue];
                    self.curPage = [[[data objectForKey:@"pager"] objectForKey:@"thispage"] integerValue];
                    // 此行须在前两行后面
                    self.users = [data objectForKey:@"data"];
                    self.vipData = data[@"vipdata"];
                    //                NSLog(@"data vip: %@", self.vipData);
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
    NSInteger index = indexPath.row*CNUM + [status integerValue];
    NSDictionary *user = [self.users objectAtIndex:index];
    
    UserDetailViewController *udvc = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    udvc.user = user;
    [self.navigationController pushViewController:udvc animated:YES];
    [udvc release];
}

#pragma mark - drop menu
- (NSArray *)dropMenuViewData:(DropMenuView *)dropView
{
    return self.filterEntries;
    
}

- (void)didSelectedMenuCell:(DropMenuView *)dropView withTag:(NSString *)tag name:(NSString *)name
{
    
    if (self.tableView.isDecelerating ||
        self.tableView.isDragging ||
        self.tableView.isEditing) {
        return;
    }
    
    self.selectedSex = tag;
    
}

- (IBAction)goToLevelAction
{
    [self jumpAction];
}
@end
