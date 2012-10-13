//
//  SessionViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-8.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "SessionViewController.h"
#import "HPGrowingTextView.h"
#import "PageSmileDataSource.h"
#import "PageSmileView.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "MesgPoperView.h"
#import "CustomBarButtonItem.h"
#import "UserDetailViewController.h"
#import "LeftBubbleCell.h"
#import "RightBubbleCell.h"
#import "CustomCellDelegate.h"

@interface SessionViewController () <HPGrowingTextViewDelegate, PageSmileDataSource, CustomCellDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HPGrowingTextView *textView;
@property (strong, nonatomic) UIView *messageView;
@property (strong, nonatomic) UIButton *faceBtn;
@property (retain, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSArray *emontions;
@property (assign, nonatomic) NSRange lastRange;
@property (assign) BOOL isShowSmile, isKeyboardShow;
@property (strong, nonatomic) PageSmileView *pageSmileView;
@property (strong, nonatomic) UIView *coverView, *headView;

@property (nonatomic) NSInteger curPage, totalPage;
@property (nonatomic) BOOL loading;

@property (strong, nonatomic) NSMutableArray *messages;
@property (retain, nonatomic) IBOutlet MesgPoperView *poperView;

@property (strong, nonatomic) NSMutableDictionary *partner;

@end

@implementation SessionViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_tableView release];
    [_textView release];
    [_messageView release];
    [_containerView release];
    [_emontions release];
    [_pageSmileView release];
    [_coverView release];
    [_messages release];
    [_poperView release];
    [super dealloc];
}

- (void)setMessages:(NSMutableArray *)messages
{
    if (![_messages isEqualToArray:messages]) {

        if (self.curPage <= 1) {
            _messages = [[NSMutableArray alloc] initWithArray:[[messages reverseObjectEnumerator] allObjects]];
        } else{
            for (id obj in [messages reverseObjectEnumerator]) {
                [_messages insertObject:obj atIndex:0];
            }
        }
        
        if (self.curPage < self.totalPage) {
            self.tableView.tableHeaderView = self.headView;
        } else{
            self.tableView.tableHeaderView = nil;
        }
        
        [self.tableView reloadData];
        if (self.curPage <= 1) {
            [self keepTableviewOnBottom];
        }
    }
}

- (NSArray *)emontions
{
    if (_emontions == nil) {
        // Custom initialization
        NSString *myFile = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
        _emontions = [[NSArray alloc] initWithContentsOfFile:myFile];
        
    }
    
    return _emontions;
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setContainerView:nil];
    [self setPoperView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:NO];
    UIView *bgView = [[[UIView alloc] initWithFrame:self.tableView.bounds] autorelease];
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.tableView.backgroundView = bgView;
    self.tableView.alwaysBounceVertical = YES;
    [self keepTableviewOnBottom];
    
    // config the sms send textview
    CGFloat leftPad = 83.0f;
    CGFloat width = 230.0f;
    self.messageView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)] autorelease];
    self.messageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.textView = [[[HPGrowingTextView alloc] initWithFrame:CGRectMake(leftPad, 2, width, 40)] autorelease];
    self.textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.textView.backgroundColor = [UIColor redColor];
    
	self.textView.minNumberOfLines = 1;
	self.textView.maxNumberOfLines = 6;
	self.textView.returnKeyType = UIReturnKeySend; //just as an example
	self.textView.font = [UIFont systemFontOfSize:15.0f];
    
	self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = RGBCOLOR(238, 238, 238);
    self.textView.enablesReturnKeyAutomatically = YES;
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.containerView addSubview:self.messageView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"chat_inputbox"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    UIImageView *entryImageView = [[[UIImageView alloc] initWithImage:entryBackground] autorelease];
    entryImageView.frame = CGRectMake(leftPad, 2, width, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"chat_input_bg"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:10 topCapHeight:4];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:background] autorelease];
    imageView.frame = CGRectMake(0, 0, self.messageView.frame.size.width, self.messageView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [self.messageView addSubview:imageView];
    [self.messageView addSubview:self.textView];
    [self.messageView addSubview:entryImageView];
    
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusBtn setImage:[UIImage imageNamed:@"chat_add_icon"] forState:UIControlStateNormal];
    [plusBtn setImage:[UIImage imageNamed:@"mailapp_addBtn2.png"] forState:UIControlStateHighlighted ];
    plusBtn.frame = CGRectMake(6, 5, 33, 34);
    [plusBtn addTarget:self action:@selector(plusAction:)forControlEvents:UIControlEventTouchUpInside];
    [self.messageView addSubview:plusBtn];
    
    self.faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.faceBtn setImage:[UIImage imageNamed:@"chat_express_icon"] forState:UIControlStateNormal];
    [self.faceBtn setImage:[UIImage imageNamed:@"messages_toolbar_emoticonbutton_background_highlighted.png"] forState:UIControlStateHighlighted ];
    self.faceBtn.frame = CGRectMake(44, 5, 33, 34);
    [self.faceBtn addTarget:self action:@selector(faceSelect:)forControlEvents:UIControlEventTouchUpInside];
    [self.messageView addSubview:self.faceBtn];

    // notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // coverview
    self.coverView = [[[UIView alloc] initWithFrame:self.tableView.frame] autorelease];
    self.coverView.backgroundColor = [UIColor clearColor];
    self.coverView.opaque = YES;
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapAction:)] autorelease];
    [self.coverView addGestureRecognizer:tap];
    UISwipeGestureRecognizer *swipd = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapAction:)] autorelease];
    swipd.direction = UISwipeGestureRecognizerDirectionDown;
    [self.coverView addGestureRecognizer:swipd];
    UISwipeGestureRecognizer *swipu = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapAction:)] autorelease];
    swipu.direction = UISwipeGestureRecognizerDirectionUp;
    [self.coverView addGestureRecognizer:swipu];
    UISwipeGestureRecognizer *swipl = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapAction:)] autorelease];
    swipl.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.coverView addGestureRecognizer:swipl];
    UISwipeGestureRecognizer *swipr = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapAction:)] autorelease];
    swipr.direction = UISwipeGestureRecognizerDirectionRight;
    [self.coverView addGestureRecognizer:swipr];
    UILongPressGestureRecognizer *longPress = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapAction:)] autorelease];
    [self.coverView addGestureRecognizer:longPress];
    
