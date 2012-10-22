//
//  BindingViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-7.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "BindingViewController.h"
#import "CustomBarButtonItem.h"
#import "SetEmailViewController.h"
@interface BindingViewController ()
@property(nonatomic,retain)NSArray *dataArray;

@end

@implementation BindingViewController
@synthesize dataArray = _dataArray;


-(void)dealloc
{
    [_dataArray release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadView
{
    [super loadView];

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    _dataArray = [[NSArray alloc]initWithObjects:@"来关注我",@"新浪微博",@"腾讯微博",@"QQ空间",@"微信",@"邮箱", nil];
    UIView *footView = [[[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 100)]autorelease];
    UILabel *tipLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 100)]autorelease];
    tipLabel.text = @"绑定微博可以让您获取更多关注，增进互相了解。\n同时也可以丰富您的个人资料，让您在找对象过程中更有竞争力。\n绑定微信可以更便于您和别的用户沟通。\n绑定邮箱之后可用于取回密码。额可以给所有用户发邮件，同时也可以收到别的用户给您的邮件。";
    tipLabel.textColor = RGBCOLOR(204, 204, 204);
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    tipLabel.font = [UIFont systemFontOfSize:11];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.shadowColor = [UIColor whiteColor];
    tipLabel.shadowOffset = CGSizeMake(0, 1.0);
    [footView addSubview:tipLabel];
    self.tableView.tableFooterView = footView;
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 44)]autorelease];
    bgView.backgroundColor  = [UIColor whiteColor];
    [cell.contentView addSubview:bgView];
    
    UIImageView  *lineView= [[[UIImageView alloc]initWithFrame:CGRectMake(0, 43, 300, 1)]autorelease];
    lineView.image =  [UIImage imageNamed:@"line.png"];
    [bgView addSubview:lineView];
    
    UILabel *bigLabel = [[[UILabel alloc]initWithFrame:CGRectMake(23, 13, 100, 15)] autorelease];
     UILabel *smallLabel = [[[UILabel alloc]initWithFrame:CGRectMake(95, 13, 200, 15)] autorelease];
    smallLabel.backgroundColor = [UIColor clearColor];
    bigLabel.backgroundColor=[UIColor clearColor];
    [bgView addSubview:bigLabel];
    [bgView addSubview:smallLabel];
    bigLabel.text = [self.dataArray objectAtIndex:[indexPath row]];
    
    
   UIImageView *arrowImgView = [[[UIImageView alloc]initWithFrame:CGRectMake(280, 15, 14, 14)] autorelease];
    [cell addSubview:arrowImgView];
    arrowImgView.image = [UIImage imageNamed:@"statusdetail_header_arrow.png"];
    if ([indexPath row]==0) {
        UIImageView *img = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"messages_toolbar_emoticonbutton_background_highlighted.png"]]autorelease];
        img.frame = CGRectMake(15, 10, 24, 24);
        [cell.contentView addSubview:img];
        bigLabel.frame = CGRectMake(30, 10, 100, 25);
        bigLabel.font = [UIFont boldSystemFontOfSize:15];
    }else
    {
        bigLabel.font =[UIFont systemFontOfSize:14];
        bigLabel.frame = CGRectMake(10, 0, 100, 44);
        bigLabel.textColor = RGBCOLOR(178, 178, 178);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header= [[[UIView alloc]initWithFrame:CGRectZero]autorelease]
    ;
        header.frame = CGRectMake(0, 0, 320, 15);
    
    return header;
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==5) {
        SetEmailViewController *setEmailViewController = [[[SetEmailViewController alloc]init]autorelease];
        [self.navigationController pushViewController:setEmailViewController animated:YES];
    }
}

@end
