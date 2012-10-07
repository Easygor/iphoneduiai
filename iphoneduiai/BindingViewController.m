//
//  BindingViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-7.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "BindingViewController.h"
#import "CustomBarButtonItem.h"
@interface BindingViewController ()
@property (strong, nonatomic) NSArray *entries;

@end

@implementation BindingViewController
@synthesize entries = _entries;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_entries release];
    [super dealloc];
}

- (NSArray *)entries
{
    if (_entries == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"settingBindingEntries" withExtension:@"plist"];
        _entries = [[NSArray alloc] initWithContentsOfURL:url];
    }
    
    return _entries;
}


-(void)loadView
{
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"保存"
                                                                                                target:self
                                                                                                action:@selector(saceAction)] autorelease];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 
-(void)saceAction
{

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
    
    if ([indexPath row]==0) {
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"messages_toolbar_emoticonbutton_background_highlighted.png"]];
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
