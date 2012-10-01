//
//  RoundThumbView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-9-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "RoundThumbView.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface RoundThumbView ()

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

- (id)initWithFrame:(CGRect)frame image:(NSString*)imageUrl target:(id)delegate forSelector:(SEL)gestureAction
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        AsyncImageView *center = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
        [center loadImage:imageUrl];
        center.layer.cornerRadius = 50;
        center.layer.masksToBounds = YES;
        [self addSubview:center];
        self.roundCenterView = center;
        
        UIImageView *view = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        view.image = [UIImage imageNamed:@"picbox.png"];
        [self addSubview:view];
        self.roundImageView = view;
        
        [self addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:delegate action:gestureAction] autorelease]];
    }
    return self;
}

@end
