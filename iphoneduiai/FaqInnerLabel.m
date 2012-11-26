//
//  FaqInnerLabel.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-11-27.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "FaqInnerLabel.h"

@interface FaqInnerLabel ()

@property (strong, nonatomic) IBOutlet UILabel *innerLabel;

@end

@implementation FaqInnerLabel

- (void)dealloc
{
    [_innerContent release];
    [_innerLabel release];
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setInnerContent:(NSString *)innerContent
{
    if (![_innerContent isEqualToString:innerContent]) {
        _innerContent = [innerContent retain];
        // en label size
        
        CGSize enSize = [innerContent sizeWithFont:self.innerLabel.font
                                 constrainedToSize:CGSizeMake(self.innerLabel.bounds.size.width, 500)
                                     lineBreakMode:self.innerLabel.lineBreakMode];
        CGRect enFrame = self.innerLabel.frame;
        enFrame.size.height = enSize.height;
        self.innerLabel.frame = enFrame;
        
        self.innerLabel.text = innerContent;
        
        self.height = [self requiredHeight];
        
    }
}

- (CGFloat)requiredHeight
{
    return  self.innerLabel.frame.origin.y*2 + self.innerLabel.frame.size.height;
}

@end
