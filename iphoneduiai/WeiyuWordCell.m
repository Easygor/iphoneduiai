//
//  WeiyuWordCell.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "WeiyuWordCell.h"
#import "FullyLoaded.h"
#import "SliderView.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "FaqInnerView.h"

#define DW 150.0f
#define DH 112.0f

@interface WeiyuWordCell () <UIScrollViewDelegate, SliderDataSource, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *timeIconView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *plusBtn, *minusBtn, *commentBtn;
@property (strong, nonatomic) IBOutlet UIView *footerView, *mainView, *containerView, *addressView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel, *fromLabel, *addressLabel;

@property (strong, nonatomic) NSString *addTimeDesc, *content;
@property (strong, nonatomic) NSMutableArray *photos;
@property (retain, nonatomic) IBOutlet UIView *shadowView;

@property (strong, nonatomic) SliderView *slider;
@property (strong, nonatomic) UIImageView *curImageView;

@property (nonatomic) NSInteger state;
@property (strong, nonatomic) NSDictionary *faqInfo;

@end

@implementation WeiyuWordCell

- (void)dealloc
{
    self.slider.dataSource = nil;
    self.delegate = nil;
    [_timeIconView release];
    [_avaterImageView release];
    [_nameLabel release];
    [_mainView release];
    [_timeLabel release];
    [_plusBtn release];
    [_minusBtn release];
    [_commentBtn release];
    [_footerView release];
    [_fromLabel release];
    [_weiyu release];
    [_addTimeDesc release];
    [_content release];
    [_containerView release];
    [_photos release];
    [_slider release];
    [_curImageView release];
    [_shadowView release];
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

- (void)setContent:(NSString *)content
{
    if (![_content isEqualToString:content]) {
        _content = [content retain];
        
        // reset photos
        _photos = nil;
        _faqInfo = nil;
        
        for (UIView *view in [self.mainView subviews]) {
            [view removeFromSuperview];
        }
        
        UIFont *font = [UIFont systemFontOfSize:15.0f];
        CGSize size = [content sizeWithFont:font
                          constrainedToSize:CGSizeMake(235, 2000)
                              lineBreakMode:UILineBreakModeCharacterWrap];
        UILabel *contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(6, 15, size.width, size.height)] autorelease];
        contentLabel.font = font;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.opaque = YES;
        contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        contentLabel.numberOfLines = 0;
        contentLabel.text = content;

        AsyncImageView *imView = nil;
        if (![[self.weiyu objectForKey:@"pic"] isEqualToString:@""]) {
            imView = [[[AsyncImageView alloc] initWithFrame:CGRectMake(6, contentLabel.frame.size.height + 15, DW, DH)] autorelease];
            [imView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageGesture:)] autorelease]];
            //                imView.tag = 0;
            imView.userInteractionEnabled = YES;
            NSString *imgUrl = [self.weiyu objectForKey:@"pic"];
            [imView loadImage: imgUrl];
            _photos = [[NSMutableArray alloc] initWithObjects:@{@"icon": imgUrl, @"url": imgUrl}, nil];
            [self.mainView addSubview:imView];
        }
        
        [self.mainView addSubview:contentLabel];
        
        CGFloat totalH = size.height;
        if (imView) {
            totalH = imView.frame.origin.y + imView.frame.size.height;
        }
        
        if (![[self.weiyu objectForKey:@"address"] isEqualToString:@""]) {
            self.addressView.hidden = NO;
            CGRect addFrame = self.addressView.frame;
            if (imView) {
                addFrame.origin.y = imView.frame.origin.y + imView.frame.size.height + 10;
            } else{
                addFrame.origin.y = contentLabel.frame.origin.y + contentLabel.frame.size.height + 10;
            }
            
            self.addressView.frame = addFrame;
            totalH = self.addressView.frame.origin.y + self.addressView.frame.size.height;
            self.addressLabel.text = [self.weiyu objectForKey:@"address"];
            [self.mainView addSubview:self.addressView];
        }
        
        [self resizeFrameWithHeight:MAX(totalH+30, 15.0f)];
    }
}