//    [tap requireGestureRecognizerToFail:longPress];
//    [tap requireGestureRecognizerToFail:swip];
//    [longPress requireGestureRecognizerToFail:swip];
    
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"消息"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"资料"
                                                                                                target:self
                                                                                                action:@selector(detailAction)] autorelease];
    self.navigationItem.title = self.messageData[@"uinfo"][@"niname"];
    
    // more table header
    self.headView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)] autorelease];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((self.view.bounds.size.width-100)/2, (30-20)/2, 100, 20);
    [btn setTitle:@"更多较早的信息" forState:UIControlStateNormal];
    [btn setTitle:@"更多较早的信息" forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn addTarget:self action:@selector(requestMoreAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:btn];
    
    [self requestMessageListWithPage:1];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.pageSmileView = [[PageSmileView alloc] initWithFrame: CGRectMake(0, 45, 320, 216)
                                                         withDataSource: self];
    
    //    pageSmileView.backgroundColor = [UIColor redColor];
    [self.containerView addSubview:self.pageSmileView];
    [self.pageSmileView release];
}

- (void)requestMoreAction
{
    [self requestMessageListWithPage:self.curPage+1];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailAction
{

    UserDetailViewController *udvc = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    self.messageData[@"uinfo"][@"_id"] = self.messageData[@"senduid"];
    udvc.user = self.messageData[@"uinfo"];
    [self.navigationController pushViewController:udvc animated:YES];
    [udvc release];
}

- (void)gestureTapAction:(UIGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan ||
        gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        if (self.isKeyboardShow) {
            [self.textView resignFirstResponder];
        } else{
            // get a rect for the textView frame
            [self resizeUIWithDuration:0.3 andCurve:UIViewAnimationCurveEaseIn delta:0];
            
        }
    }
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (void)keepTableviewOnBottom
{
    if (self.messages.count > 0) {

        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
    }
    
}

-(void)faceSelect:(UIButton*)btn
{
    
    if (btn.tag == 0) {
        
        if (self.isKeyboardShow) {
            self.isShowSmile = YES;
           [self.textView resignFirstResponder];
        } else{
            // get a rect for the textView frame
            [self resizeUIWithDuration:0.3 andCurve:UIViewAnimationCurveEaseIn delta:216];
        }

    }else{
        [self.textView becomeFirstResponder];
        
    }
}

- (void)plusAction:(UIButton*)btn
{
    NSLog(@"plus action");
    CGRect rect = [self.containerView convertRect:self.messageView.frame toView:self.view.window];

    [self.poperView showMeAtView:self.view atPoint:CGPointMake(rect.origin.x+2, rect.origin.y - 5 - self.poperView.bounds.size.height)];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.messages.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *info = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"info"];
    
    NSMutableDictionary *msg = self.messages[indexPath.row];;

    if ([msg[@"senduid"] isEqualToString:info[@"uid"]]) {
        static NSString *CellIdentifier = @"rightBubbleCell";
        RightBubbleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
            cell = [nib objectAtIndex:6];
            cell.delegate = self;
        }
        
        cell.content = msg[@"content"];
        [cell.avatarImageView loadImage:info[@"photo"]];
        cell.data = msg;
        if ([msg[@"needsend"] boolValue]) {
            [cell sendMessageToRemote];
        }
        
        return cell;
      
    } else{
        static NSString *CellIdentifier = @"leftBubbleCell";
        LeftBubbleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
            cell = [nib objectAtIndex:5];
            cell.delegate = self;
        }
        
        cell.content = msg[@"content"];
        [cell.avatarImageView loadImage:self.partner[@"photo"]];
        
        return cell;
    }
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return [cell requiredHeight];

}

