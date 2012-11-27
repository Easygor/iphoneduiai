//
//  AddWeiyuViewController.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-3.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "AddWeiyuViewController.h"
#import "LocationController.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "Utils.h"
#import "CustomBarButtonItem.h"
#import <QuartzCore/QuartzCore.h>
#import "PageSmileDataSource.h"
#import "PageSmileView.h"
#import "SVProgressHUD.h"
#import "PositionView.h"

@interface AddWeiyuViewController () <PageSmileDataSource>

@property (strong, nonatomic) NSArray *emontions;
@property (strong, nonatomic) NSData *imageData;
@property (assign, nonatomic) NSRange lastRange;
@property (nonatomic) CLLocationCoordinate2D curLocaiton;
@property (strong, nonatomic) NSString *curAddress, *photoId;
@property (retain, nonatomic) IBOutlet PositionView *positionView;
@property (assign, nonatomic) BOOL state;

@end

@implementation AddWeiyuViewController

-(void)loadView
{
    [super loadView];
    
    avatarImageView = [[[AsyncImageView alloc] initWithFrame:CGRectMake(10, 21, 35, 35)] autorelease];
    [self.view addSubview:avatarImageView];
    
    UIImageView *iconImgView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weiyu_headbox.png"]]autorelease];
    iconImgView.frame = CGRectMake(10, 20, 36, 37);
    [self.view addSubview:iconImgView];
    
    contentView = [[[UIView alloc]initWithFrame:CGRectMake(55, 20, 255, 174)]autorelease];
    contentView.backgroundColor = [UIColor whiteColor];
    
    // 圆角
    contentView.layer.cornerRadius = 4.0f;
    contentView.layer.masksToBounds = YES;
    contentView.layer.borderWidth = 1.0f;
    contentView.layer.borderColor = [RGBCOLOR(217, 217, 217) CGColor];

    contentTextView = [[[UITextView alloc]initWithFrame:CGRectMake(2, 0, 255, 100)]autorelease];
    contentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.delegate = self;
    [contentTextView becomeFirstResponder];

    toolView = [[[UIView alloc]initWithFrame:CGRectMake(0, 134, 255, 40)]autorelease];
    toolView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    toolView.backgroundColor = RGBCOLOR(246, 246, 246);
    
    UILabel *lable1 = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 255, 1)] autorelease];
    lable1.backgroundColor = RGBCOLOR(224, 224, 244);
    UILabel *lable2 = [[[UILabel alloc] initWithFrame:CGRectMake(0, 1, 255, 1)] autorelease];
    lable2.backgroundColor = RGBCOLOR(255, 255, 255);
    [toolView addSubview:lable1];
    [toolView addSubview:lable2];
    [contentView addSubview:contentTextView];
    [contentView addSubview:toolView];
    
    UIButton *picButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [picButton setImage:[UIImage imageNamed:@"sub_pic_icon"] forState:UIControlStateNormal];
    [picButton setImage:[UIImage imageNamed:@"sub_pic_icon_linked"] forState:UIControlStateHighlighted ];
     picButton.frame = CGRectMake(20, 12, 24, 20);
    [picButton addTarget:self action:@selector(picSelect:)forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:picButton];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setImage:[UIImage imageNamed:@"sub_cut_icon"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"sub_cut_icon_linked"] forState:UIControlStateHighlighted ];
    cameraButton.frame = CGRectMake(85, 12, 26, 21);
    [cameraButton addTarget:self action:@selector(cameraSelect:)forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:cameraButton];
    
    faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceButton setImage:[UIImage imageNamed:@"sub_express_icon"] forState:UIControlStateNormal];
    [faceButton setImage:[UIImage imageNamed:@"sub_express_icon_linked"] forState:UIControlStateHighlighted ];
    faceButton.frame = CGRectMake(150, 12, 24, 24);
    [faceButton addTarget:self action:@selector(faceSelect:)forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:faceButton];
    
    UIButton *locButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locButton setImage:[UIImage imageNamed:@"sub_posi_icon"] forState:UIControlStateNormal];
    [locButton setImage:[UIImage imageNamed:@"sub_posi_icon_linkded"] forState:UIControlStateHighlighted ];
    [locButton setImage:[UIImage imageNamed:@"sub_posi_select_icon"] forState:UIControlStateSelected];
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

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_emontions release];
    [_imageData release];
    [_curAddress release];
    [_positionView release];
    [super dealloc];
}

- (void)setCurAddress:(NSString *)curAddress
{
    if (![_curAddress isEqualToString:curAddress]) {
        _curAddress = [curAddress retain];
        
        self.positionView.address = curAddress;
        CGRect posFrame = self.positionView.frame;
        posFrame.origin.x = 2;
        posFrame.origin.y = contentTextView.frame.size.height - posFrame.size.height;
        self.positionView.frame = posFrame;
        
        [contentTextView addSubview:self.positionView];
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"发表新微语"];

    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"发表"
                                                                                                target:self
                                                                                                action:@selector(sendAction)] autorelease];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *info = [user objectForKey:@"info"];
    if (user[@"avatar"]) {
        avatarImageView.image = [UIImage imageWithData:user[@"avatar"]];
    } else{
        [avatarImageView loadImage:info[@"photo"]];
    }
    
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

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendAction
{

    [self sendWeiyuRequest];
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

#pragma mark - personal method

- (IBAction)picSelect:(UIButton*)btn
{
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing=YES;
    picker.delegate =self;
    
    [self presentModalViewController:picker animated: YES];
    [picker release];
}

-(IBAction)cameraSelect:(UIButton*)btn
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate =self;
        
        [self presentModalViewController:picker animated: YES];
        [picker release];
    }

}

