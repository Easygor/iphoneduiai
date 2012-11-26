//
//  WeiyuTextPicCell.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-11-27.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "WeiyuTextPicCell.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "SliderView.h"
#import "SVProgressHUD.h"


@interface WeiyuTextPicCell () <UIScrollViewDelegate, SliderDataSource, UIActionSheetDelegate>

@property (retain, nonatomic) IBOutlet AsyncImageView *avatarImageView;
@property (retain, nonatomic) IBOutlet UIView *shadowView;
@property (retain, nonatomic) IBOutlet UIView *containerView;
@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel, *fromLabel, *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *plusBtn, *minusBtn, *commentBtn;
@property (strong, nonatomic) IBOutlet UIImageView *timeIconView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet AsyncImageView *showPicView;
@property (retain, nonatomic) IBOutlet UIView *addressView;

@property (strong, nonatomic) NSString *addTimeDesc;
@property (strong, nonatomic) NSString *picUrl;


@property (strong, nonatomic) NSMutableArray *photos;

@property (strong, nonatomic) SliderView *slider;
@property (strong, nonatomic) UIImageView *curImageView;

@end

@implementation WeiyuTextPicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.delegate = nil;
    
    [_photos release];
    [_curImageView release];
    [_slider release];
    [_showPicView release];
    [_avatarImageView release];
    [_shadowView release];
    [_containerView release];
    [_mainView release];
    [_nameLabel release];
    [_fromLabel release];
    [_addressLabel release];
    [_plusBtn release];
    [_minusBtn release];
    [_commentBtn release];
    [_timeIconView release];
    [_timeLabel release];
    [_addTimeDesc release];
    [_weiyu release];
    [_contentLabel release];

    [_addressView release];
    [super dealloc];
}

- (void)setDigoNum:(NSInteger)digoNum
{
    if (_digoNum != digoNum) {
        _digoNum = digoNum;
        [self.weiyu setObject:[NSNumber numberWithInteger:digoNum] forKey:@"digo"];
        [self.plusBtn setTitle:[NSString stringWithFormat:@"%d", digoNum] forState:UIControlStateNormal];
        [self.plusBtn setTitle:[NSString stringWithFormat:@"%d", digoNum] forState:UIControlStateHighlighted];
    }
}

- (void)setShitNum:(NSInteger)shitNum
{
    if (_shitNum != shitNum) {
        _shitNum = shitNum;
        [self.weiyu setObject:[NSNumber numberWithInteger:shitNum] forKey:@"shit"];
        [self.minusBtn setTitle:[NSString stringWithFormat:@"%d", shitNum] forState:UIControlStateNormal];
        [self.minusBtn setTitle:[NSString stringWithFormat:@"%d", shitNum] forState:UIControlStateHighlighted];
    }
}

- (void)setCommentNum:(NSInteger)commentNum
{
    if (_commentNum != commentNum) {
        _commentNum = commentNum;
        [self.weiyu setObject:[NSNumber numberWithInteger:commentNum] forKey:@"comentcount"];
        [self.commentBtn setTitle:[NSString stringWithFormat:@"%d", commentNum] forState:UIControlStateNormal];
        [self.commentBtn setTitle:[NSString stringWithFormat:@"%d", commentNum] forState:UIControlStateHighlighted];
    }
}

- (void)setAddTimeDesc:(NSString *)addTimeDesc
{
    if (![_addTimeDesc isEqualToString:addTimeDesc]) {
        _addTimeDesc = [addTimeDesc retain];
        CGSize size = [addTimeDesc sizeWithFont:self.timeLabel.font];
        
        CGRect timeFrame = self.timeLabel.frame;
        CGFloat oldRightX = timeFrame.origin.x + timeFrame.size.width;
        timeFrame.size.width = size.width;
        timeFrame.origin.x = oldRightX - size.width;
        self.timeLabel.frame = timeFrame;
        
        CGRect iconFrame = self.timeIconView.frame;
        iconFrame.origin.x = self.timeLabel.frame.origin.x - 2 - iconFrame.size.width;
        self.timeIconView.frame = iconFrame;
        
        self.timeLabel.text = addTimeDesc;
        
    }
}

