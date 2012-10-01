//
//  SettingViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-9-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "SettingViewController.h"
#import "RemindViewController.h"
#import "PreventSetViewController.h"
#define kActionChooseImageTag 201
@interface SettingViewController ()

@property (strong, nonatomic) NSArray *entries;
@end

@implementation SettingViewController
@synthesize entries = _entries;

- (void)dealloc
{
    [_entries release];
    [super dealloc];
}

- (NSArray *)entries
{
    if (_entries == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"settingEntries" withExtension:@"plist"];
        _entries = [[NSArray alloc] initWithContentsOfURL:url];
    }
    
    return _entries;
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
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.frame = CGRectMake(10, 50, 300, 44);
    exitButton.backgroundColor =RGBCOLOR(226, 86, 89);
    
    [exitButton setTitle:@"退出" forState:UIControlStateNormal];
    exitButton.titleLabel.text = @"退出";
    exitButton.titleLabel.textColor = [UIColor whiteColor];
    [exitButton addTarget:self action:@selector(resginAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:exitButton];
    self.tableView.tableFooterView = footView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.entries.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [[self.entries objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    
    int frontImgTag = 101;
    int bigLabelTag = 102;
    int behindImgTag = 103;
    int smallImgTag= 104;
    int lineTag = 105;
    int bgViewTag = 106;
    int arrowTag = 107;
    
    UIImageView* frontImg = nil;
    UILabel* bigLabel=nil;
    UILabel* smallLabel=nil;
    UIImageView* behindImg=nil;
    UIImageView* lineView=nil;
    UIView* bgView = nil;
    UIImageView* arrowImgView = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        //cell.selectionStyle = UITableViewCellSelectionStyleBlue;

        
        bgView = [[[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 44)] autorelease];
        bgView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgView];
        
        frontImg = [[[UIImageView alloc] initWithFrame: CGRectMake(10, 13, 18, 18)] autorelease];
        frontImg.tag = frontImgTag;
        
        lineView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 43, 300, 1)];
        lineView.image =  [UIImage imageNamed:@"line.png"];
        lineView.tag = lineTag;
        [bgView addSubview:lineView];
        
        behindImg = [[[UIImageView alloc]initWithFrame:CGRectZero] autorelease];
        behindImg.tag=behindImgTag;
        // [cell.contentView addSubview:behindImg];
        behindImg.frame = CGRectMake(230, 2, 40,40);
        [bgView addSubview:behindImg];
        
        
        bigLabel = [[[UILabel alloc]initWithFrame:CGRectZero] autorelease];
        bigLabel.backgroundColor=[UIColor clearColor];
        bigLabel.tag=bigLabelTag;
        [bgView addSubview:bigLabel];
        
        smallLabel = [[[UILabel alloc]initWithFrame:CGRectMake(230, 15, 50, 14)] autorelease];
        smallLabel.backgroundColor=[UIColor clearColor];
        [bgView addSubview:smallLabel];
        smallLabel.tag=smallImgTag;
        smallLabel.font = [UIFont systemFontOfSize:12];
        smallLabel.textColor = [UIColor grayColor];
        
        arrowImgView = [[[UIImageView alloc]initWithFrame:CGRectMake(280, 15, 14, 14)] autorelease];
        arrowImgView.tag = arrowTag;
        [cell addSubview:arrowImgView];

    }
    
    if (bgView == nil)
        bgView = (UIView*)[cell viewWithTag:bgViewTag];
    
    if (lineView == nil)
        lineView = (UIImageView*)[cell viewWithTag:lineTag];
    
    if (frontImg == nil)
        frontImg= (UIImageView*)[cell viewWithTag:frontImgTag];
    
    if (behindImg == nil)
        behindImg= (UIImageView*)[cell viewWithTag:behindImgTag];
    
    if (bigLabel == nil)
        bigLabel = (UILabel*)[cell viewWithTag:bigLabelTag];
    
    if (smallLabel == nil)
        smallLabel = (UILabel*)[cell viewWithTag:smallImgTag];
    if (arrowImgView ==nil) {
        arrowImgView = (UIImageView*)[cell viewWithTag:arrowTag];
    }
    
    NSDictionary *data = [[self.entries objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UIImage *img = nil;
    UIImage *headImg = nil;
    UIImage *arrowImg = [UIImage imageNamed:@"statusdetail_header_arrow.png"];
    
    if (![[data objectForKey:@"logo"] isEqualToString:@""]) {
        bigLabel.frame = CGRectMake(40, 0, 200, 44);
        img = [UIImage imageNamed:[data objectForKey:@"logo"]];
        
    } else{
        bigLabel.frame = CGRectMake(10, 0, 200, 44);
    }
    
    bigLabel.text = [data objectForKey:@"text"];
    [bgView addSubview:lineView];
    frontImg.image = img;
    [bgView addSubview:frontImg];
    
    if ([[data objectForKey:@"haveNext"] boolValue]) {
        arrowImgView.image = arrowImg;
    } else{
        arrowImgView.image = nil;
    }
    
    if ([[data objectForKey:@"label"] isEqualToString:@"set_avatar"]) {
        headImg = [UIImage imageNamed:@"tweibo_icon.png"];
    }else if([[data objectForKey:@"label"] isEqualToString:@"my_photo"])
    {
        smallLabel.text = @"共2张";
    }else if([[data objectForKey:@"label"] isEqualToString:@"up_person"])
    {
        smallLabel.text = @"共13人";
    } else{
        smallLabel.text = @"";
        
    }
    
    behindImg.image = headImg;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return 15;
    else
        return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header= [[UIView alloc]initWithFrame:CGRectZero];
    if (section == 0)
        header.frame = CGRectMake(0, 0, 320, 15);
    else
        header.frame = CGRectMake(0, 0, 320, 25);
    return header;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==0) {
        if ([indexPath row]==0) {
            NSDictionary *data = [[self.entries objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            NSLog(@"hah : %@", [data objectForKey:@"label"]);
            
            if ([[data objectForKey:@"label"] isEqualToString:@"set_avatar"]) {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                  initWithTitle:nil
                                                  delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                  otherButtonTitles:@"从资源库",@"拍照",nil];
                    actionSheet.tag=kActionChooseImageTag;
                    [actionSheet showInView:self.view];
                    
                } else {
                    
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    picker.delegate = self;
                    picker.allowsEditing = YES;
                    [self presentModalViewController:picker animated:YES];
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                }
                
            }
            
        }
    }else if([indexPath section]==1)
    {
        
    }else if([indexPath section]==2)
    {
        if ([indexPath row]==0) {
            RemindViewController *remindViewController = [[RemindViewController alloc]initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:remindViewController animated:YES];
        }else if([indexPath row]==1)
        {
            PreventSetViewController *preventSetViewController = [[PreventSetViewController alloc]initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:preventSetViewController animated:YES];
            
        }
        
    }else if([indexPath section]==3)
    {
        
    }
    
    
}

- (IBAction)resginAction
{
    NSLog(@"log out");
}

#pragma mark - ActionSheet Delegate Methods
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==kActionChooseImageTag) {
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        
        if (buttonIndex == 0)
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        else  if(buttonIndex==1)
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        else if(buttonIndex==2)
            return;
        
        imagePickerController.delegate=self;
        //        imagePickerController.allowsEditing = YES;
        [self presentModalViewController: imagePickerController
                                animated: YES];
    }
}
@end
