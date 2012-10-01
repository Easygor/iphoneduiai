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
            RoundThumbView *view = [[[RoundThumbView alloc] initWithFrame:CGRectMake(5+50*i, 2, 46, 46)
                                                                    image:[d objectForKey:@"thumb"]
                                                                   target:self
                                                              forSelector:@selector(gestureAction:)] autorelease];
            view.tag = i;
            [self.scrollView addSubview:view];
            [self.rounds addObject:view];
            i++;
        }
    }
}

- (void)doInitWork
{
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.containerView.layer.shadowRadius = 1.0f;
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

- (void)gestureAction:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        RoundThumbView *tv = (RoundThumbView *)gesture.view;
        for (RoundThumbView *view in self.rounds) {
            if ([view isEqual:tv]) {
                view.selected = YES;
                [self.showImageView loadImage:[[self.photos objectAtIndex:view.tag] objectForKey:@"image"]];
            } else{
                view.selected = NO;
            }
        }

    }
}

@end
