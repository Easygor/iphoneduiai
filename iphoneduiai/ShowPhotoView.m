//
//  ShowPhotoView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "ShowPhotoView.h"
#import "RoundThumbView.h"
#import <QuartzCore/QuartzCore.h>
#import "SliderView.h"
#import "Utils.h"
#import "SVProgressHUD.h"

@interface ShowPhotoView () <SliderDataSource, UIScrollViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSMutableArray *rounds;
@property (strong, nonatomic) IBOutlet AsyncImageView *showImageView;
//@property (strong, nonatomic) IBOutlet CountView *viewCountView;
@property (strong, nonatomic) SliderView *slider;
@property (strong, nonatomic) UIImageView *curImageView;

@end

@implementation ShowPhotoView
@synthesize photos=_photos;

- (void)dealloc
{
    self.delegate = nil;
    self.slider.dataSource = nil;
    [_scrollView release];
    [_showImageView release];
    [_photos release];
//    [_viewCountView release];
    [_curImageView release];
    [_slider release];
    [_rounds release];
    [_containerView release];
    [_slider release];
    [super dealloc];
}

- (NSMutableArray *)rounds
{
    if (_rounds == nil) {
        _rounds = [[NSMutableArray alloc] init];
    }
    
    return _rounds;
}

- (NSMutableArray *)photos
{
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    
    return _photos;
}

- (void)setPhotos:(NSMutableArray *)photos
{
    if (![_photos isEqualToArray:photos]) {
//        _photos = [photos retain];
         _photos = [[NSMutableArray alloc] init];
        // init the thumbs
        int i=0;
        for (NSDictionary *d in photos) {
            if ([[d objectForKey:@"class"] isEqualToString:@"show"] ||
                [[d objectForKey:@"class"] isEqualToString:@"show selected"]) {

                RoundThumbView *view = [[[RoundThumbView alloc] initWithFrame:CGRectMake(5+50*i, 3, 46, 46)
                                                                        image:[d objectForKey:@"icon"]
                                                                       target:self
                                                                  forSelector:@selector(gestureAction:)] autorelease];
                view.tag = i;
                [self.scrollView addSubview:view];
                [self.rounds addObject:view];
                [_photos addObject:d];
            }

            i++;
        }
        
        [self resizeScrollView];
        self.scrollView.scrollEnabled = YES;
        if (self.rounds.count > 0) {
            RoundThumbView *firstView = [self.rounds objectAtIndex:0];
            [self selectedRoundView:firstView del:NO];

        }
        
    }
}

- (void)doInitWork
{
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.containerView.layer.shadowRadius = 1.0f;
    self.containerView.layer.shadowOpacity = 0.30;
    self.containerView.layer.masksToBounds = NO;
    self.containerView.layer.shouldRasterize = YES;
    
    [self.showImageView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageGesture:)] autorelease]];
    self.showImageView.userInteractionEnabled = YES;
    self.showImageView.tag = -1;
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
}

- (void)awakeFromNib
{
    [self doInitWork];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self doInitWork];
    }
    return self;
}


- (void)resizeScrollView
{
    RoundThumbView *lastView = [self.rounds lastObject];
    
    self.scrollView.contentSize = CGSizeMake(lastView.frame.origin.x + lastView.frame.size.width+5, self.scrollView.contentSize.height);
}

- (void)insertPhoto:(NSMutableDictionary*)d atIndex:(NSInteger)index
{
    
    for (int i=self.rounds.count-1; i>=index; i--) {
        UIView *view = [self.rounds objectAtIndex:i];
        view.tag += 1;
        CGRect vFrame = view.frame;
        vFrame.origin.x += 50;
        view.frame = vFrame;
    }
    
    RoundThumbView *round = [[[RoundThumbView alloc] initWithFrame:CGRectMake(5+50*index, 3, 46, 46)
                                                            image:[d objectForKey:@"icon"]
                                                           target:self
                                                      forSelector:@selector(gestureAction:)] autorelease];
    
    if (![d[@"action"] isEqualToString:@"add"]) {
        round.editing = self.editing;
    }

    round.tag = index;
    [self.scrollView addSubview:round];
    [self.rounds insertObject:round atIndex:index];
    [self.photos insertObject:d atIndex:index];
    
    [self resizeScrollView];

}

