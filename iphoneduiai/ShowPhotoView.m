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

@interface ShowPhotoView ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSMutableArray *rounds;
@property (strong, nonatomic) IBOutlet AsyncImageView *showImageView;
@property (strong, nonatomic) IBOutlet CountView *viewCountView;

@end

@implementation ShowPhotoView

- (void)dealloc
{
    [_scrollView release];
    [_showImageView release];
    [_photos release];
    [super dealloc];
}

- (NSArray *)rounds
{
    if (_rounds == nil) {
        _rounds = [[NSMutableArray alloc] init];
    }
    
    return _rounds;
}

- (void)setPhotos:(NSArray *)photos
{
    if (![_photos isEqualToArray:photos]) {
        _photos = [photos retain];

        // init the thumbs
        int i=0;
        for (NSDictionary *d in self.photos) {
            if ([[d objectForKey:@"class"] isEqualToString:@"show"] ||
                [[d objectForKey:@"class"] isEqualToString:@"show selected"]) {

                RoundThumbView *view = [[[RoundThumbView alloc] initWithFrame:CGRectMake(5+50*i, 3, 46, 46)
                                                                        image:[d objectForKey:@"icon"]
                                                                       target:self
                                                                  forSelector:@selector(gestureAction:)] autorelease];
                view.tag = i;
                [self.scrollView addSubview:view];
                [self.rounds addObject:view];
            }

            i++;
        }
        
        RoundThumbView *lastView = [self.rounds lastObject];

        self.scrollView.contentSize = CGSizeMake(lastView.frame.origin.x + lastView.frame.size.width+5, self.scrollView.contentSize.height);
        self.scrollView.scrollEnabled = YES;
        if (self.rounds.count > 0) {
            RoundThumbView *firstView = [self.rounds objectAtIndex:0];
            [self selectedRoundView:firstView];

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

- (void)selectedRoundView:(RoundThumbView*)tv
{
    for (RoundThumbView *view in self.rounds) {
        if ([view isEqual:tv]) {
            NSDictionary *d = [self.photos objectAtIndex:view.tag];
            
            view.selected = YES;
            NSString *iconUrl = [d objectForKey:@"icon"];
            [self.showImageView loadImage:[iconUrl substringToIndex:iconUrl.length - [@".thumb.jpg" length]]];
            self.viewCountView.count = [d objectForKey:@"score"];
        } else{
            view.selected = NO;
        }
    }
}

- (void)gestureAction:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        RoundThumbView *tv = (RoundThumbView *)gesture.view;
        [self selectedRoundView:tv];
    }
}

@end
