//
//  BlockUsersViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-22.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "BlockUsersViewController.h"
#import "CustomBarButtonItem.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "UserDetailViewController.h"

@interface BlockUsersViewController ()

@property (strong, nonatomic) NSMutableArray *users;
@property (retain, nonatomic) IBOutlet UIView *emptyDataView;

@end

@implementation BlockUsersViewController

- (void)dealloc
{
    [_emptyDataView release];
    [_users release];
    [super dealloc];
}

- (void)setUsers:(NSMutableArray *)users
{
    if (![_users isEqualToArray:users]) {
        _users = [users retain];
        
        [self.emptyDataView removeFromSuperview];
    }
}

- (void)viewDidUnload
{
    [self setEmptyDataView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"我的黑名单"];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"编辑"
                                                                                                target:self
                                                                                                action:@selector(editAction)] autorelease];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction
{
    [self setEditing:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.users.count <= 0) {
        [self.tableView addSubview:self.emptyDataView];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
     return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"blackUserCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

    UserDetailViewController *detailViewController = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    detailViewController.user = self.users[indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];

}


@end
