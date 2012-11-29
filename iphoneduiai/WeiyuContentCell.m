//
//  WeiyuContentCell.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-11-27.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "WeiyuContentCell.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface WeiyuContentCell ()

@property (retain, nonatomic) IBOutlet AsyncImageView *avatarImageView;
@property (retain, nonatomic) IBOutlet UIView *shadowView;
@property (retain, nonatomic) IBOutlet UIView *containerView;
@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel, *fromLabel, *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *plusBtn, *minusBtn, *commentBtn;
@property (strong, nonatomic) IBOutlet UIImageView *timeIconView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UIView *addressView;

@property (strong, nonatomic) NSString *addTimeDesc, *content;

@end

@implementation WeiyuContentCell

- (void)dealloc {
    self.delegate = nil;
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
    [_content release];
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

- (void)setContent:(NSString *)content
{
    if (![_content isEqualToString:content])
    {
        _content = [content retain];
        
        CGSize size = [content sizeWithFont:self.contentLabel.font
                          constrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, 2000)
                              lineBreakMode:self.contentLabel.lineBreakMode];
        CGRect contentFrame =  self.contentLabel.frame;
        contentFrame.size.height = size.height;
        self.contentLabel.frame = contentFrame;

        CGFloat totalH = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 80 + 15;
        if (![self.weiyu[@"address"] isEqualToString:@""])
        {
            self.addressView.hidden = NO;
            self.addressLabel.text = self.weiyu[@"address"];
            totalH += self.addressLabel.frame.size.height;
        }
        else
        {
            self.addressView.hidden = YES;
        }
        
        [self resizeFrameWithHeight:totalH];
        
        self.contentLabel.text = content;
    }
}


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
        
        self.content = [weiyu objectForKey:@"content"];
        

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

@end