-(IBAction)faceSelect:(UIButton*)btn
{
    
    if (self.state) {
        [contentTextView becomeFirstResponder];

    }else
    {
        [contentTextView resignFirstResponder];

    }
}

-(IBAction)locSelect:(UIButton*)btn
{
    if ([LocationController sharedInstance].allow) {
        [SVProgressHUD show];
        [[[LocationController sharedInstance] locationManager] startUpdatingLocation];
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.curLocaiton = [LocationController sharedInstance].location.coordinate;
            [[[LocationController sharedInstance] locationManager] stopUpdatingLocation];
            
            NSDictionary *p = @{@"latlng": [NSString stringWithFormat:@"%f,%f", self.curLocaiton.latitude, self.curLocaiton.longitude],
            @"sensor": @"true", @"language":@"zh-CN"};
            
            [[RKClient sharedClient] get:[@"http://maps.googleapis.com/maps/api/geocode/json" stringByAppendingQueryParameters:p]
                              usingBlock:^(RKRequest *request){
                                  [request setOnDidFailLoadWithError:^(NSError *error){
//                                      NSLog(@"get address %@", [error description]);
                                      [SVProgressHUD dismiss];
                                  }];
                                  
                                  [request setOnDidLoadResponse:^(RKResponse *response){
                                      if (response.isOK && response.isJSON) {
                                          NSDictionary *geo = [[response bodyAsString] objectFromJSONString];
//                                          NSLog(@"geo: %@", geo);
                                          [SVProgressHUD dismiss];
                                          for (NSDictionary *g in geo[@"results"]) {
                                              if ([g[@"types"] containsObject:@"street_address"]) {
//                                                   NSLog(@"name: %@", g[@"formatted_address"]);
                                                  self.curAddress = g[@"formatted_address"];
                                                  btn.selected = YES;
                                                  break;
                                              }
                                          }
                                      } else{
                                          [SVProgressHUD showErrorWithStatus:@"位置获取失败"];
                                      }
                                  }];
                              }];
            
        });
    } else{
        [SVProgressHUD showErrorWithStatus:@"定位未开启"];
    }
}

#pragma mark –  Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /*添加处理选中图像代码*/
    NSData *data = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerEditedImage]);
    
    [Utils uploadImage:data type:@"vphoto" block:^(NSDictionary *info){
        if (info) {
            self.photoId = info[@"pid"];
        }
    }];
    [picker dismissModalViewControllerAnimated:YES];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
   [picker dismissModalViewControllerAnimated:YES];
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
    self.state = NO;
    [UIView animateWithDuration:0.3 animations:^(void)
     {
         CGRect r = CGRectZero;
         [[note.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] getValue:&r];

         CGRect rect = contentView.frame;
         rect.size.height = self.view.frame.size.height - r.size.height - contentView.frame.origin.y -5;
         contentView.frame = rect;

        }];
    
}

-(void)keyboardWillHide:(NSNotification*)note
{
    self.state = YES;
    [UIView animateWithDuration:0.3 animations:^(void)
     {
//         CGRect r = CGRectZero;
//         [[note.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] getValue:&r];
         CGRect rect = contentView.frame;
         rect.size.height = self.view.frame.size.height - 216 - contentView.frame.origin.y -5;
         contentView.frame = rect;

         
     }];
    
}

- (void)sendWeiyuRequest
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [SVProgressHUD show];
    NSMutableDictionary *dParams = [Utils queryParams];
    [[RKClient sharedClient] post:[@"/v/send.api" stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
        
        NSMutableDictionary *pd = [NSMutableDictionary dictionary];
        [pd setObject:[[UIDevice currentDevice] model] forKey:@"vfrom"];
        [pd setObject:@"true" forKey:@"submitupdate"];
        [pd setObject:contentTextView.text forKey:@"content"];
        
        if (self.curAddress) {
            [pd setObject:self.curAddress forKey:@"address"];
        }
        
        if (abs(self.curLocaiton.latitude - 0.0) > 0.001) {
            [pd setObject:[NSNumber numberWithDouble:self.curLocaiton.latitude] forKey:@"wei"];
            [pd setObject:[NSNumber numberWithDouble:self.curLocaiton.longitude] forKey:@"jin"];
        }
        
        if (self.photoId) {
            [pd setObject:self.photoId forKey:@"photoid"];
        }
        
        request.params = [RKParams paramsWithDictionary:pd];
        
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"send weiyu error: %@", [error description]);
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
        
        [request setOnDidLoadResponse:^(RKResponse *response){

            if (response.isOK && response.isJSON) {
                NSDictionary *data = [[response bodyAsString] objectFromJSONString];
                NSInteger code = [[data objectForKey:@"error"] integerValue];

                if (code != 0) {
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                } else{
                    [SVProgressHUD showSuccessWithStatus:@"发表成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }

            }
            
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
        
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
    NSMutableString *content = [NSMutableString stringWithString:contentTextView.text];
    NSRange oldOne = self.lastRange;
    if (self.lastRange.location >= content.length) {
        
        self.lastRange = NSMakeRange(content.length, 0);
    }
    [content replaceCharactersInRange:self.lastRange withString:[emontion objectForKey:@"chs"]];
    contentTextView.text = content;
    contentTextView.selectedRange = NSMakeRange(oldOne.location + [[emontion objectForKey:@"chs"] length], 0);
    self.lastRange = NSMakeRange(oldOne.location + [[emontion objectForKey:@"chs"] length], 0);
    [self textViewDidChange:contentTextView];
}

- (void)viewDidUnload {
    [self setPositionView:nil];
    [super viewDidUnload];
}
@end
