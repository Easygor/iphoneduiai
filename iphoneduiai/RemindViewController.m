//
//  RemindViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "RemindViewController.h"

@interface RemindViewController ()
@property(nonatomic,retain)NSArray *dataArray;

@end

@implementation RemindViewController

@synthesize dataArray=_dataArray;

- (void)dealloc
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
   
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    _dataArray = [[NSArray alloc]initWithObjects:@"收到新私信",@"个人新动态提醒",@"有人赞了我", nil];
    
    
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

    UILabel *bigLabel = [[[UILabel alloc]initWithFrame:CGRectMake(23, 13, 200, 15)] autorelease];
    bigLabel.backgroundColor=[UIColor clearColor];
    [bgView addSubview:bigLabel];
    bigLabel.text = [self.dataArray objectAtIndex:[indexPath row]];

    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
    return 35;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header= [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35)]autorelease];
    UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(33, 13, 320, 15)]autorelease];
    label.text = @"当以下情况发生时,提醒我";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = RGBCOLOR(130, 130, 130);

    label.backgroundColor = [UIColor clearColor];
    [header addSubview:label];
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
