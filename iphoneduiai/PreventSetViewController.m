//
//  RemindViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "PreventSetViewController.h"

@interface PreventSetViewController ()
@property (strong, nonatomic) HZTimePickerView *datePicker;
@end

@implementation PreventSetViewController
@synthesize datePicker = _datePicker;

- (void)dealloc
{
    [_datePicker release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = 0;
    if (section == 0) {
        num=1;
    }else if(section ==1)
    {
        num =2;
    }

    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[tableView dequeueReusableCellWithIdentifier:CellIdentifier] autorelease];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    bgView.backgroundColor  = [UIColor whiteColor];
    [cell.contentView addSubview:bgView];
    
    UIImageView  *lineView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 43, 300, 1)];
    lineView.image =  [UIImage imageNamed:@"line.png"];
    [bgView addSubview:lineView];
    
    UILabel *bigLabel = [[UILabel alloc]initWithFrame:CGRectMake(23, 13, 200, 15)];
    bigLabel.backgroundColor=[UIColor clearColor];
    [bgView addSubview:bigLabel];
    if ([indexPath section]==0) {
        if ([indexPath row]==0) {
            bigLabel.text = @"提醒接受时段";
        }
    }else if([indexPath section]==1)
    {
        if ([indexPath row]==0) {
            bigLabel.text = @"我的QQ哪天可以被看";
        }else if([indexPath row]==1)
        {
            bigLabel.text = @"QQ当天最多被查看";
        }
    }
    
    UILabel  *smallLabel = [[[UILabel alloc]initWithFrame:CGRectMake(230, 15, 50, 14)] autorelease];
    smallLabel.backgroundColor=[UIColor clearColor];
    [bgView addSubview:smallLabel];
    smallLabel.font = [UIFont systemFontOfSize:12];
    smallLabel.textColor = [UIColor grayColor];
    [bigLabel release];
    [smallLabel release];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    float num = 0;
    if (section == 0) {
        num = 35.0f;
    }else if(section == 1)
    {
        num =20.0f;
    }
    return num;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     UIView* header= [[[UIView alloc]initWithFrame:CGRectZero]autorelease]
    ;
    if (section==0) {
        header.frame = CGRectMake(0, 0, 320, 35);
        UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(33, 13, 320, 15)]autorelease];
        label.text = @"设置提醒接受时段";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = RGBCOLOR(130, 130, 130);
        label.backgroundColor = [UIColor clearColor];
        [header addSubview:label];
    
    }else if(section==1)
    {
        header.frame = CGRectMake(0, 0, 320, 20);
    }
        return header;
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
    if ([indexPath section]==0) {
        if ([indexPath row]==0) {
            self.datePicker = [[[HZTimePickerView alloc] initWithDelegate:self] autorelease];
            [self.datePicker showInView:self.view];
        }
    }

}

@end
