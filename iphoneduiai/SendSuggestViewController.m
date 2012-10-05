//
//  SendSuggestViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-5.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "SendSuggestViewController.h"

@interface SendSuggestViewController ()

@end

@implementation SendSuggestViewController

-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    contentTextView = [[[UITextView alloc]initWithFrame:CGRectMake(10, 20, 302, 140)]autorelease];
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.delegate = self;
    [contentTextView becomeFirstResponder];
    
    
     contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 302, 130)]autorelease];
    contentLabel.textColor = RGBCOLOR(172, 172, 172);
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font=[UIFont systemFontOfSize:16];
    contentLabel.text=@"感谢您下载使用对爱，如果您在使用过程中有任何不愉快体验,或有任何改进意见。\n请随时告知我们。\n您的意见对我们非常宝贵，再次感谢！\n\040                                               ---对爱团队";
    contentLabel.lineBreakMode = UILineBreakModeWordWrap;
    contentLabel.numberOfLines = 0;
    
    [contentLabel sizeToFit];
    [contentTextView addSubview:contentLabel];
    
    [self.view addSubview:contentTextView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#define UITextFieldDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (contentTextView.text.length > 0)
        contentLabel.hidden = YES;
    else
        contentLabel.hidden = NO;
}

#pragma mark - key board notice
-(void)keyboardWillShow:(NSNotification*)note
{
    [UIView animateWithDuration:0.3 animations:^(void)
     {
         CGRect r = CGRectZero;
         [[note.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] getValue:&r];
         CGRect rect = contentTextView.frame;
         rect.size.height = 460 -70-r.size.height;
         contentTextView.frame = rect;
         
     }];
    
}

@end
