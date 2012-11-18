//
//  FaqInnerView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-11-17.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "FaqInnerView.h"

@interface FaqInnerView ()

@property (strong, nonatomic) UILabel *innerLabel;

@end

@implementation FaqInnerView

- (void)setInnerContent:(NSString *)innerContent
{
    if (![_innerContent isEqualToString:innerContent]) {
        _innerContent = innerContent;
        // en label size
        
        CGSize enSize = [innerContent sizeWithFont:self.innerLabel.font
                                           constrainedToSize:CGSizeMake(self.innerLabel.bounds.size.width, 500)
                                               lineBreakMode:UILineBreakModeCharacterWrap];
        CGRect enFrame = self.innerLabel.frame;
        enFrame.size.height = enSize.height;
        self.innerLabel.frame = enFrame;
        
        self.innerLabel.text = innerContent;
        
        self.height = [self requiredHeight];
        
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.innerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 210, 14)];
        self.innerLabel.font = [UIFont systemFontOfSize:14.0f];
        self.innerLabel.textColor = RGBCOLOR(137, 137, 137);
        self.innerLabel.backgroundColor = [UIColor clearColor];
        self.innerLabel.opaque = YES;
        self.innerLabel.numberOfLines = 0;
        
        [self addSubview:self.innerLabel];
        
    }
    return self;
}

- (CGFloat)requiredHeight
{
    return  self.innerLabel.frame.origin.y*2 + self.innerLabel.frame.size.height;
}

@end
