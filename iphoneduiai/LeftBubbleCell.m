//
//  LeftBubbleCell.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-11.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "LeftBubbleCell.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate-Utilities.h"

#define TEXTW 185

@interface LeftBubbleCell ()

@property (strong, nonatomic) IBOutlet UIImageView *bubbleImageView;
@property (strong, nonatomic) UILabel *contentLabel, *timeLabel;

@end

@implementation LeftBubbleCell



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_avatarImageView release];
    [_bubbleImageView release];
    [_indicatorView release];
    [_content release];
    [_imageUrl release];
    [_contentLabel release];
    [_timeLabel release];
    [super dealloc];
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = UITextAlignmentCenter;
        _timeLabel.backgroundColor = RGBACOLOR(0, 0, 0, 0.25);
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.layer.cornerRadius = 3.0f;
    }
    
    return _timeLabel;
}

- (void)setDate:(NSDate *)date
{
    if (![_date isEqualToDate:date]) {
        _date = [date retain];
        
        if (date) {
            self.timeLabel.text = self.timeLabel.text = [self.date stringForHumanLongStyle];/* [self.date stringWithPattern:@"MM-dd HH:mm"]*/;;
            [self.timeLabel sizeToFit];
            
            CGRect timeFrame = self.timeLabel.frame;
            timeFrame.origin.x = (self.frame.size.width - self.timeLabel.frame.size.width)/2;
            timeFrame.origin.y = self.bubbleImageView.frame.origin.y + self.bubbleImageView.frame.size.height + 5;
            timeFrame.size.width += 8;
            timeFrame.size.height += 4;
            self.timeLabel.frame = timeFrame;
            [self.contentView addSubview:self.timeLabel];
        } else{
            [self.timeLabel removeFromSuperview];
        }
    }
}


- (void)doInitWork
{
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 4.0f;
    UILongPressGestureRecognizer *longPress = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressGestureAction:)] autorelease];
    longPress.minimumPressDuration = 1.0;
    self.bubbleImageView.userInteractionEnabled = YES;
    [self.bubbleImageView  addGestureRecognizer:longPress];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideEditMenu) name:UIMenuControllerWillHideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideEditMenu) name:UIMenuControllerDidHideMenuNotification object:nil];
}

//- (void)willHideEditMenu
//{
//    self.bubbleImageView.highlighted = NO;
//}

- (void)didHideEditMenu
{
    self.bubbleImageView.highlighted = NO;
}

- (void)awakeFromNib
{
    [self doInitWork];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)pressGestureAction:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan ||
        gesture.state == UIGestureRecognizerStateChanged) {
        
        UIMenuController *mc = [UIMenuController sharedMenuController];
        if (![mc isMenuVisible]) {
            self.bubbleImageView.highlighted = YES;
            [self becomeFirstResponder];
            [[UIMenuController sharedMenuController] setTargetRect:gesture.view.frame inView:gesture.view.superview];
            [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        }
        
    }
}

- (void)copy:(id)sender
{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.content;
    
    [self resignFirstResponder];
    self.bubbleImageView.highlighted = NO;
    
}

- (void)delete:(id)sender
{

    [self resignFirstResponder];
    self.bubbleImageView.highlighted = NO;
    
    if ([self.delegate respondsToSelector:@selector(didChangeStatus:toStatus:)]) {
        [self.delegate didChangeStatus:self toStatus:nil];
    }
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if (action == @selector(copy:)) {
        return YES;
    } else if(action == @selector(delete:)){
        return YES;
    }
    
    return [super canPerformAction:action withSender:sender];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self doInitWork];
    }
    return self;
}


- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:16.0f];
        _contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.opaque = YES;
        _contentLabel.numberOfLines = 0;
    }
    
    return _contentLabel;
}

- (void)setContent:(NSString *)content
{
    if (![_content isEqualToString:content]) {
        _content = [content retain];

        CGSize size = [content sizeWithFont:self.contentLabel.font
                          constrainedToSize:CGSizeMake(TEXTW, 10000)
                              lineBreakMode:UILineBreakModeCharacterWrap];

        self.contentLabel.frame = CGRectMake(15, 11, TEXTW, size.height);
        self.contentLabel.text = content;
        [self.contentLabel sizeToFit];
        
        UIImage *bgImage = [self.bubbleImageView.image stretchableImageWithLeftCapWidth:20 topCapHeight:30];
        UIImage *hlbgImage = [self.bubbleImageView.highlightedImage stretchableImageWithLeftCapWidth:20 topCapHeight:30];
        CGRect bFrame = self.bubbleImageView.frame;
        bFrame.size.width = MAX(self.contentLabel.frame.size.width+self.contentLabel.frame.origin.x+15, 58);
        bFrame.size.height = MAX(self.contentLabel.frame.size.height+self.contentLabel.frame.origin.y+10, 45);
        self.bubbleImageView.frame = bFrame;
        self.bubbleImageView.image = bgImage;
        self.bubbleImageView.highlightedImage = hlbgImage;
        
        CGRect iFrame = self.indicatorView.frame;
        iFrame.origin.x = self.bubbleImageView.frame.size.width + self.bubbleImageView.frame.origin.x + 8;
        self.indicatorView.frame = iFrame;
//        [self.indicatorView startAnimating];

        [self.bubbleImageView addSubview:self.contentLabel];
        
    }
}

- (CGFloat)requiredHeight
{
    if (self.timeLabel.superview != nil) {
        return self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 15;
    } else{
        return self.bubbleImageView.frame.origin.y + self.bubbleImageView.frame.size.height + 15;
    }
}

- (void)setImageUrl:(NSString *)imageUrl
{
    if (![_imageUrl isEqualToString:imageUrl]) {
        _imageUrl = [imageUrl retain];
        
        // do here
    }
}

@end