- (void)removePhotoAt:(NSInteger)index
{
    if (self.rounds.count <= 0) {
        return;
    }
    
    UIView *view = [self.rounds objectAtIndex:index];
    [view removeFromSuperview];
    
    for (int i=index; i<self.rounds.count; i++) {
        UIView *view = [self.rounds objectAtIndex:i];
        view.tag -= 1;
        CGRect vFrame = view.frame;
        vFrame.origin.x -= 50;
        view.frame = vFrame;
    }
    
    [self.rounds removeObjectAtIndex:index];
    [self.photos removeObjectAtIndex:index];
    
    [self resizeScrollView];
    
    if (self.editing) {
        if (self.rounds.count > 1) {
            RoundThumbView *round = [self.rounds objectAtIndex:MAX(1, index-1)];
            [self selectedRoundView:round del:NO];
        } else{
            self.showImageView.image = nil;
        }
    }
    
}

- (void)setEditing:(BOOL)editing
{
    if (_editing != editing) {
        _editing = editing;
        if (editing) {
            // loading
            NSMutableDictionary *d = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"set_addpic_icon", @"icon", @"add", @"action", nil];
            for (RoundThumbView *v  in self.rounds) {
                v.editing = YES;
            }
            [self insertPhoto:d atIndex:0];
        } else{
            // editing
            [self removePhotoAt:0];
            for (RoundThumbView *v  in self.rounds) {
                v.editing = NO;
            }
        }
    }
    
}

- (void)selectRoundAt:(NSInteger)index
{
    if (index < 0 || index >= self.rounds.count) {
        return;
    }
    
    RoundThumbView *view = (RoundThumbView*)[self.rounds objectAtIndex:index];
    [self selectedRoundView:view del:NO];
    
}

- (void)selectedRoundView:(RoundThumbView*)tv del:(BOOL)isDel
{
    int i = 0;
    for (RoundThumbView *view in self.rounds) {
        if ([view isEqual:tv]) {
            NSDictionary *d = [self.photos objectAtIndex:view.tag];
            
            if ([d[@"action"] isEqualToString:@"add"]) {

                if ([self.delegate respondsToSelector:@selector(didTriggerAddPhotoAction:)]) {
                    [self.delegate didTriggerAddPhotoAction:self];
                }
                break;
            } else{
                view.selected = YES;
                NSString *iconUrl = [d objectForKey:@"icon"];
                
                if ([d[@"icon"] hasSuffix:@".thumb.jpg"]) {
                    iconUrl = [iconUrl substringToIndex:iconUrl.length - [@".thumb.jpg" length]];
                }
                [self.showImageView loadImage:iconUrl];
                self.showImageView.tag = i;
                
                if (isDel && self.editing && [self.delegate respondsToSelector:@selector(didTriggerDelPhotoAction:at:)]) {
                    NSLog(@"im trigger");
                    [self.delegate didTriggerDelPhotoAction:self at:view.tag];
                }
            }


            
        } else{
            view.selected = NO;
        }
        
        i++;
    }
}

- (void)gestureAction:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        RoundThumbView *tv = (RoundThumbView *)gesture.view;
        [self selectedRoundView:tv del:YES];
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
    if (self.editing) {
        return self.photos.count - 1;
    }
    
    return self.photos.count;
}

-(UIView *)viewAtIndex:(int)index
{
    if (self.editing) {
        index += 1;
    }
    
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
    
    [oneTap requireGestureRecognizerToFail:doubleTap];
    
    UILongPressGestureRecognizer *longPress = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)] autorelease];
    [view addGestureRecognizer:longPress];
    
    CGRect viewFrame = [self convertRect:self.showImageView.frame toView:self.window];
    
    AsyncImageView *imView = [[[AsyncImageView alloc] initWithFrame:viewFrame] autorelease];
    NSDictionary *d = [self.photos objectAtIndex:index];
    
    imView.tag = index;
    
    [view addSubview:imView];
    NSString *iconUrl = [d objectForKey:@"icon"];

    CGSize size = view.frame.size;
    [imView startAnimating];
    [imView loadImage:[iconUrl substringToIndex:iconUrl.length - [@".thumb.jpg" length]]
   withPlaceholdImage:self.showImageView.image withBlock:^{
       [imView stopAnimating];
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
        NSInteger index = gesture.view.tag;
        if (index >= 0) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            
            [self addSliderView];
            [self.slider selectPageAtIndex:index];
        }
 
    }
}

- (void)tapContainerView:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        if (gesture.numberOfTapsRequired == 1) {
            
            CGRect viewFrame = [self convertRect:self.showImageView.frame toView:gesture.view];
            
            AsyncImageView *imView = (AsyncImageView*)[gesture.view viewWithTag:gesture.view.tag-100];
            [self selectedRoundView:[self.rounds objectAtIndex:gesture.view.tag-100] del:NO];
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            self.slider.backgroundColor = [UIColor clearColor];
            
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

#pragma mark - scroll view delegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIView *view = [scrollView viewWithTag:scrollView.tag-100];
    
    return view;
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


@end