#pragma mark - Table view delegate
- (void)resizeUIWithDuration:(NSTimeInterval)duration andCurve:(UIViewAnimationCurve)curve delta:(CGFloat)height
{
	// get a rect for the textView frame
	CGRect containerFrame = self.containerView.frame;
    CGRect tableFrame = self.tableView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (height + self.messageView.frame.size.height);
    tableFrame.size.height = containerFrame.origin.y;
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    
    [UIView setAnimationCurve:curve];
	
	// set views with new info
	self.containerView.frame = containerFrame;
    self.tableView.frame = tableFrame;
	
	// commit animations
	[UIView commitAnimations];
    [self keepTableviewOnBottom];
    
    // exchange facet btn
    if (self.isKeyboardShow || height == 0) {
        [self.faceBtn setImage:[UIImage  imageNamed:@"chat_express_icon"] forState:UIControlStateNormal];
        [self.faceBtn setImage:[UIImage  imageNamed:@"messages_toolbar_emoticonbutton_background_highlighted.png"] forState:UIControlStateHighlighted];
        self.faceBtn.tag = 0;
    } else{
        [self.faceBtn setImage:[UIImage  imageNamed:@"messages_toolbar_keyboardbutton_background.png"] forState:UIControlStateNormal];
        [self.faceBtn setImage:[UIImage imageNamed:@"messages_toolbar_keyboardbutton_background_highlighted.png"] forState:UIControlStateHighlighted ];
        self.faceBtn.tag = 1;
    }
    
    // cover view
    if (height == 0) {
        [self.coverView removeFromSuperview];
    } else{
        self.coverView.frame = self.tableView.frame;
        [self.view addSubview:self.coverView];
    }
}

#pragma mark - change input frame
-(void) keyboardWillShow:(NSNotification *)note
{
    
    self.isKeyboardShow = YES;
    
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [self resizeUIWithDuration:[duration doubleValue] andCurve:[curve intValue] delta:keyboardBounds.size.height];
    
}

-(void) keyboardWillHide:(NSNotification *)note
{
    
    self.isKeyboardShow = NO;
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
	CGFloat keyNormalH = 0.0f;
    if (self.isShowSmile) {
        keyNormalH = 216.0f;
        self.isShowSmile = NO;
    }
    
	// get a rect for the textView frame
    [self resizeUIWithDuration:[duration doubleValue] andCurve:[curve intValue] delta:keyNormalH];
    
}

#pragma mark growing textview delegates
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{

    CGFloat diff = growingTextView.frame.size.height - height;

	CGRect mFrame = self.messageView.frame;
    CGRect cFrame = self.containerView.frame;
    CGRect pFrame = self.pageSmileView.frame;
    cFrame.size.height -= diff;
    mFrame.size.height -= diff;
    mFrame.origin.y += diff;
    cFrame.origin.y += diff;
    pFrame.origin.y -= diff;
	self.messageView.frame = mFrame;
    self.containerView.frame = cFrame;
    self.pageSmileView.frame = pFrame;
    
    // table
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = self.containerView.frame.origin.y;
    self.tableView.frame = tableFrame;
    
    [self keepTableviewOnBottom];
}

-(BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        NSMutableDictionary *info = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"info"];
        NSMutableDictionary *newMsg = [NSMutableDictionary dictionary];
        newMsg[@"content"] = self.textView.text;
        newMsg[@"uid"] = self.partner[@"uid"];
        newMsg[@"senduid"] = info[@"uid"];
        newMsg[@"addtime"] = @([[NSDate date] timeIntervalSince1970]);

        [self.messages addObject:newMsg];
        self.textView.text = nil;
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationNone];
        
        newMsg[@"needsend"] = @YES; // 必须在cell插入之后，设置发送参数，防止就会重复发送, 因为移动bottom重复显示cell一次
        [self keepTableviewOnBottom]; // 
        
        return NO;
    }
    
    return YES;
}

-(void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
//    NSInteger nonSpaceTextLength = [[growingTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length];
//    if([growingTextView hasText] && nonSpaceTextLength > 0) {
//        
////        self.sendBtn.enabled = YES;
//        [self.placeholderLabel removeFromSuperview];
//        
//    } else {
////        self.sendBtn.enabled = NO;
//        [growingTextView addSubview:self.placeholderLabel];
//        
//    }
}

