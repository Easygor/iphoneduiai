//
//  MessageListViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "MessageListViewController.h"
#import "Utils.h"
#import "MessageTableCell.h"
#import "Notification.h"
#import "NSDate-Utilities.h"
#import "NotificationListViewController.h"
#import "FeedListViewController.h"
#import "SessionViewController.h"

@interface MessageListViewController ()

@property (strong, nonatomic) NSMutableArray *messages;

@end

@implementation MessageListViewController

- (void)dealloc
{
    [_messages release];
    [super dealloc];
}

- (void)setMessages:(NSMutableArray *)messages
{
//    if (![_messages isEqualToArray:messages]) {
    _messages = [messages retain];

    [self.tableView reloadData];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.title = @"消息";

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [[Notification sharedInstance] updateFromRemote:^{

        self.messages =  [[Notification sharedInstance] mergeAndOrderNotices];

    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.messages.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"messageCell";
    MessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:3];
    }
    
    NSDictionary *msg = [self.messages objectAtIndex:indexPath.row];
    cell.nameLabel.text = msg[@"title"];
    cell.descLabel.text = msg[@"subTitle"];
    cell.count = [msg[@"bageNum"] integerValue];
    NSDate *updated = msg[@"updated"];
   // cell.timeLabel.text = [updated stringWithPattern:@"M/d HH:mm"];
    
    cell.timeLabel.text = [updated stringForHuman];
    
    if ([msg[@"logo"] hasPrefix:@"http://"]) {

        [cell.avatarImageView loadImage:msg[@"logo"]];
    } else{
        cell.avatarImageView.image = [UIImage imageNamed:msg[@"logo"]];
    }

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
        NSDictionary *msg = self.messages[indexPath.row];
        // TODO: request server
        [[Notification sharedInstance] removeNoticeObject:msg];
        [self.messages removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *msg = self.messages[indexPath.row];
    if ([msg[@"type"] isEqualToString:@"message"]) {
        
        SessionViewController *svc = [[SessionViewController alloc] initWithNibName:@"SessionViewController" bundle:nil];
        svc.messageData = msg[@"data"];
        [self.navigationController pushViewController:svc animated:YES];
        [svc release];
        
    } else if ([msg[@"type"] isEqualToString:@"notice"]){
        
        NotificationListViewController *nlvc = [[NotificationListViewController alloc] initWithNibName:@"NotificationListViewController" bundle:nil];
        [self.navigationController pushViewController:nlvc animated:YES];
        [nlvc release];
        
    } else if ([msg[@"type"] isEqualToString:@"feed"]){
        
        FeedListViewController *flvc = [[FeedListViewController alloc] initWithNibName:@"FeedListViewController" bundle:nil];
        [self.navigationController pushViewController:flvc animated:YES];
        [flvc release];
        
    }

}

@end
