//
//  ChoosePartnerViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ChoosePartnerViewController.h"
#import "CustomBarButtonItem.h"
@interface ChoosePartnerViewController ()
@property(nonatomic,retain)NSArray *dataArray;
@end

@implementation ChoosePartnerViewController
@synthesize dataArray = _dataArray;





-(void)dealloc
{
    [_dataArray release];
    [super dealloc];
}
-(void)loadView
{
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"保存"
                                                                                                target:self
                                                                                                action:@selector(saceAction)] autorelease];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    _dataArray = [[NSArray alloc]initWithObjects:@"择偶要求",@"性别",@"年龄",@"所在地区",@"身高",@"学历",@"月薪",@"住房",@"购车", nil];
    
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36.0f;
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
   
    arrowImgView.image = [UIImage imageNamed:@"statusdetail_header_arrow.png"];
    if ([indexPath row]==0) {
        UIImageView *img = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"messages_toolbar_emoticonbutton_background_highlighted.png"]]autorelease];
        img.frame = CGRectMake(15, 10, 24, 24);
        [cell.contentView addSubview:img];
        bigLabel.frame = CGRectMake(30, 10, 100, 25);
        bigLabel.font = [UIFont boldSystemFontOfSize:15];
    }else
    {
        if ([indexPath row]!=1) {
            [cell addSubview:arrowImgView];

        }
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
