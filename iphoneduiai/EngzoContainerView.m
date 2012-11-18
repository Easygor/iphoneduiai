//
//  EngzoContainerView.m
//  engzo2
//
//  Created by Cloud Dai on 12-11-4.
//  Copyright (c) 2012年 Engzo. All rights reserved.
//

#import "EngzoContainerView.h"

@interface EngzoContainerView ()

@property (strong, nonatomic) UIImage *resizeableImage;
@property (strong, nonatomic) UIImageView *bgImageView;

@end

@implementation EngzoContainerView

- (void)setWidth:(CGFloat)width
{
    if (ABS(_width - width) > 0.1) {
        _width = width;
        
        CGRect selfFrame = self.frame;
        selfFrame.size.width = width;
        self.frame = selfFrame;
        
//        self.bgImageView.image = self.resizeableImage;
    }
}

- (void)setHeight:(CGFloat)height
{
    if (ABS(_height - height) > 0.1) {
        _height = height;
        
        CGRect selfFrame = self.frame;
        selfFrame.size.height = height;
        self.frame = selfFrame;
        
//         self.bgImageView.image = self.resizeableImage;
    }
}

- (void)layoutSubviews
{
     self.bgImageView.image = self.resizeableImage;
}

- (UIImage *)resizeableImage
{
    if (_resizeableImage == nil) {
        _resizeableImage = [[UIImage imageNamed:@"faq_bg"] stretchableImageWithLeftCapWidth:27 topCapHeight:20];
    }
    
    return _resizeableImage;
}

- (void)doInitWork
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = YES;
    //
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.bgImageView.image = self.resizeableImage;
 
    [self insertSubview:self.bgImageView atIndex:0];
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
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

@end
