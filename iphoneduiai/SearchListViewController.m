//
//  SearchListViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "SearchListViewController.h"
#import "LoginViewController.h"
#import <RestKit/RestKit.h>
#import "SVProgressHUD.h"

@interface SearchListViewController () <RKRequestDelegate>

@property (strong, nonatomic) NSArray *testData;

@end

@implementation SearchListViewController

-(NSArray *)testData
{
    if (_testData == nil) {
        _testData = [[NSArray alloc] initWithObjects:@"hi", @"world", @"xu", nil];
    }
    return _testData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
//    [[RKClient sharedClient] get:@"/" delegate:self];

}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    if ([request isGET]) {
        NSLog(@"body: %@", [response bodyAsString]);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    if ([self checkLogin]) {

        // do init things
        [self performSelector:@selector(doInitWork)
                   withObject:nil
                   afterDelay:0.0001];
    }
}

- (void)doInitWork
{
    // do something here
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.testData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    cell.textLabel.text = [self.testData objectAtIndex:indexPath.row];
    
    return cell;
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

#pragma mark - Other
- (BOOL)checkLogin
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user"]) {

        return YES;
    }
    
    LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self presentModalViewController:lvc animated:NO];
    [lvc release];
    
    return NO;
}

@end
