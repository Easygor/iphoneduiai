//
//  TagView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-22.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "TagView.h"

@interface TagView ()

@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic) CGFloat oldWith, oldHeight;

@end

@implementation TagView

- (void)dealloc
{
    [_descLabel release];
    [_bgImageView release];
    [_content release];
    [super dealloc];
}

- (void)doInitWork
{
    self.oldWith = self.bgImageView.frame.size.width;
    self.oldHeight = self.bgImageView.frame.size.height;
    self.bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
}

- (void)awakeFromNib
{
    [self doInitWork];
}

- (void)setContent:(NSString *)content
{
    if (![_content isEqualToString:content]) {
        _content = [content retain];
        
        CGSize size = [content sizeWithFont:self.descLabel.font];
        CGRect descFrame = self.descLabel.frame;
        descFrame.size.width = size.width;
        self.descLabel.frame = descFrame;
        self.descLabel.text = content;
        
        CGRect selfFrame = self.frame;
        selfFrame.size.width = MAX(self.descLabel.frame.size.width + self.descLabel.frame.origin.x + self.oldWith/4, self.oldWith);
        self.frame = selfFrame;
        
        UIImage *image = nil;
        if ([self.bgImageView.image respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
            image = [self.bgImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(self.oldHeight/2, self.oldWith/2, self.oldHeight/2, self.oldWith/5)];
        } else {
            image = [self.bgImageView.image stretchableImageWithLeftCapWidth:self.oldWith/2 topCapHeight:0];
        }
        self.bgImageView.image = image;
        
    }
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



@end
