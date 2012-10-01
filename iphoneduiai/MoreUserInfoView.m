//
//  MoreUserInfoView.m
//  iphoneduiai
//
//  Created by Cloud Dai on 12-10-1.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "MoreUserInfoView.h"
#define INIH 38

@interface MoreUserInfoView ()

@property (strong, nonatomic) IBOutlet UILabel *attentionLabel, *bookLabel, *sportLabel, *foodLabel, *aihaoLabel, *travelLabel, *movieLabel;

@end

@implementation MoreUserInfoView

- (void)dealloc
{
    [_attentionLabel release];
    [_bookLabel release];
    [_sportLabel release];
    [_foodLabel release];
    [_aihaoLabel release];
    [_travelLabel release];
    [_movieLabel release];
    [super dealloc];
}

- (void)setMoreUserInfo:(NSDictionary *)moreUserInfo
{
    if (![_moreUserInfo isEqualToDictionary:moreUserInfo]) {
        _moreUserInfo = [moreUserInfo retain];
        self.attentionLabel.text = [moreUserInfo objectForKey:@"attention"];
        self.bookLabel.text = [moreUserInfo objectForKey:@"book"];
        self.sportLabel.text = [moreUserInfo objectForKey:@"sports"];
        self.foodLabel.text = [moreUserInfo objectForKey:@"food"];
        self.aihaoLabel.text = [moreUserInfo objectForKey:@"interest"];
        self.travelLabel.text = [moreUserInfo objectForKey:@"travel"];
        self.movieLabel.text = [moreUserInfo objectForKey:@"influential_movie"];
    }
}

- (void)showMeInView:(UIView *)view atPoint:(CGPoint)pos animated:(BOOL)animated
{

CGRect selfFrame = self.frame;
selfFrame.origin.x = pos.x;
selfFrame.origin.y = pos.y;

if (animated) {
    
    self.frame = CGRectMake(selfFrame.origin.x, selfFrame.origin.y, selfFrame.size.width, INIH);;
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(selfFrame.origin.x, selfFrame.origin.y, selfFrame.size.width, selfFrame.size.height);
    }];
    
} else{
    self.frame = selfFrame;
    [view addSubview:self];
}
}

- (void)removeMeWithAnimated:(BOOL)animated
{
    
    CGRect selfFrame = self.frame;
    
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, INIH);
                         } completion:^(BOOL finshed){
                             [self removeFromSuperview];
                             self.frame = selfFrame;
                         }];
    } else{
        [self removeFromSuperview];
    }
}


@end
