//
//  WeiyuWordCell.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "WeiyuWordCell.h"

#define DW 150.0f
#define DH 112.0f

@interface WeiyuWordCell ()

@property (strong, nonatomic) IBOutlet UIImageView *timeIconView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *plusBtn, *minusBtn, *commentBtn;
@property (strong, nonatomic) IBOutlet UIView *footerView, *mainView, *containerView, *addressView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel, *fromLabel, *addressLabel;

@property (nonatomic) NSInteger digoNum, shitNum, commentNum;
@property (strong, nonatomic) NSString *addTimeDesc, *content;
@property (strong, nonatomic) NSMutableArray *photos;

@end

@implementation WeiyuWordCell

- (void)dealloc
{
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
        for (UIView *view in [self.mainView subviews]) {
            [view removeFromSuperview];
        }
        
        UIFont *font = [UIFont systemFontOfSize:14.0f];
        CGSize size = [content sizeWithFont:font
                          constrainedToSize:CGSizeMake(self.mainView.frame.size.width, 2000)
                              lineBreakMode:UILineBreakModeCharacterWrap];
        UILabel *contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 5, size.width, size.height)] autorelease];
        contentLabel.font = font;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.opaque = YES;
        contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        contentLabel.numberOfLines = 0;
        contentLabel.text = content;
        [self.mainView addSubview:contentLabel];
        
        CGFloat addressH = 0;
        if (![[self.weiyu objectForKey:@"address"] isEqualToString:@""]) {
            self.addressView.hidden = NO;
            CGRect addFrame = self.addressView.frame;
            addFrame.origin.y = size.height + 6;
            self.addressView.frame = addFrame;
            addressH = self.addressView.frame.size.height + 6;
            self.addressLabel.text = [self.weiyu objectForKey:@"address"];
            [self.mainView addSubview:self.addressView];
        }
        [self resizeFrameWithHeight:MAX(size.height+addressH+10, 10.0f)];
    }
}

- (void)setPhotos:(NSMutableArray *)photos
{
    if (![_photos isEqualToArray:photos]) {
        _photos = [photos retain];
        
        // reset content
        _content = nil;
        
        for (UIView *view in [self.mainView subviews]) {
            [view removeFromSuperview];
        }
        
        CGFloat dHeight = 0;
        if (photos.count > 0) {
            if (photos.count == 1) {
                NSDictionary *d = [photos objectAtIndex:0];
                AsyncImageView *imView = [[[AsyncImageView alloc] initWithFrame:CGRectMake(0, 10, DW, DH)] autorelease];
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
                
                CGFloat w = 80;
                CGFloat h = 80*DH/DW;
                
                for (int i=0; i<rows; i++) {
                    for (int j=0; j<columns; j++) {
                        
                        if (i*columns+j >= photos.count) {
                            break;
                        }
                        
                        NSDictionary *d = [photos objectAtIndex:i*columns+j];
                        AsyncImageView *imView = [[[AsyncImageView alloc] initWithFrame:CGRectMake(0 + j*(w+2), 10 + i*(h+2), w, h)] autorelease];
                        [imView loadImage:[d objectForKey:@"icon"]];
                        [self.mainView addSubview:imView];
                    }

                }
                dHeight = rows*(h+2) + 10;

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
        
        [self resizeFrameWithHeight:dHeight+addressH+10];
    }
}

- (void)resizeFrameWithHeight:(CGFloat)height
{
    CGRect mainFrame = self.mainView.frame;
    mainFrame.size.height = height;
    self.mainView.frame = mainFrame;
    
    
    CGRect footerFrame = self.footerView.frame;
    footerFrame.origin.y = self.mainView.frame.origin.y + self.mainView.frame.size.height;
    self.footerView.frame = footerFrame;
    
    CGRect containerFrame = self.containerView.frame;
    containerFrame.size.height = self.footerView.frame.origin.y + self.footerView.frame.size.height;
    self.containerView.frame = containerFrame;
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
        } else{
            self.content = [weiyu objectForKey:@"oldcontent"];
        }
        
    }
    
}

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