- (void)doInitWork
{
    self.shadowView.layer.shadowColor = [RGBCOLOR(153, 153, 153) CGColor];
    self.shadowView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.shadowView.layer.shadowOpacity = 0.65;
    self.shadowView.layer.shouldRasterize = YES;
    self.shadowView.layer.shadowRadius = 0.5f;
    
    self.shadowView.layer.cornerRadius = 3.0f;
    
    self.containerView.layer.cornerRadius = 3.0f;
    self.containerView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatarAction:)] autorelease];
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView addGestureRecognizer:singleTap];
    
    [self.showPicView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageGesture:)] autorelease]];
    //                imView.tag = 0;
    self.showPicView.userInteractionEnabled = YES;
    
}

- (void)tapAvatarAction:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(didChangeStatus:toStatus:)]) {
            [self.delegate didChangeStatus:self toStatus:@"tap_avatar"];
        }
    }
}

- (void)awakeFromNib
{
    [self doInitWork];
}

#pragma mark resize
- (void)resizeFrameWithHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height+15;
    self.frame = frame;
    
}

- (CGFloat)requiredHeight
{
    return self.frame.size.height;
    
}

- (void)setPicUrl:(NSString *)picUrl
{
    if (![_picUrl isEqualToString:picUrl]) {
        _picUrl = [picUrl retain];
        
        NSString *qContent = self.weiyu[@"content"];
        
        CGSize qSzie =[qContent sizeWithFont:self.contentLabel.font
                           constrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, 500)
                               lineBreakMode:self.contentLabel.lineBreakMode];
        
        CGRect qFrame = self.contentLabel.frame;
        qFrame.size.height = qSzie.height;
        self.contentLabel.frame = qFrame;
        
        self.contentLabel.text = qContent;
        
        CGRect picFrame = self.showPicView.frame;
        picFrame.origin.y = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 5;
        self.showPicView.frame = picFrame;
        _photos = [[NSMutableArray alloc] initWithObjects:@{@"icon": picUrl, @"url": picUrl}, nil];
        
        [self.showPicView loadImage:picUrl];
        
        CGFloat totalH = self.showPicView.frame.origin.y+ self.showPicView.frame.size.height + 15 + 80;
        if (![self.weiyu[@"address"] isEqualToString:@""]) {
            self.addressView.hidden = NO;
            self.addressLabel.text = self.weiyu[@"address"];
            totalH += self.addressLabel.frame.size.height+10;
        }
        
        
        [self resizeFrameWithHeight: totalH];
        
    }
}

// P.S: 在IB中Image的位置要在第一，即在subviews的下标是0
- (void)setWeiyu:(NSMutableDictionary *)weiyu
{
    if (![_weiyu isEqualToDictionary:weiyu])
    {
        _weiyu = [weiyu retain];
        //        NSLog(@"weiyu detail: %@", _weiyu);
        // user info
        self.nameLabel.text = [[weiyu objectForKey:@"uinfo"] objectForKey:@"niname"];
        [self.avatarImageView loadImage:[[weiyu objectForKey:@"uinfo"] objectForKey:@"photo"]];
        
        // time label long
        self.addTimeDesc = [weiyu objectForKey:@"addtime_text"];
        
        // counters
        self.digoNum = [[weiyu objectForKey:@"digo"] integerValue];
        self.shitNum = [[weiyu objectForKey:@"shit"] integerValue];
        self.commentNum = [[weiyu objectForKey:@"comentcount"] integerValue];
        
        // from
        self.fromLabel.text = [NSString stringWithFormat:@"来自%@", [[weiyu objectForKey:@"vfrom"] objectForKey:@"name"]];
        
        self.picUrl = weiyu[@"pic"];
    }
    
}

#pragma mark - btns
- (IBAction)plusBtnAction:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(didChangeStatus:toStatus:)]) {
        [self.delegate didChangeStatus:self toStatus:@"plus"];
    }
}

- (IBAction)minusBtnAction:(UIButton*)sender
{
    
    if ([self.delegate respondsToSelector:@selector(didChangeStatus:toStatus:)]) {
        [self.delegate didChangeStatus:self toStatus:@"minus"];
    }
}

- (IBAction)commentBtnAction:(UIButton*)sender
{
    
    if ([self.delegate respondsToSelector:@selector(didChangeStatus:toStatus:)]) {
        [self.delegate didChangeStatus:self toStatus:@"comment"];
    }
}

#pragma  mark photo show

