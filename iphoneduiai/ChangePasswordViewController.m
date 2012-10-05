//
//  ChangePasswordViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-5.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "CustomBarButtonItem.h"
@interface ChangePasswordViewController ()
@property(nonatomic,retain)NSArray *dataArray;
@property(nonatomic,retain)NSArray *psdArray;
@end

@implementation ChangePasswordViewController

@synthesize dataArray=_dataArray;
@synthesize psdArray =_psdArray;
- (void)dealloc
{
    [_dataArray release];
    [_psdArray release];
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
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"保存"
                                                                                                target:self
                                                                                                action:@selector(saceAction)] autorelease];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    _dataArray = [[NSArray alloc]initWithObjects:@"旧密码",@"新密码",@"重复新密码", nil];
    _psdArray = [[NSArray alloc]initWithObjects:@"",@"",@"", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-
-(void)saceAction
{
    
    for (UITableViewCell *cell in self.tableView.subviews )
    {
        if ([cell isMemberOfClass:[UITableViewCell class]])
            
        {for (UIView *view in [cell.contentView subviews]) {
            for (UITextField *field in [view subviews] )
            {
                if ([field isMemberOfClass:[UITextField class]]) {
                    
                    
                }
                
            }
            
        }
        }
        
    }

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
    return 3;
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
    
    UILabel *bigLabel = [[[UILabel alloc]initWithFrame:CGRectMake(15, 13, 200, 15)] autorelease];
    bigLabel.backgroundColor=[UIColor clearColor];
    bigLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:bigLabel];
    bigLabel.text = [self.dataArray objectAtIndex:[indexPath row]];

    UITextField *field = [[[UITextField alloc]initWithFrame:CGRectMake(115, 10, 170, 20)]autorelease];
    field.font = [UIFont systemFontOfSize:15];
    field.secureTextEntry = YES;
    [cell.contentView addSubview:field];
    
    if ([indexPath row]==0) {
        field.placeholder = @"请输入当前使用密码";
    }else if([indexPath row]==1)
    {
        field.placeholder = @"新密码长度位6位以上";
    }else if([indexPath row]==2)
    {
        field.placeholder = @"再输入一遍新密码";
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header= [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35)]autorelease];
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
}

@end
