//
//  AddWeiyuViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-3.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "AddWeiyuViewController.h"

@interface AddWeiyuViewController ()

@end

@implementation AddWeiyuViewController

-(void)loadView
{
    [super loadView];
    UIImageView *iconImgView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tweibo_icon.png"]]autorelease];
    iconImgView.frame = CGRectMake(10, 20, 34, 34);
    [self.view addSubview:iconImgView];
    
    contentView = [[[UIView alloc]initWithFrame:CGRectMake(55, 20, 255, 140)]autorelease];
    contentView.backgroundColor = [UIColor whiteColor];
    
    contentTextView = [[[UITextView alloc]initWithFrame:CGRectMake(2, 0, 255, 100)]autorelease];
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.delegate = self;
    [contentTextView becomeFirstResponder];

    toolView = [[[UIView alloc]initWithFrame:CGRectMake(0, 100, 255, 40)]autorelease];
    toolView.backgroundColor = RGBCOLOR(246, 246, 246);
    [contentView addSubview:contentTextView];
    [contentView addSubview:toolView];
    
    UIButton *picButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [picButton setImage:[UIImage imageNamed:@"messages_toolbar_photobutton_background.png"] forState:UIControlStateNormal];
    [picButton setImage:[UIImage imageNamed:@"messages_toolbar_photobutton_background_highlighted"] forState:UIControlStateHighlighted ];
     picButton.frame = CGRectMake(20, 12, 24, 20);
    [picButton addTarget:self action:@selector(picSelect:)forControlEvents:UIControlEventTouchUpInside];     [toolView addSubview:picButton];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setImage:[UIImage imageNamed:@"messages_toolbar_camerabutton_background"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"messages_toolbar_camerabutton_background_highlighted"] forState:UIControlStateHighlighted ];
    cameraButton.frame = CGRectMake(85, 12, 26, 21);
    [cameraButton addTarget:self action:@selector(cameraSelect:)forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:cameraButton];
    
    faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceButton setImage:[UIImage imageNamed:@"messages_toolbar_emoticonbutton_background"] forState:UIControlStateNormal];
    [faceButton setImage:[UIImage imageNamed:@"messages_toolbar_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted ];
    faceButton.frame = CGRectMake(150, 12, 24, 24);
    [faceButton addTarget:self action:@selector(faceSelect:)forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:faceButton];
    
    UIButton *locButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locButton setImage:[UIImage imageNamed:@"messages_toolbar_locationbutton_background"] forState:UIControlStateNormal];
    [locButton setImage:[UIImage imageNamed:@"messages_toolbar_locationbutton_background_highlighted"] forState:UIControlStateHighlighted ];
    locButton.frame = CGRectMake(220, 12, 18, 24);
    [locButton addTarget:self action:@selector(locSelect:)forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:locButton];
    
    contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(13, 5, 244, 50)]autorelease];
    contentLabel.textColor = RGBCOLOR(172, 172, 172);
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font=[UIFont systemFontOfSize:16];
    contentLabel.text=@"晒晒现在的心情,发布一张自己的美图,用语音表达一下自己的心声.";
    contentLabel.lineBreakMode = UILineBreakModeWordWrap;
    contentLabel.numberOfLines = 0;
    
    [contentLabel sizeToFit];
    [contentTextView addSubview:contentLabel];
    
    [self.view addSubview:contentView];
    state = YES;
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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

#pragma mark - personal method

- (IBAction)picSelect:(id)sender {
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing=YES;
    picker.delegate =self;
    
    [self presentModalViewController:picker animated: YES];
    [picker release];
}

-(IBAction)cameraSelect:(id)sender
{
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate =self;
    
    [self presentModalViewController:picker animated: YES];
    [picker release];

}

-(IBAction)faceSelect:(id)sender
{
    
    if (state) {
        [contentTextView resignFirstResponder];
        [faceButton setImage:[UIImage  imageNamed:@"messages_toolbar_keyboardbutton_background.png"] forState:UIControlStateNormal];
        [faceButton setImage:[UIImage imageNamed:@"messages_toolbar_keyboardbutton_background_highlighted.png"] forState:UIControlStateHighlighted ];
        state = NO;
    }else
    {
        [contentTextView becomeFirstResponder];
        [faceButton setImage:[UIImage  imageNamed:@"messages_toolbar_emoticonbutton_background"] forState:UIControlStateNormal];
        state = YES;

    }
}

-(IBAction)locSelect:(id)sender
{
}

#pragma mark –  Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    /*添加处理选中图像代码*/
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
   [self dismissModalViewControllerAnimated:YES]; 
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
         CGRect rect = contentView.frame;
         rect.size.height = 460 -70-r.size.height;
         CGRect rect2 = toolView.frame;
         rect2.origin.y = rect.size.height-40;
         CGRect rect3 = contentTextView.frame;
         rect3.size.height = 460 -125-r.size.height;
         contentView.frame = rect;
         toolView.frame = rect2;
         contentTextView.frame = rect3;
         
        }];
    
}


@end