- (void)setPhotos:(NSMutableArray *)photos
{
    if (![_photos isEqualToArray:photos]) {
        _photos = [photos retain];
        
        // reset content
        _content = nil;
        _faqInfo = nil;
        
        for (UIView *view in [self.mainView subviews]) {
            [view removeFromSuperview];
        }
        
        CGFloat dHeight = 0;
        if (photos.count > 0) {
            if (photos.count == 1) {
                NSDictionary *d = [photos objectAtIndex:0];
                AsyncImageView *imView = [[[AsyncImageView alloc] initWithFrame:CGRectMake(6, 15, DW, DH)] autorelease];
                [imView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageGesture:)] autorelease]];
//                imView.tag = 0;
                imView.userInteractionEnabled = YES;
                [imView loadImage:[d objectForKey:@"icon"]];
                [self.mainView addSubview:imView];
                
                dHeight = DH + 10;
            } else{
                int rows = 0;
                int columns = 0;
                if (photos.count == 2 || photos.count == 4) {
                    columns = 2;
                } else{
                    columns = 3;
                }
                
                rows = photos.count/columns + (photos.count%columns == 0 ? 0 : 1);
                
                CGFloat w = 75;
                CGFloat h = 75*DH/DW;
                
                for (int i=0; i<rows; i++) {
                    for (int j=0; j<columns; j++) {
                        NSInteger index = i*columns+j;
                        if (index >= photos.count) {
                            break;
                        }
                        
                        NSDictionary *d = [photos objectAtIndex:index];
                        AsyncImageView *imView = [[[AsyncImageView alloc] initWithFrame:CGRectMake(6 + j*(w+4), 15 + i*(h+4), w, h)] autorelease];
                        [imView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageGesture:)] autorelease]];
                        imView.userInteractionEnabled = YES;
//                        imView.tag = index;
                        [imView loadImage:[d objectForKey:@"icon"]];
                        [self.mainView addSubview:imView];
                    }

                }
                dHeight = rows*(h+4) + 10;

            }
        } else{
            dHeight = 10.0f;
        }
        
        CGFloat addressH = 0;
        if (![[self.weiyu objectForKey:@"address"] isEqualToString:@""]) {
            self.addressView.hidden = NO;
            CGRect addFrame = self.addressView.frame;
            addFrame.origin.y = dHeight + 6;
            self.addressView.frame = addFrame;
            addressH = self.addressView.frame.size.height + 6;
            self.addressLabel.text = [self.weiyu objectForKey:@"address"];
            [self.mainView addSubview:self.addressView];
        }
        
        [self resizeFrameWithHeight:dHeight+addressH+20];
    }
}

- (void)setFaqInfo:(NSDictionary *)faqInfo
{
    if (![_faqInfo isEqualToDictionary:faqInfo]) {
        _faqInfo = [faqInfo retain];
        
        // reset content
        _content = nil;
        _photos = nil;
        
        for (UIView *view in [self.mainView subviews]) {
            [view removeFromSuperview];
        }
        
        NSString *qContent = faqInfo[@"answer"];
        NSString *aContent = [NSString stringWithFormat:@"%@: %@", faqInfo[@"uinfo"][@"niname"], faqInfo[@"question"]];

        UILabel *qLabel = [[[UILabel alloc] initWithFrame:CGRectMake(6, 15, 235, 15)] autorelease];
        qLabel.font = [UIFont systemFontOfSize:15.0f];
        qLabel.numberOfLines = 0;
        qLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        qLabel.backgroundColor = [UIColor clearColor];
        qLabel.opaque = YES;
        
        CGSize qSzie =[qContent sizeWithFont:qLabel.font
                           constrainedToSize:CGSizeMake(qLabel.frame.size.width, 500)
                               lineBreakMode:UILineBreakModeCharacterWrap];
        qLabel.frame = CGRectMake(6, 15, 235, qSzie.height);
        qLabel.text = qContent;
        [self.mainView addSubview:qLabel];
        
        FaqInnerView *faqView = [[[FaqInnerView alloc] initWithFrame:CGRectMake(6, qLabel.frame.origin.y+qLabel.frame.size.height+10, 230, 15)] autorelease];
        faqView.innerContent = aContent;
        
        [self.mainView addSubview:faqView];
        
        [self resizeFrameWithHeight:faqView.frame.origin.y+faqView.frame.size.height+15];
        
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
}

- (void)awakeFromNib
{
    [self doInitWork];
    UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatarAction:)] autorelease];
    self.avaterImageView.userInteractionEnabled = YES;
    [self.avaterImageView addGestureRecognizer:singleTap];
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


