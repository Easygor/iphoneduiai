//
//  RoundThumbView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "RoundThumbView.h"
#import "AsyncImageView.h"

@interface RoundThumbView ()

@property (nonatomic) BOOL selected;
@property (strong, nonatomic) UIImageView *roundImageView;
@property (strong, nonatomic) AsyncImageView *roundCenterView;

@end

@implementation RoundThumbView

- (void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        _selected = selected;
        
        if (selected) {
            self.roundImageView.image = [UIImage imageNamed:@"picbox_selected.png"];
        } else{
            self.roundImageView.image = [UIImage imageNamed:@"picbox.png"];
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
