//
//  CommentViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-26.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "CommentViewController.h"
#import "SVProgressHUD.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "CustomBarButtonItem.h"
#import "PageSmileDataSource.h"
#import "PageSmileView.h"

@interface CommentViewController () <PageSmileDataSource>

@property (strong, nonatomic) NSArray *emontions;
@property (assign, nonatomic) NSRange lastRange;
@property (assign, nonatomic) BOOL state;
@end

@implementation CommentViewController


-(void)dealloc
{
    [_emontions release];
    [_bgView release];
    [_contentView release];
    [_toolView release];
    [_idStr release];
    [super dealloc];
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

-(void)loadView
{
    [super loadView];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 165)];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.opaque = YES;
    
    self.contentView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, 310, 125)];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.opaque = YES;
    [self.bgView addSubview:self.contentView];
    
    self.toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 125, 320, 40)];
    self.toolView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.toolView.backgroundColor = RGBCOLOR(246, 246, 246);
    [self.bgView addSubview:self.toolView];
    
    UIButton *picButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [picButton setImage:[UIImage imageNamed:@"sub_express_icon"] forState:UIControlStateNormal];
    [picButton setImage:[UIImage imageNamed:@"sub_express_icon_linked"] forState:UIControlStateHighlighted ];
    picButton.frame = CGRectMake(20, 12, 24, 24);
    [picButton addTarget:self action:@selector(faceSelect:)forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolView addSubview:picButton];
    [self.view addSubview:self.bgView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"发表评论"];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"发布"target:self action:@selector(sendButtonPress:)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"取消"target:self action:@selector(backAction)] autorelease];
    [self.contentView becomeFirstResponder];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    PageSmileView *pageSmileView = [[PageSmileView alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height - 216, 320, 216)
                                                         withDataSource: self];
    pageSmileView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    //    pageSmileView.backgroundColor = [UIColor redColor];
    [self.view addSubview:pageSmileView];
    [pageSmileView release];
}

-(void)faceSelect:(UIButton*)btn
{
    
    if (self.state) {
        [self.contentView becomeFirstResponder];

    }else {
        [self.contentView resignFirstResponder];
        
    }
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendButtonPress:(id)sender
{
    NSMutableDictionary *dp = [Utils queryParams];
    [SVProgressHUD show];
    [[RKClient sharedClient] post:[@"/v/reply.api" stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){
        
        // 设置POST的form表单的参数
        NSMutableDictionary *updateArgs = [NSMutableDictionary dictionary];
        if (self.contentView.text) {
            updateArgs[@"replaycontent"] = self.contentView.text;
        }
        updateArgs[@"id"] = self.idStr;
        updateArgs[@"replay"] = @"yes";
        updateArgs[@"submitupdate"] = @"true";
        request.params = [RKParams paramsWithDictionary:updateArgs];
        
        // 请求失败时
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"Error: %@", [error description]);
        }];
        
        // 请求成功时
        [request setOnDidLoadResponse:^(RKResponse *response){
            NSLog(@"error: %@", response.bodyAsString);
            if (response.isOK && response.isJSON) { // 200的返回并且是JSON数据
                NSDictionary *data = [response.bodyAsString objectFromJSONString]; // 提交后返回的状态
                NSInteger code = [data[@"error"] integerValue];  // 返回的状态
                if (code == 0) {
                    // 成功提交的情况
                    // ....
                    [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                } else{
                    // 失败的情况
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
            } else{
                [SVProgressHUD showErrorWithStatus:@"网络故障"];
            }
        }];
        
    }];

}

#pragma mark - key board notice
-(void)keyboardWillShow:(NSNotification*)note
{
    self.state = NO;
    CGRect r = CGRectZero;
    [[note.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] getValue:&r];
    
    CGRect rect = self.bgView.frame;
    rect.size.height = self.view.frame.size.height - r.size.height - self.bgView.frame.origin.y;
    // view's height minus keyboard's height minus the view which will changed size 's y position value, maybe have the the view and keyboard jianju
    self.bgView.frame = rect;
    
}

-(void)keyboardWillHide:(NSNotification*)note
{
    self.state = YES;
    [UIView animateWithDuration:0.3 animations:^(void)
     {
         //         CGRect r = CGRectZero;
         //         [[note.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] getValue:&r];
         CGRect rect = self.bgView.frame;
         rect.size.height = self.view.frame.size.height - 216 - self.bgView.frame.origin.y;
         self.bgView.frame = rect;
         
     }];
    
}

#pragma mark - emontions

- (int)numberOfPages
{
	return (self.emontions.count / 28) + (self.emontions.count % 28 > 0 ? 1 : 0);
}

- (UIView *)viewAtIndex:(int)index
{
    
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)] autorelease];
    view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
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

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.lastRange = textView.selectedRange;
    return YES;
}

# pragma mark actions
-(void)emontionAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSDictionary *emontion = [self.emontions objectAtIndex:btn.tag];
    NSMutableString *content = [NSMutableString stringWithString:self.contentView.text];
    NSRange oldOne = self.lastRange;
    if (self.lastRange.location >= content.length) {
        
        self.lastRange = NSMakeRange(content.length, 0);
    }
    [content replaceCharactersInRange:self.lastRange withString:[emontion objectForKey:@"chs"]];
    self.contentView.text = content;
    self.contentView.selectedRange = NSMakeRange(oldOne.location + [[emontion objectForKey:@"chs"] length], 0);
    self.lastRange = NSMakeRange(oldOne.location + [[emontion objectForKey:@"chs"] length], 0);
//    [self textViewDidChange:self.contentView];
}

#define UITextFieldDelegate
-(void)textViewDidChange:(UITextView *)textView
{
//    if (self.contentView.text.length > 0)
//        contentLabel.hidden = YES;
//    else
//        contentLabel.hidden = NO;
}

@end