#pragma mark - slider views
-(void)addSliderView
{
    // Do any additional setup after loading the view from its nib.
    SliderView *pageView = [[[SliderView alloc] initWithFrame: self.window.frame
                                               withDataSource: self] autorelease];
    pageView.backgroundColor = [UIColor blackColor];
    [self.window addSubview:pageView];
    self.slider = pageView;
    
}

-(void)clearSliderView
{
    [self.slider removeFromSuperview];
    self.slider = nil;
    
}

-(int)numberOfPages
{
    return self.photos.count;
}

-(UIView *)viewAtIndex:(int)index
{
    UIScrollView *view = [[[UIScrollView alloc] initWithFrame:self.window.frame] autorelease];
    view.backgroundColor = [UIColor clearColor];
    view.opaque = YES;
    view.maximumZoomScale = 5.0;
    view.zoomScale = 1.0;
    view.minimumZoomScale = 1.0;
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.delegate = self;
    view.tag = index+100;
    UITapGestureRecognizer *oneTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerView:)] autorelease];
    oneTap.numberOfTapsRequired = 1;
    oneTap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:oneTap];
    
    UITapGestureRecognizer *doubleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerView:)] autorelease];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:doubleTap];
    
    UILongPressGestureRecognizer *longPress = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)] autorelease];
    [view addGestureRecognizer:longPress];
    
    [oneTap requireGestureRecognizerToFail:doubleTap];
    
    AsyncImageView *oldView = (AsyncImageView*)[self.mainView.subviews objectAtIndex:index];
    CGRect viewFrame = [self.mainView convertRect:oldView.frame toView:self.window];
    
    AsyncImageView *imView = [[[AsyncImageView alloc] initWithFrame:viewFrame] autorelease];
    NSDictionary *d = [self.photos objectAtIndex:index];
    
    imView.tag = index;
    
    [view addSubview:imView];
    
    CGSize size = view.frame.size;
    [imView.indicatorView startAnimating];
    [imView loadImage:[d objectForKey:@"url"] withPlaceholdImage:oldView.image withBlock:^{
        [imView.indicatorView stopAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            CGSize imgsize = imView.image.size;
            CGFloat imgWidth = MIN(imgsize.width, size.width);
            CGFloat imgHeight = imgWidth*imgsize.height/imgsize.width;
            
            imView.frame = CGRectMake((size.width-imgWidth)/2, (size.height - imgHeight)/2, imgWidth, imgHeight);
            
        }];
    }];
    
    return view;
}

- (void)tapImageGesture:(UITapGestureRecognizer*)gesture
{
    
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        NSInteger index = [self.mainView.subviews indexOfObject:gesture.view];
        [self addSliderView];
        [self.slider selectPageAtIndex:index];
        
    }
}

- (void)tapContainerView:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        if (gesture.numberOfTapsRequired == 1) {
            
            UIView *view = [self.mainView.subviews objectAtIndex:gesture.view.tag-100];
            CGRect viewFrame = [self.mainView convertRect:view.frame toView:gesture.view];
            
            AsyncImageView *imView = (AsyncImageView*)[gesture.view viewWithTag:gesture.view.tag-100];
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            self.slider.backgroundColor = [UIColor clearColor];
            self.slider.pageControl.hidden = YES;
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 imView.frame = viewFrame;
                             }
                             completion:^(BOOL finshed){
                                 [gesture.view removeFromSuperview];
                                 [self clearSliderView];
                             }];
        } else{
            UIScrollView *view = (UIScrollView*)gesture.view;
            if (view.zoomScale <= 1.0) {
                [view setZoomScale:3.0 animated:YES];
            } else{
                [view setZoomScale:1.0 animated:YES];
            }
        }
        
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan ||
        gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"保存图片",nil];
        self.curImageView = (UIImageView*)[gesture.view viewWithTag:gesture.view.tag-100];
        [actionSheet showInView:self.window];
        [actionSheet release];
        
    }
}

#pragma mark - ActionSheet Delegate Methods
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([actionSheet cancelButtonIndex] == buttonIndex) {
        return;
    }
    
    if (buttonIndex == 0){
        UIImageWriteToSavedPhotosAlbum(self.curImageView.image, nil, nil, nil);
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
    
    self.curImageView = nil;
}


#pragma mark - scroll view delegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIView *view = [scrollView viewWithTag:scrollView.tag-100];
    
    return view;
}


@end
