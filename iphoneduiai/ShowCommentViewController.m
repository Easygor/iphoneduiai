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
@interface ShowCommentViewController ()
@property (nonatomic,retain)NSArray *contents;
@end

@implementation ShowCommentViewController
@synthesize weiYuDic;

-(void)dealloc
{
    [weiYuDic release];
    [_contents release];
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"评论微语"];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"评论"target:self action:@selector(addbutton)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    [self getComment];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return [self.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier1 = @"weiyuWordCell";
     
    if ([indexPath row]==0) {
        WeiyuWordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
            cell = [nib objectAtIndex:2];
            cell.delegate = self;
        }
        cell.weiyu = self.weiYuDic;
        return cell;

    }else {
        ShowCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[ShowCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        NSDictionary *comment = self.contents[[indexPath row]];
        cell.contentLabel.text = comment[@"content"];
        cell.titleLabel.text = comment[@"uinfo"][@"niname"];
        if ([comment[@"unifo"][@"photo"] isEqualToString:@""]) {
            [cell.headImgView loadImage:@"http://img.zhuohun.com/sys/nopic-w.jpg"];
        } else{
            [cell.headImgView loadImage:comment[@"uinfo"][@"photo"]];
        }
          return cell;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==0) {
        WeiyuWordCell *cell = (WeiyuWordCell *)[self creatNormalCell:tableView cellForRowAtIndexPath:indexPath];
        return [cell requiredHeight];
    }else
    {
        return 60.0f;
    }
    
}
- (UITableViewCell *)creatNormalCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"weiyuWordCell";
    WeiyuWordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:2];
        cell.delegate = self;
    }
    
    // Configure the cell...
    cell.weiyu = weiYuDic;
    return cell;
}
- (void)getComment
{
    NSMutableDictionary *dParams = [Utils queryParams];
    dParams[@"id"] = self.weiYuDic[@"id"];
    [[RKClient sharedClient] get:[@"/v/getreply.api" stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSMutableDictionary *data = [[response bodyAsString] mutableObjectFromJSONString];
                NSInteger code = [[data objectForKey:@"error"] integerValue];
                if (code == 0) {
                    if (data[@"data"] != [NSNull null])
                    {
                        self.contents = data[@"data"];
                    }
                     [self.tableView reloadData];
                    } else{
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
            }
        }];
        
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"error: %@", [error description]);
        }];
        
    }];
    
}

@end
