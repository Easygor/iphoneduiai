//
//  SeniorViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-2.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "SeniorViewController.h"
#define kActionChooseImageTag 201
@interface SeniorViewController ()

@property (strong, nonatomic) NSArray *entries;
@end



@implementation SeniorViewController
@synthesize entries = _entries;

- (void)dealloc
{
    [_entries release];
    [super dealloc];
}

- (NSArray *)entries
{
    if (_entries == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"seniorEntries" withExtension:@"plist"];
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
-(void)loadView
{
    [super loadView];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//通过触摸背景关闭键盘
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    for (UITableViewCell *cell in self.tableView.subviews )
    {
        if ([cell isMemberOfClass:[UITableViewCell class]])
            
        {for (UIView *view in [cell.contentView subviews]) {
            for (UITextField *field in [view subviews] )
            {
                if ([field isMemberOfClass:[UITextField class]]) {
                    [field resignFirstResponder];
                }
            
            }
            
        }
        }
        
    }
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
    
   
    int bigLabelTag = 102;
   
    int smallImgTag= 104;
    int lineTag = 105;
    int arrowTag = 107;
    int textFieldTag = 108;
    
    UILabel* bigLabel=nil;
    UILabel* smallLabel=nil;
    UIImageView* lineView=nil;
    UIView* bgView = nil;
    UIImageView* arrowImgView = nil;
    UITextField* textField = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        
        bgView = [[[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 44)] autorelease];
        bgView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgView];
        
        lineView= [[[UIImageView alloc]initWithFrame:CGRectMake(0, 43, 300, 1)]autorelease];
        lineView.image =  [UIImage imageNamed:@"line.png"];
        lineView.tag = lineTag;
        [bgView addSubview:lineView];
    
        
        bigLabel = [[[UILabel alloc]initWithFrame:CGRectZero] autorelease];
        bigLabel.backgroundColor=[UIColor clearColor];
        bigLabel.tag=bigLabelTag;
        [bgView addSubview:bigLabel];

        textField = [[[UITextField alloc]initWithFrame:CGRectMake(100, 15, 150, 14)]autorelease];
        textField.placeholder = @"未填写";
        [bgView addSubview:textField];
        textField.tag = textFieldTag;
        textField.font = [UIFont systemFontOfSize:12];
        textField.textColor = [UIColor grayColor];
        
        arrowImgView = [[[UIImageView alloc]initWithFrame:CGRectMake(280, 15, 14, 14)] autorelease];
        arrowImgView.tag = arrowTag;
        [cell addSubview:arrowImgView];
        
    }
    
    if (lineView == nil)
        lineView = (UIImageView*)[cell viewWithTag:lineTag];
    
    if (bigLabel == nil)
        bigLabel = (UILabel*)[cell viewWithTag:bigLabelTag];
    
    if (smallLabel == nil)
        smallLabel = (UILabel*)[cell viewWithTag:smallImgTag];
    if (arrowImgView ==nil) {
        arrowImgView = (UIImageView*)[cell viewWithTag:arrowTag];
    }
    if (textField == nil) {
        textField = (UITextField*)[cell viewWithTag:textFieldTag];
    }
    
    NSDictionary *data = [[self.entries objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UIImage *img = nil;
    UIImage *headImg = nil;
    UIImage *arrowImg = [UIImage imageNamed:@"statusdetail_header_arrow.png"];
    
    if (![[data objectForKey:@"logo"] isEqualToString:@""]) {
        bigLabel.frame = CGRectMake(15, 0, 200, 44);
        img = [UIImage imageNamed:[data objectForKey:@"logo"]];
        
    } else{
        bigLabel.frame = CGRectMake(10, 0, 200, 44);
    }
    
    bigLabel.text = [data objectForKey:@"text"];
    [bgView addSubview:lineView];
    
    if ([[data objectForKey:@"haveNext"] boolValue]) {
        arrowImgView.image = arrowImg;
    } else{
        arrowImgView.image = nil;
    }
    
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 
        return 30;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = self.tableView.sectionHeaderHeight; // note: the height is static.
    
    if (scrollView.contentOffset.y <= sectionHeaderHeight &&
        scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight-10, 0, 0, 0);
        
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header= [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)]autorelease];
    UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 15)]autorelease];
    label.textColor = [UIColor blueColor];
    label.backgroundColor = [UIColor clearColor];
    if (section==0) {
        label.text = @"工作学习";
    }else if(section==1)
    {
        label.text = @"个人信息";
    }else if(section==2)
    {
        label.text = @"生活状况";
    }
    [header addSubview:label];
    
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
                    [actionSheet release];
                    
                } else {
                    
                    UIImagePickerController *picker = [[[UIImagePickerController alloc] init]autorelease];
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
           
        }else if([indexPath row]==1)
        {
                        
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
        UIImagePickerController* imagePickerController = [[[UIImagePickerController alloc] init]autorelease];
        
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