#pragma mark resize pictures
- (void)resizeFrameWithHeight:(CGFloat)height
{
    CGRect mainFrame = self.mainView.frame;
    mainFrame.size.height = height;
    self.mainView.frame = mainFrame;
    
    
//    CGRect footerFrame = self.footerView.frame;
//    footerFrame.origin.y = self.mainView.frame.origin.y + self.mainView.frame.size.height;
//    self.footerView.frame = footerFrame;
    
    CGRect containerFrame = self.containerView.frame;
    containerFrame.size.height = self.mainView.frame.origin.y + self.mainView.frame.size.height + self.footerView.frame.size.height;
    self.containerView.frame = containerFrame;
    self.shadowView.frame = containerFrame;
}

- (CGFloat)requiredHeight
{
    return self.containerView.frame.origin.y + self.containerView.frame.size.height + 15;
}

- (void)setWeiyu:(NSMutableDictionary *)weiyu
{
    if (![_weiyu isEqualToDictionary:weiyu]) {
        _weiyu = [weiyu retain];

        // user info
        self.nameLabel.text = [[weiyu objectForKey:@"uinfo"] objectForKey:@"niname"];
        [self.avaterImageView loadImage:[[weiyu objectForKey:@"uinfo"] objectForKey:@"photo"]];
        
        // time label long
        self.addTimeDesc = [weiyu objectForKey:@"addtime_text"];
        
        // counters
        self.digoNum = [[weiyu objectForKey:@"digo"] integerValue];
        self.shitNum = [[weiyu objectForKey:@"shit"] integerValue];
        self.commentNum = [[weiyu objectForKey:@"comentcount"] integerValue];
        
        // from
        self.fromLabel.text = [NSString stringWithFormat:@"来自%@", [[weiyu objectForKey:@"vfrom"] objectForKey:@"name"]];
        
        // content
        if ([[weiyu objectForKey:@"photolist"] count] > 0) {
            self.photos = [weiyu objectForKey:@"photolist"];
        } else if([weiyu[@"vtype"] isEqualToString:@"faq"]) {

            self.faqInfo = weiyu[@"faqinfo"];   
        } else{
            self.content = [weiyu objectForKey:@"oldcontent"];
        } 
        
    }
    
}

- (void)willTransitionToState:(UITableViewCellStateMask)aState
{
    [super willTransitionToState:aState];
    self.state = aState;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    // no indent in edit mode
    self.contentView.frame = CGRectMake(0,
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width,
                                        self.contentView.frame.size.height);
    
    if (self.editing )
    {
//        NSLog(@"subview");
        float indentPoints = self.indentationLevel * self.indentationWidth;
        
        switch (self.state) {
            case 3:
                self.contentView.frame = CGRectMake(indentPoints,
                                                    self.contentView.frame.origin.y,
                                                    self.contentView.frame.size.width +124,// - indentPoints,
                                                    self.contentView.frame.size.height);
                
                break;
            case 2:
                // swipe action
                self.contentView.frame = CGRectMake(indentPoints,
                                                    self.contentView.frame.origin.y,
                                                    self.contentView.frame.size.width +75,// - indentPoints,
                                                    self.contentView.frame.size.height);
                
                break;
            default:
                // state == 1, hit edit button
                self.contentView.frame = CGRectMake(indentPoints,
                                                    self.contentView.frame.origin.y,
                                                    self.contentView.frame.size.width +80,// - indentPoints,
                                                    self.contentView.frame.size.height);  
                break;
        }
    }
}

//-(void)layoutSubviews
//{
//    if ([self isEditing] == NO) {
//        // Lay out subviews normally.
//        [super layoutSubviews];
//    }
//}

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

#pragma mark - scroll view delegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIView *view = [scrollView viewWithTag:scrollView.tag-100];

    return view;
}

@end
