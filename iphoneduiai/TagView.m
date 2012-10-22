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
@property (nonatomic) CGFloat oldWith;

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
    self.bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

- (void)awakeFromNib
{
    [self doInitWork];
}

- (void)setContent:(NSString *)content
{
    if (![_content isEqualToString:content]) {
        _content = [content retain];
        
        self.descLabel.text = content;
        [self.descLabel sizeToFit];
        
        CGRect selfFrame = self.frame;
        selfFrame.size.width = MAX(self.descLabel.frame.size.width + self.descLabel.frame.origin.x + self.oldWith/4, self.oldWith);
        self.frame = selfFrame;
        
        UIImage *image = [self.bgImageView.image stretchableImageWithLeftCapWidth:self.oldWith/2 topCapHeight:0];
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