-(void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
//    if (![growingTextView hasText]) {
//        [growingTextView addSubview:self.placeholderLabel];
//    } else {
//        [self.placeholderLabel removeFromSuperview];
//    }
    
}

#pragma mark - emontions

- (int)numberOfPages
{
	return (self.emontions.count / 28) + (self.emontions.count % 28 > 0 ? 1 : 0);
}

- (UIView *)viewAtIndex:(int)index
{
    
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)] autorelease];
    for (int i=index*28; i < MIN(index*28+28, self.emontions.count); i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSInteger column = i%7;
        NSInteger row = (i%28)/7;
        
        btn.frame = CGRectMake(16 + 13 * column + 30*column, 16*(row+1) + 30*row, 30, 30);
        
        [btn setImage:[UIImage imageNamed:[[self.emontions objectAtIndex:i] objectForKey:@"png"]]
             forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(emontionAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:btn];
        
    }
    
    return view;
}

-(BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView
{
    self.lastRange = growingTextView.selectedRange;
    return YES;
}

# pragma mark actions
-(void)emontionAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSDictionary *emontion = [self.emontions objectAtIndex:btn.tag];
    NSMutableString *content = [NSMutableString stringWithString:self.textView.text];
    NSRange oldOne = self.lastRange;
    if (self.lastRange.location >= content.length) {
        
        self.lastRange = NSMakeRange(content.length, 0);
    }
    [content replaceCharactersInRange:self.lastRange withString:[emontion objectForKey:@"chs"]];
    self.textView.text = content;
    self.textView.selectedRange = NSMakeRange(oldOne.location + [[emontion objectForKey:@"chs"] length], 0);
    self.lastRange = NSMakeRange(oldOne.location + [[emontion objectForKey:@"chs"] length], 0);
    [self growingTextViewDidChange:self.textView];
}

#pragma mark - request for Feeds
- (void)requestMessageListWithPage:(NSInteger)page
{
    NSMutableDictionary *params = [Utils queryParams];
    
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObject:@"20" forKey:@"pagesize"];
    if (self.messageData[@"tid"]) {
        [params setObject:self.messageData[@"tid"] forKey:@"id"];
    }
    
    [SVProgressHUD show];
    [[RKClient sharedClient] get:[@"/uc/message.api" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
        NSLog(@"url: %@", request.URL);
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSMutableDictionary *data = [[response bodyAsString] mutableObjectFromJSONString];
                NSInteger code = [data[@"error"] integerValue];
                if (code == 0) {
                    NSLog(@"message: %@", data);
                    self.loading = NO;
                    self.totalPage = [[[data objectForKey:@"pager"] objectForKey:@"pagecount"] integerValue];
                    self.curPage = [[[data objectForKey:@"pager"] objectForKey:@"thispage"] integerValue];
                    // 此行须在前两行后面
                    
                    self.messages = data[@"data"];
                    self.partner = data[@"uinfo"];
                    
                    [SVProgressHUD dismiss];
                } else{
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
            } else{
                [SVProgressHUD showErrorWithStatus:@"获取失败"];
            }
        }];
        [request setOnDidFailLoadWithError:^(NSError *error){
            [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
            NSLog(@"Error: %@", [error description]);
        }];
    }];
}

- (IBAction)sendPictureAction:(UIButton *)sender
{
    NSLog(@"send pic....");
    [self.poperView removeMe];
}
- (IBAction)sendPosAction:(UIButton *)sender
{
    NSLog(@"send pos...");
    [self.poperView removeMe];
}

#pragma  mark custom cell delegate
- (void)didChangeStatus:(UITableViewCell *)cell toStatus:(NSString *)status
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *msg = self.messages[indexPath.row];

    NSMutableDictionary *params = [Utils queryParams];
    [[(id)cell indicatorView] startAnimating];
    
    [[RKClient sharedClient] post:[@"/common/delmessage.api" stringByAppendingQueryParameters:params] usingBlock:^(RKRequest *request){
        NSLog(@"url: %@", request.URL);
        
        request.params = [RKParams paramsWithDictionary:@{@"tid[]" : msg[@"tid"], @"submitupdate": @"true"}];
        
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK && response.isJSON) {
                NSDictionary *data = [[response bodyAsString] objectFromJSONString];
                NSInteger code = [data[@"error"] integerValue];
//                NSLog(@"delete data:%@", data);
                if (code == 0) {

                    [self.messages removeObject:msg];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                } else{
                    
                    NSLog(@"show error: %@", data[@"message"]);
                    
                }
                [[(id)cell indicatorView] startAnimating];
            }
            
        }];
        [request setOnDidFailLoadWithError:^(NSError *error){
            [[(id)cell indicatorView] startAnimating];
            NSLog(@"Error: %@", [error description]);
        }];
    }];

}

@end
