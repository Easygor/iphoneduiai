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
@property (strong, nonatomic) UIImageView *delLogo;

@end

@implementation RoundThumbView

- (void)setEditing:(BOOL)editing
{
    if (_editing != editing) {
        _editing = editing;
        
        if (editing) {
            self.delLogo.hidden = NO;
        } else{
            self.delLogo.hidden = YES;
        }
    }
}

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
        AsyncImageView *center = [[[AsyncImageView alloc] initWithFrame:CGRectMake(1, 1, frame.size.width-2, frame.size.height-2)] autorelease];
        if ([imageUrl hasPrefix:@"http://"]) {
            [center loadImage:imageUrl];
        } else{
            center.image = [UIImage imageNamed:imageUrl ];
        }
        
        center.layer.cornerRadius = frame.size.width/2-1;
        center.layer.masksToBounds = YES;
        [self addSubview:center];
        self.roundCenterView = center;
        
        UIImageView *view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        view.image = [UIImage imageNamed:@"picbox.png"];
        [self addSubview:view];
        self.roundImageView = view;
        
        [self addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:delegate action:gestureAction] autorelease]];
        
        UIImageView *logo = [[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-20, 0, 20, 20)] autorelease];
        logo.image = [UIImage imageNamed:@"DeleteGroupMemberBtn.png"];
        logo.hidden = YES;
        [self addSubview:logo];
        self.delLogo = logo;
        
    }
    
    return self;
}

@end
